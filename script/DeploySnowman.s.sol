// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {Snowman} from "../src/Snowman.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeploySnowman is Script {
    function run() external returns (Snowman) {
        string memory snowmanSvg = vm.readFile("./img/snowman.svg");

        vm.startBroadcast();
        Snowman snowman = new Snowman(svgToImageURI(snowmanSvg));
        vm.stopBroadcast();

        return snowman;
    }

    function svgToImageURI(string memory svg) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }
}
