// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {Snow} from "../src/Snow.sol";
import {Snowman} from "../src/Snowman.sol";
import {SnowmanAirdrop} from "../src/SnowmanAirdrop.sol";
import {MockWETH} from "../src/mock/MockWETH.sol";
import {DeploySnowmanAirdrop} from "../script/DeploySnowmanAirdrop.s.sol";

contract Helper is Script {
    Snow snow;
    Snowman nft;
    SnowmanAirdrop airdrop;
    DeploySnowmanAirdrop deployer;
    MockWETH weth;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address clara = makeAddr("clara");
    address dan = makeAddr("dan");
    address eli = makeAddr("eli");

    uint256 public aliceSB;
    uint256 public bobSB;
    uint256 public claraSB;
    uint256 public danSB;
    uint256 public eliSB;

    function helper() public returns (SnowmanAirdrop, Snow, Snowman, MockWETH) {
        weth = new MockWETH();
        deployer = new DeploySnowmanAirdrop();
        (airdrop, snow, nft) = deployer.deploySnowmanAirdrop();

        vm.prank(alice);
        snow.earnSnow();
        aliceSB = snow.balanceOf(alice);

        vm.warp(block.timestamp + 1 weeks);

        vm.prank(bob);
        snow.earnSnow();
        bobSB = snow.balanceOf(bob);

        vm.warp(block.timestamp + 1 weeks);

        vm.prank(clara);
        snow.earnSnow();
        claraSB = snow.balanceOf(clara);

        vm.warp(block.timestamp + 1 weeks);

        vm.prank(dan);
        snow.earnSnow();
        danSB = snow.balanceOf(dan);

        vm.warp(block.timestamp + 1 weeks);

        vm.prank(eli);
        snow.earnSnow();
        eliSB = snow.balanceOf(eli);

        return (airdrop, snow, nft, weth);
    }

    function run() external returns (SnowmanAirdrop, Snow, Snowman, MockWETH) {
        return helper();
    }
}
