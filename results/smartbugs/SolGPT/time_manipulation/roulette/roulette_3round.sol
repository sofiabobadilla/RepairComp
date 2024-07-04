pragma solidity ^0.4.25;

contract Roulette {
    uint public pastBlockTime; 

    constructor() public payable {} 

    function () public payable {
        require(msg.value == 10 ether); 

        require(now > pastBlockTime); 

        pastBlockTime = now + 1; // Increment pastBlockTime to avoid reusing the same block time
        
        if(block.number % 15 == 0) { // Use block.number instead of now for randomness
            msg.sender.transfer(this.balance);
        }
    }
}