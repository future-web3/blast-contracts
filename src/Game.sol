// contracts/GameLeaderboard.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import './GameLeaderboard.sol';

contract Game is Ownable {
    uint public gameId;
    string public gameName;
    Round public round;

    uint public constant FIRST = 4; // 40% prize goes to 1st ranked player
    uint public constant SECOND = 2; // 20% prize goes to 2nd ranked player
    uint public constant THIRD = 1; // 10% prize goes to 3rd ranked player
    uint public constant OTHERS = 3; // 30% prize goes to other ranked players

    struct Round {
        uint256 length; // in seconds
        uint256 gameRound; // current game round
        uint256 end; // timestamp
        uint claimPeriod; // the time period the players can claim reward
        GameLeaderboard gameLeaderBoard;
    }

    constructor(uint _gameId, string memory _gameName, uint _roundLength, uint _claimPeriod) {
        gameId = _gameId;
        gameName = _gameName;

        round = Round({
            length: _roundLength,
            gameRound: 1,
            end: block.timestamp + _roundLength,
            claimPeriod: _claimPeriod,
            gameLeaderBoard: new GameLeaderboard(_gameId, _gameName)
        });
    }

    function addScore(address user, uint score) external onlyOwner {
        require(isGameRunning() , "Game is not running");

        GameLeaderboard _gameLeaderBoard = getCurrentGameBoard();
        _gameLeaderBoard.addScore(user, score);
    }

    function claimReward() external {
        require(round.end < block.timestamp && block.timestamp < round.end + round.claimPeriod, "It is not in the claim prize period");

        GameLeaderboard _gameLeaderBoard = getCurrentGameBoard();

        uint leaderBoardLength = _gameLeaderBoard.leaderboardLength();
        uint256 totalBalance = address(this).balance;

        for (uint i = 0; i < leaderBoardLength; i++) {            
            GameLeaderboard.User memory currentUser = _gameLeaderBoard.getUser(i);

            if (currentUser.user == msg.sender) {
                require(currentUser.prizeClaimed == false, "You already claimed Prize");

                if (i == 0) { // 1st player
                    uint prize = totalBalance * FIRST / 10;
                    (bool sent,) = msg.sender.call{value: prize}("");
                    require(sent, "Failed to send Ether");
                } else if (i == 1) { // 2nd player
                    uint prize = totalBalance * SECOND / 10;
                    (bool sent,) = msg.sender.call{value: prize}("");
                    require(sent, "Failed to send Ether");
                } else if (i == 2) { // third player
                    uint prize = totalBalance * THIRD / 10;
                    (bool sent,) = msg.sender.call{value: prize}("");
                    require(sent, "Failed to send Ether");
                } else { // others
                    uint prize = totalBalance * OTHERS / (10 * 7);
                    (bool sent,) = msg.sender.call{value: prize}("");
                    require(sent, "Failed to send Ether");
                }

                currentUser.prizeClaimed = true;                
            }
        }
    }

    function isGameRunning() public view returns (bool) {
        return block.timestamp < round.end;
    }

    function secondsToNextRound() public view returns (uint256 seconds_) {
        if (round.end <= block.timestamp) {
            return 0;
        } else {
            return round.end - block.timestamp;
        }
    }

    function getCurrentGameBoard() public view returns(GameLeaderboard gameLeaderboard) {
        return round.gameLeaderBoard;
    }

    function getLeaderBoardInfo() public view returns (GameLeaderboard.User[] memory) {
        GameLeaderboard _gameLeaderBoard = getCurrentGameBoard();
        return _gameLeaderBoard.getLeaderBoardInfo();
    }

    function startNewGameRound() external onlyOwner {
        require(block.timestamp > round.end + round.claimPeriod, "Pending on claim prize");

        round = Round({
            length: round.length,
            gameRound: round.gameRound ++,
            end: block.timestamp + round.length,
            claimPeriod: round.claimPeriod,
            gameLeaderBoard: new GameLeaderboard(gameId, gameName)
        });
    }
}