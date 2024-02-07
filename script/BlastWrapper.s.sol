// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/BlastWrapper.sol";

contract BlastWrapperScript is Script {
    function run() public {
        vm.startBroadcast();

        BlastWrapper blastWrapper = new BlastWrapper();

        vm.stopBroadcast();
    }
}
