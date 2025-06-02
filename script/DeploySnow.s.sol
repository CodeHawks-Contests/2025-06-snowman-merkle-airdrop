// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {Script, console2} from "forge-std/Script.sol";
import {Snow} from "../src/Snow.sol";
import {MockWETH} from "../src/mock/MockWETH.sol";

contract DeploySnow is Script {
    Snow snow;
    MockWETH public weth;

    address public collector = makeAddr("collector");
    uint256 public FEE = 5;

    function run() external returns (Snow) {
        vm.startBroadcast();

        weth = new MockWETH();
        snow = new Snow(address(weth), FEE, collector);
        FEE = snow.s_buyFee();
        collector = snow.getCollector();

        vm.stopBroadcast();

        // _log();

        return snow;
    }

    function _log() private view {
        console2.log("Snow Token deployed at: ", address(snow));
        console2.log("Fee collector: ", collector);
        console2.log("Buy fee: ", FEE);
    }
}
