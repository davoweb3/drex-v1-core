// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Our_ERC20.sol";
import "./Drex_stableCoin.sol";

contract DrexTreasury {
    //varibales required in smart contract
    // IERC20 private drex_stable;
    // IERC20 private drex_tokens;
    DRExToken public drex_token;
    DRExStable public drex_stable;
    address private owner;
    mapping(bytes32 => address) public reqTosender;
    uint256 random_amount;

    // events
    event TransferSent(address _destAddr, uint256 _amount);

    constructor(address stable_coin_address, address drex_token_address)
        public
    {
        drex_stable = DRExStable(stable_coin_address);
        drex_token = DRExToken(drex_token_address);
        owner = msg.sender;
    }

    modifier isOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    /// @notice  This function is used to by the smes to send payments for the gas they have used
    /// @param amount --> the amount smes will be paying
    function pay_fees(uint256 amount) public payable {
        require(
            drex_stable.balanceOf(msg.sender) > amount,
            "Balance not enough,please recharge"
        );

        drex_stable.transferFrom(msg.sender, address(this), amount);
        emit TransferSent(address(this), random_amount);
    }

    //wallet of owener --> 100 drexCoins ---> 100drexCoins and in return they will  get 100drexStablecoins

    /// @notice This function is used by nft owner to convert their drexTokens to drexStable coins

    function redeem() public {
        require(
            drex_token.balanceOf(msg.sender) > 0,
            "Owner should have some drex tokens to convert them into stable coins"
        );
        require(
            drex_stable.balanceOf(address(this)) >
                drex_token.balanceOf(msg.sender),
            "not enough stable coins"
        );
        uint256 total_transfer = drex_token.balanceOf(msg.sender);
        drex_token.transferFrom(msg.sender, address(this), total_transfer);

        //approving the user to take the drex_token
        drex_stable.approve(address(this), total_transfer);
        drex_stable.transferFrom(address(this), address(msg.sender), 10);
    }

    function transfer_to_owner() public isOwner {
        drex_token.approve(owner, drex_token.balanceOf(address(this)));
    }
}
