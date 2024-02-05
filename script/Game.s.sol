// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/Game.sol";

contract GameScript is Script {
    function run() public {
        vm.startBroadcast();

        address _minimalForwarder = 0xB6A87320DE35F2bEFE2258162360daa3de11C788;

        Game game = new Game(3, "emojiMatch", 604800, 86400, _minimalForwarder);

        vm.stopBroadcast();
    }
}
