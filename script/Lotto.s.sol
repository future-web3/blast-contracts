pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/Lotto.sol";

contract LottoScript is Script {
    function run() public {
        vm.startBroadcast();

        Lotto lotto = new Lotto();

        vm.stopBroadcast();
    }
}
