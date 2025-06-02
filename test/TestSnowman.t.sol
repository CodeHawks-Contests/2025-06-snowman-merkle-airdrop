// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {Snowman} from "../src/Snowman.sol";
import {DeploySnowman} from "../script/DeploySnowman.s.sol";

contract TestSnowman is Test {
    Snowman nft;
    DeploySnowman deployer;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    string constant NAME = "Snowman Airdrop";
    string constant SYMBOL = "SNOWMAN";

    function setUp() public {
        deployer = new DeploySnowman();
        nft = deployer.run();
    }

    function testInitializedCorrectly() public view {
        assert(keccak256(abi.encodePacked(nft.name())) == keccak256(abi.encodePacked(NAME)));
        assert(keccak256(abi.encodePacked(nft.symbol())) == keccak256(abi.encodePacked(SYMBOL)));
    }

    function testMintSnowman() public {
        nft.mintSnowman(alice, 1);
        nft.mintSnowman(bob, 2);

        assert(nft.ownerOf(0) == alice);
        assert(nft.ownerOf(1) == bob);
        assert(nft.ownerOf(2) == bob);

        assert(nft.balanceOf(alice) == 1);
        assert(nft.balanceOf(bob) == 2);

        assert(nft.getTokenCounter() == 3);
    }
}
