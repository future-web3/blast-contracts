// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {GameLeaderboard} from "../src/GameLeaderboard.sol";
import {GameTicket} from "../src/GameTicket.sol";
import {Game} from "../src/Game.sol";
import {Lotto} from "../src/Lotto.sol";
import {MinimalForwarder} from "../src/MinimalForwarder.sol";

contract GameTest is Test {
    uint gameId = 1;
    string gameName = "germs";
    uint roundLength = 60;
    uint claimPeriod = 120;

    uint public constant FIRST = 3; // 30% prize goes to 1st ranked player
    uint public constant SECOND = 2; // 20% prize goes to 2nd ranked player
    uint public constant THIRD = 1; // 10% prize goes to 3rd ranked player
    uint public constant OTHERS = 3; // 30% prize goes to other ranked players

    MinimalForwarder minimalForwarder = new MinimalForwarder();

    address public owner = vm.envAddress("DEPLOYER");
    address public alice = vm.envAddress("ALICE");
    address public bob = vm.envAddress("BOB");
    address public carol = vm.envAddress("CAROL");
    address public doge = vm.envAddress("DOGE");
    address public gameDev = vm.envAddress("GAME_DEV");
    address public _minimalForwarder = address(minimalForwarder);

    // function test_SetupConstructorCorrectly() public {
    //     vm.startPrank(owner);
    //     GameTicket gameTicket = new GameTicket();
    //     Lotto lotto = new Lotto(address(gameTicket));
    //     Game game = new Game(
    //         gameId,
    //         gameName,
    //         roundLength,
    //         claimPeriod,
    //         _minimalForwarder,
    //         address(gameTicket),
    //         gameDev,
    //         address(lotto)
    //     );
    //     vm.stopPrank();
    //     Game.Round memory round = game.getCurrentGameRound();
    //     assertEq(round.length, roundLength);
    //     assertEq(round.claimPeriod, claimPeriod);
    // }

    // function test_AddScore() public {
    //     vm.startPrank(_minimalForwarder);
    //     GameTicket gameTicket = new GameTicket();
    //     Lotto lotto = new Lotto(address(gameTicket));
    //     Game game = new Game(
    //         gameId,
    //         gameName,
    //         roundLength,
    //         claimPeriod,
    //         _minimalForwarder,
    //         address(gameTicket),
    //         gameDev,
    //         address(lotto)
    //     );
    //     game.addScore(owner, 10);
    //     game.addScore(alice, 20);
    //     game.addScore(alice, 30);
    //     game.addScore(alice, 40);
    //     game.addScore(bob, 50);
    //     game.addScore(alice, 60);
    //     game.addScore(alice, 70);
    //     game.addScore(carol, 80);
    //     vm.stopPrank();

    //     GameLeaderboard _gameLeaderboard = game.getCurrentGameBoard();
    //     GameLeaderboard.User memory firstUser = _gameLeaderboard.getUser(0);
    //     address firstRanked = firstUser.user;
    //     uint firstScore = firstUser.score;
    //     assertEq(carol, firstRanked);
    //     assertEq(firstScore, 80);

    //     vm.startPrank(_minimalForwarder);
    //     game.addScore(doge, 90);
    //     vm.stopPrank();

    //     GameLeaderboard.User memory newFirstUser = _gameLeaderboard.getUser(0);
    //     uint newFirstScore = newFirstUser.score;
    //     assertEq(carol, firstRanked);
    //     assertEq(newFirstScore, 90);

    //     vm.startPrank(owner);
    //     vm.expectRevert("only trusted sender can add score");
    //     game.addScore(owner, 100);
    //     vm.stopPrank();

    //     vm.startPrank(_minimalForwarder);
    //     game.addScore(owner, 15);
    //     vm.expectRevert("Score too low");
    //     game.addScore(owner, 5);
    //     vm.stopPrank();
    // }

    // function test_IsGameRunningAndIsGameClaiming() public {
    //     vm.startPrank(owner);
    //     GameTicket gameTicket = new GameTicket();
    //     Lotto lotto = new Lotto(address(gameTicket));
    //     Game game = new Game(
    //         gameId,
    //         gameName,
    //         roundLength,
    //         claimPeriod,
    //         _minimalForwarder,
    //         address(gameTicket),
    //         gameDev,
    //         address(lotto)
    //     );
    //     vm.stopPrank();

    //     assertEq(true, game.isGameRunning());

    //     // vm.startPrank(owner);
    //     // vm.expectRevert("Pending on claim prize");
    //     // game.startNewGameRound();
    //     // vm.stopPrank();

    //     vm.warp(game.getCurrentGameRound().end + 10);

    //     assertEq(false, game.isGameRunning());
    //     assertEq(true, game.isClaiming());

    //     // vm.startPrank(owner);
    //     // vm.expectRevert("Pending on claim prize");
    //     // game.startNewGameRound();
    //     // vm.stopPrank();

    //     vm.warp(
    //         game.getCurrentGameRound().end +
    //             game.getCurrentGameRound().claimPeriod +
    //             10
    //     );

    //     assertEq(false, game.isClaiming());

    //     // vm.startPrank(owner);
    //     // game.startNewGameRound();
    //     // vm.stopPrank();

    //     // Game.Round memory currentRound = game.getCurrentGameRound();
    //     // assertEq(2, currentRound.gameRound);
    // }

    // function test_StartNewGameRound() public {
    //     vm.startPrank(owner);
    //     GameTicket gameTicket = new GameTicket();
    //     Lotto lotto = new Lotto(address(gameTicket));
    //     Game game = new Game(
    //         gameId,
    //         gameName,
    //         roundLength,
    //         claimPeriod,
    //         _minimalForwarder,
    //         address(gameTicket),
    //         gameDev,
    //         address(lotto)
    //     );
    //     vm.stopPrank();

    //     vm.warp(
    //         game.getCurrentGameRound().end +
    //             game.getCurrentGameRound().claimPeriod +
    //             10
    //     );

    //     // vm.startPrank(alice);
    //     // vm.expectRevert("Ownable: caller is not the owner");
    //     // game.startNewGameRound();
    //     // vm.stopPrank();

    //     // vm.startPrank(owner);
    //     // game.startNewGameRound();
    //     // vm.stopPrank();
    //     // assertEq(2, game.getCurrentGameRound().gameRound);

    //     // vm.warp(
    //     //     game.getCurrentGameRound().end +
    //     //         game.getCurrentGameRound().claimPeriod +
    //     //         10
    //     // );

    //     // vm.startPrank(owner);
    //     // game.startNewGameRound();
    //     // vm.stopPrank();
    //     // assertEq(3, game.getCurrentGameRound().gameRound);
    // }

    // function test_ClaimReward() public {
    //     vm.startPrank(owner);
    //     GameTicket gameTicket = new GameTicket();
    //     Lotto lotto = new Lotto(address(gameTicket));
    //     Game game = new Game(
    //         gameId,
    //         gameName,
    //         roundLength,
    //         claimPeriod,
    //         _minimalForwarder,
    //         address(gameTicket),
    //         gameDev,
    //         address(lotto)
    //     );
    //     vm.stopPrank();

    //     vm.deal(address(game), 100 ether);

    //     vm.startPrank(_minimalForwarder);
    //     game.addScore(alice, 10);
    //     game.addScore(alice, 20);
    //     game.addScore(alice, 30);
    //     game.addScore(alice, 40);
    //     game.addScore(alice, 50);
    //     game.addScore(alice, 60);
    //     game.addScore(alice, 70);
    //     game.addScore(doge, 80);
    //     game.addScore(carol, 90);
    //     game.addScore(bob, 100);
    //     vm.stopPrank();

    //     vm.startPrank(bob);
    //     vm.expectRevert("It is not in the claim prize period");
    //     game.claimReward();
    //     vm.stopPrank();

    //     vm.warp(block.timestamp + roundLength + 1);

    //     vm.startPrank(bob);
    //     assertEq(address(gameDev).balance, 0);
    //     game.claimReward();
    //     vm.stopPrank();
    //     uint prizeBob = address(bob).balance;
    //     uint expectedPrizeBob = (100 ether * FIRST) / 10;
    //     uint expectedPrize4GameDev = (100 ether * game.GAME_DEV_SHARE()) / 10;
    //     assertEq(address(gameDev).balance, expectedPrize4GameDev);
    //     assertEq(prizeBob, expectedPrizeBob);

    //     vm.startPrank(carol);
    //     game.claimReward();
    //     vm.stopPrank();

    //     uint prizeCarol = address(carol).balance;
    //     uint expectedPrizeCarol = (100 ether * SECOND) / 10;
    //     assertEq(prizeCarol, expectedPrizeCarol);

    //     vm.startPrank(doge);
    //     game.claimReward();
    //     vm.stopPrank();

    //     uint prizeDoge = address(doge).balance;
    //     uint expectedPrizeDoge = (100 ether * THIRD) / 10;
    //     assertEq(prizeDoge, expectedPrizeDoge);

    //     vm.startPrank(alice);
    //     uint beforeClaimAlice = address(alice).balance;
    //     game.claimReward();
    //     vm.stopPrank();

    //     uint afterClaimAlice = address(alice).balance;
    //     uint expectedPrizeAlice = (7 * (100 ether * OTHERS)) / 70;
    //     assertLe(afterClaimAlice - beforeClaimAlice, expectedPrizeAlice);
    // }

    // function test_updateTime() public {
    //     vm.startPrank(owner);
    //     GameTicket gameTicket = new GameTicket();
    //     Lotto lotto = new Lotto(address(gameTicket));
    //     Game game = new Game(
    //         gameId,
    //         gameName,
    //         roundLength,
    //         claimPeriod,
    //         _minimalForwarder,
    //         address(gameTicket),
    //         gameDev,
    //         address(lotto)
    //     );
    //     vm.stopPrank();

    //     vm.startPrank(bob);
    //     vm.expectRevert("Ownable: caller is not the owner");
    //     game.updateGamePeriodAndEndTime(600);
    //     vm.stopPrank();

    //     vm.startPrank(alice);
    //     vm.expectRevert("Ownable: caller is not the owner");
    //     game.updateClaimPeriod(600);
    //     vm.stopPrank();

    //     vm.startPrank(owner);
    //     game.updateGamePeriodAndEndTime(600);
    //     vm.stopPrank();

    //     vm.warp(block.timestamp + 600);

    //     vm.startPrank(_minimalForwarder);
    //     vm.expectRevert("Game is not running");
    //     game.addScore(owner, 10);
    //     vm.stopPrank();

    //     vm.warp(block.timestamp + claimPeriod + 1);

    //     // vm.startPrank(owner);
    //     // game.startNewGameRound();
    //     // assertEq(true, game.isGameRunning());
    //     // assertEq(false, game.isClaiming());
    //     // game.updateClaimPeriod(180);
    //     // console2.log(game.getCurrentGameRound().length);
    //     // vm.warp(block.timestamp + 600 + 130);
    //     // assertEq(true, game.isClaiming());
    //     // vm.warp(block.timestamp + 190);
    //     // assertEq(false, game.isClaiming());
    //     // vm.stopPrank();
    // }

    // function test_sendPrize() public {
    //     vm.startPrank(owner);
    //     GameTicket gameTicket = new GameTicket();
    //     Lotto lotto = new Lotto(address(gameTicket));
    //     Game game = new Game(
    //         gameId,
    //         gameName,
    //         roundLength,
    //         claimPeriod,
    //         _minimalForwarder,
    //         address(gameTicket),
    //         gameDev,
    //         address(lotto)
    //     );
    //     vm.stopPrank();

    //     vm.startPrank(owner);
    //     vm.expectRevert("You don't own the ticket");
    //     game.redeemTicket(1);
    //     vm.stopPrank();

    //     vm.deal(owner, 100 ether);
    //     vm.startPrank(owner);
    //     gameTicket.buyTicket{value: 0.1 ether}(1, 1);
    //     //need to setApprovalForAll or override burn function
    //     gameTicket.setApprovalForAll(address(game), true);
    //     vm.expectRevert("This is not a verified game!");
    //     game.redeemTicket(1);
    //     vm.stopPrank();

    //     vm.deal(owner, 100 ether);
    //     vm.startPrank(owner);
    //     assertEq(100000000000000000, address(gameTicket).balance);
    //     gameTicket.addVerifiedGame(address(game));
    //     game.redeemTicket(1);
    //     assertEq(0, address(gameTicket).balance);
    //     assertEq(100000000000000000, address(game).balance);
    //     vm.stopPrank();
    // }

    function test_StartNewGameRoundAndClaimGas() public {
        vm.deal(owner, 100 ether);

        vm.startPrank(owner);
        GameTicket gameTicket = new GameTicket();
        Lotto lotto = new Lotto(address(gameTicket));
        Game game = new Game(
            gameId,
            gameName,
            roundLength,
            claimPeriod,
            _minimalForwarder,
            address(gameTicket),
            gameDev,
            address(lotto)
        );

        gameTicket.addVerifiedGame(address(game));
        gameTicket.setApprovalForAll(address(game), true);
        gameTicket.buyTicket{value: 0.1 ether}(1, 1);

        game.redeemTicket(1);
        console2.log(address(game).balance);

        vm.stopPrank();

        vm.warp(
            game.getCurrentGameRound().end +
                game.getCurrentGameRound().claimPeriod +
                10
        );

        console2.log(game.isGameRunning());
        console2.log(game.isClaiming());

        vm.startPrank(owner);
        gameTicket.buyTicket{value: 0.1 ether}(1, 1);
        game.redeemTicket(1);
        vm.stopPrank();
    }
}
