// contracts/GameLeaderboard.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';

contract GameLeaderboard is Ownable {
  // lists top 10 users
  uint public leaderboardLength = 10;
  uint public gameId;
  string public gameName;

  // create an array of Users
  mapping(uint => User) public leaderboard;

  // each user has a username and score
  struct User {
    address user;
    uint score;
    bool prizeClaimed;
  }

  constructor(uint _gameId, string memory _gameName) {
    gameId = _gameId;
    gameName = _gameName;
  }

  // owner calls to update leaderboard
  function addScore(address user, uint score) public onlyOwner {
    require(score >= leaderboard[leaderboardLength - 1].score, 'Score too low');

    // loop through the leaderboard
    for (uint i = 0; i < leaderboardLength; i++) {
      // find where to insert the new score
      if (leaderboard[i].score < score) {
        // shift leaderboard
        User memory currentUser = leaderboard[i];
        for (uint j = i + 1; j < leaderboardLength + 1; j++) {
          User memory nextUser = leaderboard[j];
          leaderboard[j] = currentUser;
          currentUser = nextUser;
        }

        // insert
        leaderboard[i] = User({user: user, score: score, prizeClaimed: false});

        // delete last from list
        delete leaderboard[leaderboardLength];

        break;
      }
    }
  }

  function getLeaderBoardInfo() public view returns (User[] memory) {
    User[] memory users = new User[](leaderboardLength);

    for (uint i = 0; i < leaderboardLength; i++) {
      User memory _user = leaderboard[i];
      users[i] = _user;
    }

    return users;
  }

  function getUser(uint index) public view returns (User memory){
    return leaderboard[index];
  }
}