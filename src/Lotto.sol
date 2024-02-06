// contracts/GameLeaderboard.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

// https://github.com/pyth-network/pyth-crosschain/blob/main/target_chains/ethereum/examples/coin_flip/contract/src/CoinFlip.sol


contract Lotto is Ownable {

    address[] punters;

    address public constant ENTROPY = 0x98046Bd286715D3B0BC227Dd7a956b83D8978603;
    address public constant ENTROPY_DP = 0x6CC14824Ea2918f5De5C2f75A9Da968ad4BD6344;

    IEntropy public entropy =  IEntropy(ENTROPY);

    function getRandomness() external retursn(uint256) {
        bytes32 randomNumber = entropy.reveal(
            provider,
            sequenceNumber,
            randomNumber,
            providerRandomNumber
        );

        return uint256(randomNumber);
    }

}