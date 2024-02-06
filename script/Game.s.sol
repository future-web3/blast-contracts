// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/Game.sol";

contract GameScript is Script {
    function run() public {
        vm.startBroadcast();

        address _minimalForwarder = 0xB6A87320DE35F2bEFE2258162360daa3de11C788;
        address gameTicket = 0x5Ff7758B2d501f74018C0dbbF5Be47d6E1ADe18B;
        address gameDeveloper = 0xAC259056C1A7C974AAb17908BC1d9914DF401249;

        Game game = new Game(
            3,
            "emojiMatch",
            604800,
            86400,
            _minimalForwarder,
            gameTicket,
            gameDeveloper
        );

        vm.stopBroadcast();
    }
}
