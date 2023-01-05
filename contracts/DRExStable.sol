// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DRExStable is ERC20 {
    IERC20 private _stableToken;
    uint256 public tokensSupplied;

    constructor(uint256 initialSupply) ERC20("DRExStable", "DRXS") {
        _mint(msg.sender, initialSupply);
    }

    /// @notice Set the address of erc20 token
    /// @param token -->  address of the erc20 token
    function set_address(IERC20 token) external {
        _stableToken = token;
    }

    /// @notice this function is used to transfer funds to the given address and a given amount
    /// @param to --> address of the reciever
    /// @param amt --> ammount to be transfered
    function tranferring_funds(address payable to, uint256 amt) external {
        tokensSupplied += amt;
        _stableToken.transfer(to, amt);
    }
}
