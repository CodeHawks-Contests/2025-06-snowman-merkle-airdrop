// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {Snow} from "../src/Snow.sol";
import {Snowman} from "../src/Snowman.sol";
import {SnowmanAirdrop} from "../src/SnowmanAirdrop.sol";
import {MockWETH} from "../src/mock/MockWETH.sol";
import {Helper} from "../script/Helper.s.sol";

contract TestSnowmanAirdrop is Test {
    Snow snow;
    Snowman nft;
    SnowmanAirdrop airdrop;
    MockWETH weth;

    Helper deployer;

    bytes32 public ROOT = 0xc0b6787abae0a5066bc2d09eaec944c58119dc18be796e93de5b2bf9f80ea79a;

    // Proofs
    bytes32 alProofA = 0xf99782cec890699d4947528f9884acaca174602bb028a66d0870534acf241c52;
    bytes32 alProofB = 0xbc5a8a0aad4a65155abf53bb707aa6d66b11b220ecb672f7832c05613dba82af;
    bytes32 alProofC = 0x971653456742d62534a5d7594745c292dda6a75c69c43a6a6249523f26e0cac1;
    bytes32[] AL_PROOF = [alProofA, alProofB, alProofC];

    bytes32 bobProofA = 0x51c4b9a3cc313d7d7325f2d5d9e782a5a484e56a38947ab7eea7297ec86ff138;
    bytes32 bobProofB = 0xbc5a8a0aad4a65155abf53bb707aa6d66b11b220ecb672f7832c05613dba82af;
    bytes32 bobProofC = 0x971653456742d62534a5d7594745c292dda6a75c69c43a6a6249523f26e0cac1;
    bytes32[] BOB_PROOF = [bobProofA, bobProofB, bobProofC];

    bytes32 clProofA = 0x0065f7c9c934093ee1c4d51b77e77ad69d1c21351298d21cc720df18a39412f5;
    bytes32 clProofB = 0xe4f70a2d0da3e6c29810b3eb84deeae82d06479d602b0e64225458c968f98cc1;
    bytes32 clProofC = 0x971653456742d62534a5d7594745c292dda6a75c69c43a6a6249523f26e0cac1;
    bytes32[] CL_PROOF = [clProofA, clProofB, clProofC];

    bytes32 danProofA = 0xc7c84a70b50ff4103e9a8b3a716b446a138a507fc1b65ebdfae38439e52b2612;
    bytes32 danProofB = 0xe4f70a2d0da3e6c29810b3eb84deeae82d06479d602b0e64225458c968f98cc1;
    bytes32 danProofC = 0x971653456742d62534a5d7594745c292dda6a75c69c43a6a6249523f26e0cac1;
    bytes32[] DAN_PROOF = [danProofA, danProofB, danProofC];

    bytes32 eliProofA = 0x0000000000000000000000000000000000000000000000000000000000000000;
    bytes32 eliProofB = 0x0000000000000000000000000000000000000000000000000000000000000000;
    bytes32 eliProofC = 0xd7ed3892547c15a926b49d400e13fefe2c9f08de658f08b09925d5790383e978;
    bytes32[] ELI_PROOF = [eliProofA, eliProofB, eliProofC];

    // Multi claimers and key
    address alice;
    uint256 alKey;
    address bob;
    uint256 bobKey;
    address clara;
    uint256 clKey;
    address dan;
    uint256 danKey;
    address eli;
    uint256 eliKey;

    address satoshi;

    function setUp() public {
        deployer = new Helper();

        (airdrop, snow, nft, weth) = deployer.run();

        (alice, alKey) = makeAddrAndKey("alice");
        (bob, bobKey) = makeAddrAndKey("bob");
        (clara, clKey) = makeAddrAndKey("clara");
        (dan, danKey) = makeAddrAndKey("dan");
        (eli, eliKey) = makeAddrAndKey("eli");

        satoshi = makeAddr("gas_payer");
    }

    function testClaimSnowman() public {
        // Alice claim test
        assert(nft.balanceOf(alice) == 0);
        vm.prank(alice);
        snow.approve(address(airdrop), 1);

        // Get alice's digest
        bytes32 alDigest = airdrop.getMessageHash(alice);

        // alice signs a message
        (uint8 alV, bytes32 alR, bytes32 alS) = vm.sign(alKey, alDigest);

        // satoshi calls claims on behalf of alice using her signed message
        vm.prank(satoshi);
        airdrop.claimSnowman(alice, AL_PROOF, alV, alR, alS);

        assert(nft.balanceOf(alice) == 1);
        assert(nft.ownerOf(0) == alice);

        // -----------------

        // Bob claim test
        assert(nft.balanceOf(bob) == 0);
        vm.prank(bob);
        snow.approve(address(airdrop), 1);

        // Get bob's digest
        bytes32 bobDigest = airdrop.getMessageHash(bob);

        // bob signs a message
        (uint8 bobV, bytes32 bobR, bytes32 bobS) = vm.sign(bobKey, bobDigest);

        // satoshi calls claim on behalf of bob using his signed message
        vm.prank(satoshi);
        airdrop.claimSnowman(bob, BOB_PROOF, bobV, bobR, bobS);

        assert(nft.balanceOf(bob) == 1);
        assert(nft.ownerOf(1) == bob);

        // -----------------

        // Clara claim test
        assert(nft.balanceOf(clara) == 0);
        vm.prank(clara);
        snow.approve(address(airdrop), 1);

        // Get clara's digest
        bytes32 clDigest = airdrop.getMessageHash(clara);

        // clara signs a message
        (uint8 clV, bytes32 clR, bytes32 clS) = vm.sign(clKey, clDigest);

        // satoshi calls claim on behalf of clara using her signed message
        vm.prank(satoshi);
        airdrop.claimSnowman(clara, CL_PROOF, clV, clR, clS);

        assert(nft.balanceOf(clara) == 1);
        assert((nft.ownerOf(2) == clara));

        // -----------------

        // Dan claim test
        assert(nft.balanceOf(dan) == 0);
        vm.prank(dan);
        snow.approve(address(airdrop), 1);

        // Get dan's digest
        bytes32 danDigest = airdrop.getMessageHash(dan);

        // dan signs a message
        (uint8 danV, bytes32 danR, bytes32 danS) = vm.sign(danKey, danDigest);

        // satoshi calls claim on behalf of clara using her signed message
        vm.prank(satoshi);
        airdrop.claimSnowman(dan, DAN_PROOF, danV, danR, danS);

        assert(nft.balanceOf(dan) == 1);
        assert(nft.ownerOf(3) == dan);

        // -----------------

        // Eli claim test
        assert(nft.balanceOf(eli) == 0);
        vm.prank(eli);
        snow.approve(address(airdrop), 1);

        // Get eli's digest
        bytes32 eliDigest = airdrop.getMessageHash(eli);

        // eli signs message
        (uint8 eliV, bytes32 eliR, bytes32 eliS) = vm.sign(eliKey, eliDigest);

        // satoshi calls claim on behalf of eli using his signed message
        vm.prank(satoshi);
        airdrop.claimSnowman(eli, ELI_PROOF, eliV, eliR, eliS);

        assert(nft.balanceOf(eli) == 1);
        assert(nft.ownerOf(4) == eli);

        assert(nft.getTokenCounter() == 5);
    }
}
