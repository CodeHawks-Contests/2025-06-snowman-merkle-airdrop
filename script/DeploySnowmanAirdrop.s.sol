// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {Script, console2} from "forge-std/Script.sol";
import {SnowmanAirdrop} from "../src/SnowmanAirdrop.sol";
import {Snow} from "../src/Snow.sol";
import {Snowman} from "../src/Snowman.sol";
import {DeploySnowman} from "./DeploySnowman.s.sol";
import {DeploySnow} from "./DeploySnow.s.sol";

contract DeploySnowmanAirdrop is Script {
    bytes32 private constant s_MERKLE_ROOT = 0xc0b6787abae0a5066bc2d09eaec944c58119dc18be796e93de5b2bf9f80ea79a; // Gotten from output.json

    SnowmanAirdrop airdrop;
    Snow snow;
    Snowman nft;
    DeploySnowman nftDeployer;
    DeploySnow snowDeployer;

    function deploySnowmanAirdrop() public returns (SnowmanAirdrop, Snow, Snowman) {
        snowDeployer = new DeploySnow();
        snow = snowDeployer.run();

        nftDeployer = new DeploySnowman();
        nft = nftDeployer.run();

        airdrop = new SnowmanAirdrop(s_MERKLE_ROOT, address(snow), address(nft));

        return (airdrop, snow, nft);
    }

    function run() external returns (SnowmanAirdrop, Snow, Snowman) {
        vm.startBroadcast();
        (airdrop, snow, nft) = deploySnowmanAirdrop();
        vm.stopBroadcast();

        return (airdrop, snow, nft);
    }
}
