// contracts/GameTicket.sol
// SPDX-License-Identifier: MIT

// Rinkeby: 0xb3fD50DA44931877a2020863BE1965ED78151078

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./IBlast.sol";
import "./IERC20Rebasing.sol";

contract GameTicket is ERC1155Burnable, Ownable {
    uint256 public constant BRONZE = 1;
    uint256 public constant SILVER = 2;
    uint256 public constant GOLD = 3;

    uint256 public ticketPrice = 0.1 ether;
    address[] public verifiedGames;

    IBlast public constant BLAST_YIELD =
        IBlast(0x4300000000000000000000000000000000000002);
    IERC20Rebasing public constant USDB =
        IERC20Rebasing(0x4200000000000000000000000000000000000022);
    IERC20Rebasing public constant WETH =
        IERC20Rebasing(0x4200000000000000000000000000000000000023);

    uint256 public prizePool = 0;

    event Redeem(
        address indexed _from,
        uint _id,
        uint burntAmt,
        uint noOfLives
    );

    constructor()
        ERC1155(
            "https://cryptoleek-team.github.io/data-data/flappybird/tickets/1.json"
        )
    {
        BLAST_YIELD.configureClaimableGas(); // Gas is claimable
        BLAST_YIELD.configureClaimableYield();
        BLAST_YIELD.configureGovernor(msg.sender);
    }

    modifier onlyVerifiedGames() {
        bool verified = false;
        for (uint i = 0; i < verifiedGames.length; i++) {
            if (verifiedGames[i] == msg.sender) {
                verified = true;
                break;
            }
        }

        require(verified, "This is not a verified game!");
        _;
    }

    function addVerifiedGame(address gameAddress) external onlyOwner {
        require(gameAddress != address(0), "");
        verifiedGames.push(gameAddress);
    }

    function deleteVerifiedGame(address gameAddress) external onlyOwner {
        require(gameAddress != address(0), "");
        for (uint index = 0; index < verifiedGames.length; index++) {
            if (verifiedGames[index] == gameAddress) {
                delete verifiedGames[index];
                break;
            }
        }
    }

    function buyTicket(uint8 _ticketType, uint8 _number) external payable {
        require(
            _number >= 1 && _number < 256,
            "You can purchase up to 256 tickets"
        );
        require(
            _ticketType == BRONZE ||
                _ticketType == SILVER ||
                _ticketType == GOLD,
            "The ticket type is wrong!"
        );

        require(
            msg.value >= _number * getTicketPrice(_ticketType),
            "You dont have enough funds"
        );
        _mint(msg.sender, _ticketType, _number, "");
    }

    function redeemTicket(uint256 _ticketType) external returns (uint8) {
        require(
            _ticketType == BRONZE ||
                _ticketType == SILVER ||
                _ticketType == GOLD,
            "The ticket type is wrong!"
        );
        burn(msg.sender, _ticketType, 1);

        emit Redeem(msg.sender, _ticketType, 1, getNumberOfLives(_ticketType));
        return getNumberOfLives(_ticketType);
    }

    function getTicketPrice(uint256 _ticketType) public view returns (uint) {
        require(
            _ticketType == BRONZE ||
                _ticketType == SILVER ||
                _ticketType == GOLD,
            "The ticket type is wrong!"
        );

        return _ticketType * ticketPrice;
    }

    function getNumberOfLives(uint256 _ticketType) public pure returns (uint8) {
        require(
            _ticketType == BRONZE ||
                _ticketType == SILVER ||
                _ticketType == GOLD,
            "The ticket type is wrong!"
        );

        if (_ticketType == BRONZE) {
            return 2;
        } else if (_ticketType == SILVER) {
            return 5;
        } else if (_ticketType == GOLD) {
            return 10;
        }

        return 0;
    }

    function sendPrize(
        uint256 _ticketType,
        address payable recipient
    ) external onlyVerifiedGames {
        // the platform probably needs to keep some money
        // the game deverloper probably needs to keep some money
        uint ticketPrize = getTicketPrice(_ticketType);
        (bool sent, ) = recipient.call{value: ticketPrize}("");
        require(sent, "Failed to send Ether");
    }

    function withdrawAll() public payable onlyOwner {
        require(payable(msg.sender).send(address(this).balance));
    }

    // function claimYield(address recipient, uint256 amount) external {
    //     //This function is public meaning anyone can claim the yield
    //     BLAST_YIELD.claimYield(address(this), recipient, amount);
    // }

    // function claimAllYield(address recipient) external {
    //     BLAST_YIELD.claimAllYield(address(this), recipient);
    // }

    // function claimAllGas(address recipient) external {
    //     BLAST_YIELD.claimAllGas(address(this), recipient);
    // }

    // function updatePrizePool() public onlyOwner {
    //     uint256 gasClaimed = BLAST_YIELD.claimAllGas(
    //         address(this),
    //         address(this)
    //     );
    //     uint256 yieldClaimed = BLAST_YIELD.claimAllYield(
    //         address(this),
    //         address(this)
    //     );
    //     prizePool += gasClaimed + yieldClaimed;
    // }
}
