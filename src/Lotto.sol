// contracts/GameLeaderboard.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./entropy_sdk/IEntropy.sol";

// https://github.com/pyth-network/pyth-crosschain/blob/main/target_chains/ethereum/examples/coin_flip/contract/src/CoinFlip.sol

contract Lotto is Ownable {
    address[] punters;

    address public constant ENTROPY =
        0x98046Bd286715D3B0BC227Dd7a956b83D8978603;
    address public constant ENTROPY_DEFAULT_PROVIDER =
        0x6CC14824Ea2918f5De5C2f75A9Da968ad4BD6344;

    IEntropy public entropy = IEntropy(ENTROPY);

    mapping(uint64 => address) private requestedFlips;
    mapping(address => uint256) private userToSequenceNumber;
    mapping(address => uint256) private userToFinalRandomNumber;

    uint256 winningNumber = 50;
    uint256 numberRange = 100;

    event RandomnessRequested(uint64 sequenceNumber, address requester);
    event RandomnessRevealed(uint256 randomNumber, address revealer);
    event Winner(uint256 winningNumber, address winner);

    function revealResult(
        uint64 _sequenceNumber,
        bytes32 _randomNumber,
        bytes32 _providerRandomNumber
    ) external returns (uint256, uint256) {
        bytes32 randomNumber = entropy.reveal(
            ENTROPY_DEFAULT_PROVIDER,
            _sequenceNumber,
            _randomNumber,
            _providerRandomNumber
        );
        delete requestedFlips[_sequenceNumber];

        uint256 finalRandomNumber = uint256(randomNumber) % numberRange;

        userToFinalRandomNumber[msg.sender] = finalRandomNumber;

        if (finalRandomNumber == winningNumber) {
            emit Winner(finalRandomNumber, msg.sender);
        }

        emit RandomnessRevealed(finalRandomNumber, msg.sender);

        return (finalRandomNumber, winningNumber);
    }

    function requestRandomness(
        bytes32 commitment
    ) public payable returns (uint64 sequenceNumber) {
        uint fee = entropy.getFee(ENTROPY_DEFAULT_PROVIDER);
        require(msg.value >= fee, "Not enough ETH sent");

        sequenceNumber = entropy.request{value: fee}(
            ENTROPY_DEFAULT_PROVIDER,
            commitment,
            true
        );
        requestedFlips[sequenceNumber] = msg.sender;
        userToSequenceNumber[msg.sender] = sequenceNumber;

        emit RandomnessRequested(sequenceNumber, msg.sender);
    }

    function getSequenceNumbersByUser(
        address user
    ) public view returns (uint256) {
        return userToSequenceNumber[user];
    }

    function getFinalRandomNumberByUser(
        address user
    ) public view returns (uint256) {
        return userToFinalRandomNumber[user];
    }

    function getFee() public view returns (uint256 fee) {
        fee = entropy.getFee(ENTROPY_DEFAULT_PROVIDER);
    }

    function setNumberRange(uint256 _numberRange) external onlyOwner {
        numberRange = _numberRange;
    }

    function setWinningNumber(uint256 _winningNumber) external onlyOwner {
        winningNumber = _winningNumber;
    }
}
