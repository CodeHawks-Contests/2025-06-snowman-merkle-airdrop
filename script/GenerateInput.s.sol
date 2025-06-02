// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {Script, console2} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {Helper} from "./Helper.s.sol";

contract GenerateInput is Script {
    Helper helper;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address clara = makeAddr("clara");
    address dan = makeAddr("dan");
    address eli = makeAddr("eli");

    uint256 snowAmountAlice;
    uint256 snowAmountBob;
    uint256 snowAmountClara;
    uint256 snowAmountDan;
    uint256 snowAmountEli;

    string[] types = new string[](2);
    uint256 count;
    string[] whitelist = new string[](5);
    string private constant INPUT_PATH = "/script/flakes/input.json";

    function run() public {
        // Initialize types
        types[0] = "address";
        types[1] = "uint256";

        // Set whitelist addresses
        whitelist[0] = vm.toString(alice);
        whitelist[1] = vm.toString(bob);
        whitelist[2] = vm.toString(clara);
        whitelist[3] = vm.toString(dan);
        whitelist[4] = vm.toString(eli);

        count = whitelist.length;

        string memory input = _createJSON();
        vm.writeFile(string.concat(vm.projectRoot(), INPUT_PATH), input);

        console2.log("DONE: The output is found at %s", INPUT_PATH);
    }

    function _createJSON() internal returns (string memory) {
        helper = new Helper();
        helper.run();

        snowAmountAlice = helper.aliceSB();
        snowAmountBob = helper.bobSB();
        snowAmountClara = helper.claraSB();
        snowAmountDan = helper.danSB();
        snowAmountEli = helper.eliSB();

        string memory countString = vm.toString(count); // convert count to string
        string memory json = string.concat('{ "types": ["address", "uint256"], "count":', countString, ',"values": {');

        // Add Alice
        json = string.concat(json, '"0": { "0": "', whitelist[0], '", "1": "', vm.toString(snowAmountAlice), '" },');

        // Add Bob
        json = string.concat(json, '"1": { "0": "', whitelist[1], '", "1": "', vm.toString(snowAmountBob), '" },');

        // Add Clara
        json = string.concat(json, '"2": { "0": "', whitelist[2], '", "1": "', vm.toString(snowAmountClara), '" },');

        // Add Dan
        json = string.concat(json, '"3": { "0": "', whitelist[3], '", "1": "', vm.toString(snowAmountDan), '" },');

        // Add Eli
        json = string.concat(json, '"4": { "0": "', whitelist[4], '", "1": "', vm.toString(snowAmountEli), '" }');

        json = string.concat(json, "} }");

        return json;
    }
}
