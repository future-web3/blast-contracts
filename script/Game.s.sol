// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/Game.sol";

contract GameScript is Script {
    function run() public {
        vm.startBroadcast();

        address _minimalForwarder = 0xB6A87320DE35F2bEFE2258162360daa3de11C788;
        address gameTicket = 0xC88c10CC9A18c713e19BA5807E2659FBb98A893A;
        address gameDeveloper = 0x777BEeF85E717Ab18e44cd054B1a1E33a4A93b83;
        address lotto = 0xd46807E42528AAe601131235Cea22Cf4fe205A78;

        Game game = new Game(
            2,
            "snowmanDefender",
            604800,
            86400,
            _minimalForwarder,
            gameTicket,
            gameDeveloper,
            lotto
        );

        vm.stopBroadcast();
    }
}
