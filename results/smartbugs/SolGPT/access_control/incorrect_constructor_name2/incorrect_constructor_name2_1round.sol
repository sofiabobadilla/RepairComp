pragma solidity ^0.4.24;

contract Missing {
    address private owner;

    modifier onlyowner {
        require(msg.sender == owner);
        _;
    }

    function Missing() public {
        owner = msg.sender;
    }

    function () external payable {}

    function withdraw() public onlyowner {
        owner.transfer(address(this).balance);
    }
}