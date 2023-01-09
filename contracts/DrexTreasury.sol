// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./DRExToken.sol";
import "./DRExStable.sol";

contract DrexTreasury {
    DRExToken public drexToken;
    DRExStable public drexStable;
    address private owner;

    // events
    event Transfer_Sent(address _destAddr, uint256 _amount);

    constructor(address drex_stable_address, address drex_token_address)
        public
    {
        drexStable = DRExStable(drex_stable_address);
        drexToken = DRExToken(drex_token_address);
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
            drexStable.balanceOf(msg.sender) > amount,
            "Balance not enough,please recharge"
        );

        drexStable.transferFrom(msg.sender, address(this), amount);
        emit Transfer_Sent(address(this), amount);
    }

    /// @notice This function is used by nft owner to convert their drexTokens to drexStable coins

    function redeem() public {
        require(
            drexToken.balanceOf(msg.sender) > 0,
            "Owner should have some drex tokens to convert them into stable coins"
        );
        require(
            drexStable.balanceOf(address(this)) >
                drexToken.balanceOf(msg.sender),
            "not enough stable coins"
        );
        uint256 total_transfer = drexToken.balanceOf(msg.sender);
        drexToken.transferFrom(msg.sender, address(this), total_transfer);

        //approving the user to take the drex_token
        drexStable.approve(address(this), total_transfer);
        drexStable.transferFrom(
            address(this),
            address(msg.sender),
            total_transfer
        );
    }

    function transfer_to_owner() public isOwner {
        drexToken.approve(owner, drexToken.balanceOf(address(this)));
    }
}
