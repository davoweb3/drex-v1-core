// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IDRExToken {
    function mint(
        address sender,
        address to,
        uint256 amt
    ) external;
}

contract DRExToken is ERC20 {
    IERC20 private _drexToken;
    uint256 public tokensSupplied;
    address public owner;

    constructor() ERC20("DREx", "DRX") {
        tokensSupplied = 0;
        owner = msg.sender;
    }

    /// @notice Set the address of erc20 token
    /// @param token -->  address of the erc20 token
    function set_address(IERC20 token) public {
        require(msg.sender == owner, "you are not the owner");
        _drexToken = token;
    }

    // / @notice this function is used to transfer funds to the given address and a given amount
    // / @param to --> address of the reciever
    // / @param amt --> ammount to be transfered
    // function tranferingfunds(address payable to, uint256 amt) external {
    //     totalTokenSupplied += amt;
    //     _token.transfer(to, amt);
    // }

    ///@notice This function is used to mint new drex tokens
    ///@param sender --> address of the sender for the require function
    ///@param holder --> the address of the contract where tokens should be minted
    ///@param ammount --> the ammount of drex tokens to mint
    function mint(
        address sender,
        address holder,
        uint256 ammount
    ) external {
        require(sender == owner, "you are not the owner");
        _mint(holder, ammount);
        tokensSupplied += ammount;
    }
}
