// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {DeploySnowman} from "../script/DeploySnowman.s.sol";

contract TestDeploySnowman is Test {
    DeploySnowman deployer;

    function setUp() public {
        deployer = new DeploySnowman();
    }

    function testConvertSvgToUri() public view {
        string memory expectedUri = vm.readFile("./img/snowman.txt");
        string memory svg = vm.readFile("./img/snowman.svg");
        string memory actualUri = deployer.svgToImageURI(svg);

        assert(keccak256(abi.encode(actualUri)) == keccak256(abi.encode(expectedUri)));
    }
}
