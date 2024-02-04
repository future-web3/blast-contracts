// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/GameTicket.sol";

contract GameTicketScript is Script {
    function run() public {
        vm.startBroadcast();

        GameTicket gameTicket = new GameTicket();

        vm.stopBroadcast();
    }
}
