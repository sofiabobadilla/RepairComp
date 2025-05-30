pragma solidity ^0.4.11;

contract MyToken {
    mapping (address => uint) balances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    constructor() {
        balances[msg.sender] = 10000;
    }

    function sendCoin(address to, uint amount) public returns(bool sufficient) {
        require(amount > 0);
        if (balances[msg.sender] < amount) return false;
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function getBalance(address addr) public view returns(uint) {
        return balances[addr];
    }
}