// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NumberGuessingGame {
    address private owner;
    uint8 private secretNumber;
    uint256 private prizePool;
    bool private gameActive;

    mapping(address => bool) private hasPlayed;

    function setGame() public {
        require(owner == address(0) || msg.sender == owner, "Only owner can reset game");
        require(!gameActive, "Game already active");

        owner = msg.sender;
        secretNumber = uint8(block.timestamp % 10) + 1; // Generate a number between 1-10
        gameActive = true;
        prizePool = 0;
    }

    function play() public payable {
        require(gameActive, "Game is not active");
        require(msg.value >= 0.01 ether, "Minimum 0.01 ETH required");
        require(!hasPlayed[msg.sender], "You have already played");

        hasPlayed[msg.sender] = true;
        prizePool += msg.value;

        if ((uint8(uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)))) % 10) + 1 == secretNumber) {
            payable(msg.sender).transfer(prizePool);
            gameActive = false;
        }
    }

    function getPrizePool() public view returns (uint256) {
        return prizePool;
    }

    function isGameActive() public view returns (bool) {
        return gameActive;
    }
}
