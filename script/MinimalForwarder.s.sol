// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/MinimalForwarder.sol";

contract MinimalForwarderScript is Script {
    function run() public {
        vm.startBroadcast();

        MinimalForwarder minimalForwarder = new MinimalForwarder();

        vm.stopBroadcast();
    }
}
