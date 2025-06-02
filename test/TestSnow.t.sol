// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {Snow} from "../src/Snow.sol";
import {DeploySnow} from "../script/DeploySnow.s.sol";
import {MockWETH} from "../src/mock/MockWETH.sol";

contract TestSnow is Test {
    Snow snow;
    DeploySnow deployer;
    MockWETH weth;

    address collector;
    uint256 FEE;

    address jerry;
    address victory;
    address ashley;

    function setUp() public {
        deployer = new DeploySnow();
        snow = deployer.run();
        weth = deployer.weth();
        collector = deployer.collector();
        FEE = deployer.FEE();

        jerry = makeAddr("jerry");
        victory = makeAddr("victory");
        ashley = makeAddr("ashley");

        weth.mint(jerry, FEE);
        deal(victory, FEE);
    }

    function testCanEarnSnow() public {
        vm.prank(ashley);
        snow.earnSnow();

        assert(snow.balanceOf(ashley) == 1);

        vm.prank(ashley);
        vm.expectRevert(); // Should revert because 1 week has not passed
        snow.earnSnow();

        vm.warp(block.timestamp + 1 weeks);

        vm.prank(ashley);
        snow.earnSnow(); // Should not revert as 1 week has passed

        assert(snow.balanceOf(ashley) == 2);
    }

    function testCanBuySnow() public {
        vm.startPrank(jerry);
        weth.approve(address(snow), FEE);
        snow.buySnow(1);
        vm.stopPrank();

        assert(weth.balanceOf(address(snow)) == FEE);
        assert(snow.balanceOf(jerry) == 1);
    }

    function testCanBuySnowWithEth() public {
        vm.prank(victory);
        snow.buySnow{value: FEE}(1);

        assert(victory.balance == 0);
        assert(address(snow).balance == FEE);
        assert(snow.balanceOf(victory) == 1);
    }

    function testCollectFee() public {
        vm.startPrank(jerry);
        weth.approve(address(snow), FEE);
        snow.buySnow(1);
        vm.stopPrank();

        vm.prank(victory);
        snow.buySnow{value: FEE}(1);

        vm.prank(collector);
        snow.collectFee();

        assert(weth.balanceOf(collector) == FEE);
        assert(collector.balance == FEE);
        assert(address(snow).balance == 0);
        assert(weth.balanceOf(address(snow)) == 0);
    }

    function testChangeCollector() public {
        address jack = makeAddr("new collector");

        vm.prank(collector);
        snow.changeCollector(jack);
    }

    function testCanStillFarm() public {
        vm.warp(block.timestamp + 12 weeks);

        vm.prank(ashley);
        vm.expectRevert();
        snow.earnSnow();

        vm.prank(victory);
        vm.expectRevert();
        snow.buySnow{value: FEE}(1);
    }
}
