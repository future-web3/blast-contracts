// contracts/GameLeaderboard.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./entropy_sdk/IEntropy.sol";

// https://github.com/pyth-network/pyth-crosschain/blob/main/target_chains/ethereum/examples/coin_flip/contract/src/CoinFlip.sol

contract Lotto is Ownable {
    address public constant ENTROPY =
        0x98046Bd286715D3B0BC227Dd7a956b83D8978603;
    address public constant ENTROPY_DEFAULT_PROVIDER =
        0x6CC14824Ea2918f5De5C2f75A9Da968ad4BD6344;

    address[] participants;
    GameTicket public gameTicket;
    address public lastWinner;

    IEntropy public entropy = IEntropy(ENTROPY);

    mapping(uint64 => address) private requestedFlips;
    mapping(address => uint256) private userToSequenceNumber;
    mapping(address => uint256) private userToFinalRandomNumber;

    event RandomnessRequested(uint64 sequenceNumber, address requester);
    event RandomnessRevealed(uint256 randomNumber, address revealer);
    event Winner(address indexed winner, uint amount);


    constructor(address _gameTicket) {
        gameTicket = GameTicket(_gameTicket);
    }

    function participate(uint noOfTickets) external {
        require(
            gameTicket.balanceOf(msg.sender, gameTicket.LOTTO_TICKET()) >= noOfTickets,
            "You don't own the ticket"
        );

        gameTicket.burn(msg.sender, gameTicket.LOTTO_TICKET(), noOfTickets);

        for (uint i = 0; i < noOfTickets; i++) {
            participants.push(msg.sender);
        }

    }

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

        uint length = participants.length;

        uint winningAmount = address(this).balance;
        require(winningAmount > 0.1 ether, "There is not enough prize.");
        require(length > 100, "There is not enough participants yet");

        uint256 participantIdx = uint256(randomNumber) % length;

        lastWinner = participants[participantIdx];
        require(lastWinner != address(0), "No winner found");

        if (participantIdx != length-1) {
            participants[participantIdx] = participants[length - 1];            
        }
        
        participants.pop();

        (bool success, ) = lastWinner.call{value: winningAmount}("");
        require(success, "Failed to send Ether");
        emit Winner(lastWinner, winningAmount);
        emit RandomnessRevealed(participantIdx, msg.sender);
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

    function getFinalResultsByUser(
        address user
    ) public view returns (uint256, bool) {
        return (
            userToFinalRandomNumber[user],
            userToFinalRandomNumber[user] == winningNumber
        );
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
