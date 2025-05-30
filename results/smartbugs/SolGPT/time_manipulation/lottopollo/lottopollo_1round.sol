pragma solidity ^0.4.0;

contract lottopollo {
    address leader;
    uint timestamp;

    function payOut(uint rand) internal {
        if (rand > 0 && now - rand > 24 hours) {
            if (msg.sender.send(msg.value)) {
                if (this.balance > 0) {
                    leader.transfer(this.balance);
                }
            }
        } else if (msg.value >= 1 ether) {
            leader = msg.sender;
            timestamp = rand;
        }
    }

    function randomGen() constant returns (uint randomNumber) {
        return uint(keccak256(block.timestamp)) % 100;
    }

    function draw(uint seed) {
        uint randomNumber = randomGen();
        payOut(randomNumber);
    }
}