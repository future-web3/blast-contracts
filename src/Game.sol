// contracts/GameLeaderboard.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./GameLeaderboard.sol";
import "./MinimalForwarder.sol";
import "./GameTicket.sol";

contract Game is Ownable {
    uint public gameId;
    string public gameName;
    GameTicket public gameTicket;
    Round public round;
    MinimalForwarder public minimalForwarder;
    address public gameDev;

    uint public constant PLATFORM_SHARE = 0; // We are not apple store. We give away 100% to the community to start with.
    uint public constant GAME_DEV_SHARE = 1; // This can be configured later.
    uint public constant FIRST = 3; // 30% prize goes to 1st ranked player
    uint public constant SECOND = 2; // 20% prize goes to 2nd ranked player
    uint public constant THIRD = 1; // 10% prize goes to 3rd ranked player
    uint public constant OTHERS = 3; // 30% prize goes to other ranked players

    uint gameDevPrize;
    uint firstPrize;
    uint secondPrize;
    uint thirdPrize;
    uint sharedPrize;

    struct Round {
        uint256 length; // in seconds
        uint256 gameRound; // current game round
        uint256 end; // timestamp
        uint claimPeriod; // the time period the players can claim reward
        GameLeaderboard gameLeaderBoard;
        bool hasClaimedBySomeone;
        uint rewardPool;
    }

    event ScoreUpdated(
        Round round,
        uint gameId,
        string gameName,
        GameLeaderboard.User[] gameLeaderboardInfo,
        address user,
        uint score
    );

    constructor(
        uint _gameId,
        string memory _gameName,
        uint _roundLength,
        uint _claimPeriod,
        address _minimalForwader,
        address _gameTicket,
        address _gameDev
    ) {
        gameId = _gameId;
        gameName = _gameName;
        minimalForwarder = MinimalForwarder(_minimalForwader);
        gameTicket = GameTicket(_gameTicket);
        gameDev = _gameDev;

        round = Round({
            length: _roundLength,
            gameRound: 1,
            end: block.timestamp + _roundLength,
            claimPeriod: _claimPeriod,
            gameLeaderBoard: new GameLeaderboard(_gameId, _gameName),
            hasClaimedBySomeone: false,
            rewardPool: address(this).balance
        });
    }

    modifier onlyTrustedForwarder() {
        require(
            msg.sender == address(minimalForwarder),
            "only trusted sender can add score"
        );
        _;
    }

    function updateGamePeriodAndEndTime(uint length) external onlyOwner {
        round = Round({
            length: length,
            gameRound: round.gameRound,
            end: block.timestamp + length,
            claimPeriod: round.claimPeriod,
            gameLeaderBoard: getCurrentGameBoard(),
            hasClaimedBySomeone: false,
            rewardPool: address(this).balance
        });
    }

    function updateClaimPeriod(uint newClaimPeriod) external onlyOwner {
        round = Round({
            length: round.length,
            gameRound: round.gameRound,
            end: round.end,
            claimPeriod: newClaimPeriod,
            gameLeaderBoard: getCurrentGameBoard(),
            hasClaimedBySomeone: false,
            rewardPool: address(this).balance
        });
    }

    function addScore(address user, uint score) external onlyTrustedForwarder {
        require(isGameRunning(), "Game is not running");

        GameLeaderboard _gameLeaderBoard = getCurrentGameBoard();
        _gameLeaderBoard.addScore(user, score);

        GameLeaderboard.User[] memory _gameLeaderboardInfo = _gameLeaderBoard
            .getLeaderBoardInfo();

        emit ScoreUpdated(
            round,
            gameId,
            gameName,
            _gameLeaderboardInfo,
            user,
            score
        );
    }

    function claimReward() external {
        require(isClaiming(), "It is not in the claim prize period");

        GameLeaderboard _gameLeaderBoard = getCurrentGameBoard();

        uint leaderBoardLength = _gameLeaderBoard.leaderboardLength();

        uint256 totalBalance;

        if (!round.hasClaimedBySomeone) {
            totalBalance = address(this).balance;
            gameDevPrize = (totalBalance * GAME_DEV_SHARE) / 10;
            firstPrize = (totalBalance * FIRST) / 10;
            secondPrize = (totalBalance * SECOND) / 10;
            thirdPrize = (totalBalance * THIRD) / 10;
            sharedPrize = (totalBalance * OTHERS) / (10 * 7);
            (bool sent, ) = gameDev.call{value: gameDevPrize}(""); // send to gamedev money
            require(sent, "Failed to send Ether");
            round.hasClaimedBySomeone = true;
        }

        for (uint i = 0; i < leaderBoardLength; i++) {
            GameLeaderboard.User memory currentUser = _gameLeaderBoard.getUser(
                i
            );

            if (currentUser.user == msg.sender) {
                require(
                    currentUser.prizeClaimed == false,
                    "You already claimed Prize"
                );

                if (i == 0) {
                    // 1st player
                    (bool sent, ) = msg.sender.call{value: firstPrize}("");
                    require(sent, "Failed to send Ether");
                } else if (i == 1) {
                    // 2nd player
                    (bool sent, ) = msg.sender.call{value: secondPrize}("");
                    require(sent, "Failed to send Ether");
                } else if (i == 2) {
                    // third player
                    (bool sent, ) = msg.sender.call{value: thirdPrize}("");
                    require(sent, "Failed to send Ether");
                } else {
                    // others
                    (bool sent, ) = msg.sender.call{value: sharedPrize}("");
                    require(sent, "Failed to send Ether");
                }

                currentUser.prizeClaimed = true;
            }
        }
    }

    function isGameRunning() public view returns (bool) {
        return block.timestamp < round.end;
    }

    function isClaiming() public view returns (bool) {
        return
            block.timestamp > round.end &&
            block.timestamp < round.end + round.claimPeriod;
    }

    function secondsToNextRound() public view returns (uint256 seconds_) {
        if (round.end <= block.timestamp) {
            return 0;
        } else {
            return round.end - block.timestamp;
        }
    }

    function getCurrentGameBoard()
        public
        view
        returns (GameLeaderboard gameLeaderboard)
    {
        return round.gameLeaderBoard;
    }

    function getCurrentGameRound() public view returns (Round memory) {
        return round;
    }

    function getLeaderBoardInfo()
        public
        view
        returns (GameLeaderboard.User[] memory)
    {
        GameLeaderboard _gameLeaderBoard = getCurrentGameBoard();
        return _gameLeaderBoard.getLeaderBoardInfo();
    }

    function startNewGameRound() external onlyOwner {
        require(
            block.timestamp > round.end + round.claimPeriod,
            "Pending on claim prize"
        );

        round = Round({
            length: round.length,
            gameRound: round.gameRound + 1,
            end: block.timestamp + round.length,
            claimPeriod: round.claimPeriod,
            gameLeaderBoard: new GameLeaderboard(gameId, gameName),
            hasClaimedBySomeone: false,
            rewardPool: address(this).balance
        });
    }

    function redeemTicket(uint8 _ticketType) external returns (uint8) {
        require(
            _ticketType == gameTicket.BRONZE() ||
                _ticketType == gameTicket.SILVER() ||
                _ticketType == gameTicket.GOLD(),
            "The ticket type is wrong!"
        );
        require(
            gameTicket.balanceOf(msg.sender, _ticketType) >= 1,
            "You dont own the ticket"
        );

        gameTicket.burn(msg.sender, _ticketType, 1);
        uint ticketPrice = gameTicket.getTicketPrice(_ticketType);
        round.rewardPool += ticketPrice;

        (bool success, ) = address(gameTicket).call{value: 0, gas: 5000}(
            abi.encodeWithSignature("sendPrize(uint256)", _ticketType)
        );
        require(success, "Failed to send Ether");

        return _ticketType;
    }

    receive() external payable {}
}
