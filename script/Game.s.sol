// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/Game.sol";

contract GameScript is Script {
    function run() public {
        vm.startBroadcast();

        Game game = new Game(
            0,
            "escapeFromGerms",
            604800,
            86400,
            0x777BEeF85E717Ab18e44cd054B1a1E33a4A93b83
        );

        vm.stopBroadcast();
    }
}
