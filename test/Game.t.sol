// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {GameLeaderboard} from "../src/GameLeaderboard.sol";
import {Game} from "../src/Game.sol";

contract GameTest is Test {
    uint gameId = 1;
    string gameName = "germs";
    uint roundLength = 60;
    uint claimPeriod = 120;

    uint public constant FIRST = 4; // 40% prize goes to 1st ranked player
    uint public constant SECOND = 2; // 20% prize goes to 2nd ranked player
    uint public constant THIRD = 1; // 10% prize goes to 3rd ranked player
    uint public constant OTHERS = 3; // 30% prize goes to other ranked players

    // GameLeaderboard gameLeaderboard = new GameLeaderboard(gameId, gameName);
    // Game.Round round =
    //     Game.Round(
    //         roundLength,
    //         1,
    //         block.timestamp + roundLength,
    //         claimPeriod,
    //         gameLeaderboard
    //     );

    address public owner = vm.envAddress("DEPLOYER");
    address public alice = vm.envAddress("ALICE");
    address public bob = vm.envAddress("BOB");
    address public carol = vm.envAddress("CAROL");
    address public doge = vm.envAddress("DOGE");

    function test_SetupConstructorCorrectly() public {
        Game game = new Game(gameId, gameName, roundLength, claimPeriod);
        Game.Round memory round = game.getCurrentGameRound();
        assertEq(round.length, roundLength);
        assertEq(round.claimPeriod, claimPeriod);
    }

    function test_AddScore() public {
        vm.startPrank(owner);
        Game game = new Game(gameId, gameName, roundLength, claimPeriod);
        game.addScore(owner, 10);
        game.addScore(alice, 20);
        game.addScore(alice, 30);
        game.addScore(alice, 40);
        game.addScore(bob, 50);
        game.addScore(alice, 60);
        game.addScore(alice, 70);
        game.addScore(carol, 80);
        vm.stopPrank();

        GameLeaderboard _gameLeaderboard = game.getCurrentGameBoard();
        GameLeaderboard.User memory firstUser = _gameLeaderboard.getUser(0);
        address firstRanked = firstUser.user;
        uint firstScore = firstUser.score;
        assertEq(carol, firstRanked);
        assertEq(firstScore, 80);

        vm.startPrank(owner);
        game.addScore(doge, 90);
        vm.stopPrank();
        GameLeaderboard.User memory newFirstUser = _gameLeaderboard.getUser(0);
        address newFirstRanked = newFirstUser.user;
        uint newFirstScore = newFirstUser.score;
        assertEq(carol, firstRanked);
        assertEq(newFirstScore, 90);

        vm.startPrank(alice);
        vm.expectRevert("Ownable: caller is not the owner");
        game.addScore(owner, 100);
        vm.stopPrank();

        vm.startPrank(owner);
        game.addScore(owner, 15);
        vm.expectRevert("Score too low");
        game.addScore(owner, 5);
        vm.stopPrank();
    }

    function test_IsGameRunningAndIsGameClaiming() public {
        vm.startPrank(owner);
        Game game = new Game(gameId, gameName, roundLength, claimPeriod);
        vm.stopPrank();

        assertEq(true, game.isGameRunning());

        vm.startPrank(owner);
        vm.expectRevert("Pending on claim prize");
        game.startNewGameRound();
        vm.stopPrank();

        vm.warp(game.getCurrentGameRound().end + 10);

        assertEq(false, game.isGameRunning());
        assertEq(true, game.isClaiming());

        vm.startPrank(owner);
        vm.expectRevert("Pending on claim prize");
        game.startNewGameRound();
        vm.stopPrank();

        vm.warp(
            game.getCurrentGameRound().end +
                game.getCurrentGameRound().claimPeriod +
                10
        );

        assertEq(false, game.isClaiming());

        vm.startPrank(owner);
        game.startNewGameRound();
        vm.stopPrank();

        Game.Round memory currentRound = game.getCurrentGameRound();
        assertEq(2, currentRound.gameRound);
    }

    function test_StartNewGameRound() public {
        vm.startPrank(owner);
        Game game = new Game(gameId, gameName, roundLength, claimPeriod);
        vm.stopPrank();

        vm.warp(
            game.getCurrentGameRound().end +
                game.getCurrentGameRound().claimPeriod +
                10
        );

        vm.startPrank(alice);
        vm.expectRevert("Ownable: caller is not the owner");
        game.startNewGameRound();
        vm.stopPrank();

        vm.startPrank(owner);
        game.startNewGameRound();
        vm.stopPrank();
        assertEq(2, game.getCurrentGameRound().gameRound);

        vm.warp(
            game.getCurrentGameRound().end +
                game.getCurrentGameRound().claimPeriod +
                10
        );

        vm.startPrank(owner);
        game.startNewGameRound();
        vm.stopPrank();
        assertEq(3, game.getCurrentGameRound().gameRound);
    }

    function test_ClaimReward() public {
        vm.startPrank(owner);
        Game game = new Game(gameId, gameName, roundLength, claimPeriod);
        vm.deal(address(game), 100 ether);
        console2.log("balance", address(game).balance);
        game.addScore(alice, 10);
        game.addScore(alice, 20);
        game.addScore(alice, 30);
        game.addScore(alice, 40);
        game.addScore(alice, 50);
        game.addScore(alice, 60);
        game.addScore(owner, 70);
        game.addScore(doge, 80);
        game.addScore(carol, 90);
        game.addScore(bob, 100);
        vm.stopPrank();

        vm.startPrank(bob);
        vm.expectRevert("It is not in the claim prize period");
        game.claimReward();
        vm.stopPrank();

        vm.warp(block.timestamp + roundLength + 1);

        vm.startPrank(bob);
        game.claimReward();
        vm.stopPrank();

        uint prizeBob = address(bob).balance;
        uint expectedPrizeBob = (100 ether * FIRST) / 10;

        assertEq(prizeBob, expectedPrizeBob);

        vm.startPrank(carol);
        game.claimReward();
        vm.stopPrank();

        uint prizeCarol = address(carol).balance;
        uint expectedPrizeCarol = (100 ether * SECOND) / 10;
        assertEq(prizeCarol, expectedPrizeCarol);

        vm.startPrank(doge);
        game.claimReward();
        vm.stopPrank();

        uint prizeDoge = address(doge).balance;
        uint expectedPrizeDoge = (100 ether * THIRD) / 10;
        assertEq(prizeDoge, expectedPrizeDoge);

        vm.startPrank(owner);
        game.claimReward();
        vm.stopPrank();

        uint prizeOwner = address(owner).balance;
        uint expectedPrizeOwner = (100 ether * OTHERS) / 70;
        assertEq(prizeOwner, expectedPrizeOwner);

        vm.startPrank(alice);
        game.claimReward();
        vm.stopPrank();

        uint prizeAlice = address(alice).balance;
        uint expectedPrizeAlice = (6 * (100 ether * OTHERS)) / 70;
        assertLe(expectedPrizeAlice - prizeAlice, 100);
    }
}
