// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "./AssetManagement.sol";
import "./DRExToken.sol";

contract Client is ChainlinkClient {
    using Chainlink for Chainlink.Request;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    uint256 public volume;
    address payable public nft_contract;
    address public drex_token_contract;
    uint256 public curr_volume;

    //events
    event Token_Transfer(uint256 transferd_amout);

    /**
    This example uses the LINK token address on Moonbase Alpha.
    Make sure to update the oracle and jobId.
    */
    constructor(address payable nft_address, address erc20_address) {
        setChainlinkToken(address(0xa36085F69e2889c224210F603D836748e7dC0088));
        oracle = 0xD4D9ac4ecF5dDf18056ce6A91d0a8E7B0c910ccE;
        jobId = "79abc1e36be340a697e2b49dd2d86798";
        fee = 0;
        nft_contract = nft_address;
        drex_token_contract = erc20_address;
        curr_volume = 0;
    }

    /**
     * Create a Chainlink request to retrieve API response, find the target
     * data, then multiply by 1000000000000000000 (to remove decimal places from data).
     */

    /// @notice This functions sends requests on the end point and calls the fulfill function to update the volume
    /// @return requestId
    function request_sensor_data() public returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );

        // Set the URL to perform the GET request on
        request.add(
            "get",
            "http://drexall-env.eba-e3mnnm69.us-east-1.elasticbeanstalk.com/grid/last?code=drex_pilot"
        );

        // Set the path to find the desired data in the API response, where the response format is:

        request.add("path", "energy-accumulated");

        // Multiply the result by 1000000000000000000 to remove decimals
        int256 timesAmount = 10**18;
        request.addInt("times", timesAmount);

        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    /**
     * Receive the response in the form of uint256
     */
    function fulfill(bytes32 _requestId, uint256 _volume)
        public
        recordChainlinkFulfillment(_requestId)
    {
        volume = _volume;
    }

    ///@notice This function makes intercontract calls and transfers the erc20 tokens to nft contract and updates the balance for each nft holder

    function token_transfer() public {
        uint256 amt_generated = volume - curr_volume;
        curr_volume = volume;
        IUpdateBalance nfti = IUpdateBalance(nft_contract);
        IDRExToken erc20 = IDRExToken(drex_token_contract);
        erc20.mint(msg.sender, nft_contract, amt_generated);
        nfti.update_nft_balance(amt_generated);
        emit Token_Transfer(amt_generated);
    }
}
