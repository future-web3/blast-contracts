// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/Game.sol";

contract GameScript is Script {
    function run() public {
        vm.startBroadcast();

        Game game = new Game(0, "escapeFromGerms", 604800, 86400);

        vm.stopBroadcast();
    }
}
