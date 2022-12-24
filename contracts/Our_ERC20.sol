// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface drex_token_interface {
    function tranferingfunds(address payable to, uint256 amt) external;
}

contract DRExToken is ERC20 {
    IERC20 private _token;
    uint256 public totalTokenSupplied;

    constructor(uint256 initialSupply) ERC20("DREx", "DRX") {
        _mint(msg.sender, initialSupply);
        totalTokenSupplied = 0;
    }

    /// @notice Set the address of erc20 token
    /// @param token -->  address of the erc20 token
    function setAddress(IERC20 token) external {
        _token = token;
    }

    /// @notice this function is used to transfer funds to the given address and a given amount
    /// @param to --> address of the reciever
    /// @param amt --> ammount to be transfered
    function tranferingfunds(address payable to, uint256 amt) external {
        totalTokenSupplied += amt;
        _token.transfer(to, amt);
    }
}
