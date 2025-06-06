pragma solidity ^0.4.24;

contract MyContract {

    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function sendTo(address receiver, uint amount) public {
        require(msg.sender == owner);
        require(receiver != address(0)); // Check if receiver address is valid
        require(amount > 0); // Check if amount is greater than 0
        receiver.transfer(amount);
    }
}