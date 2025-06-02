// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockWETH is ERC20 {
    // >>> CONSTRUCTOR
    constructor() ERC20("MockWETH", "mWETH") {}

    // >>> FUNCTION
    function mint(address receiver, uint256 amount) external {
        _mint(receiver, amount);
    }
}
