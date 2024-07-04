pragma solidity ^0.4.15;

contract DosAuction {
    address public currentFrontrunner;
    uint public currentBid;

    function bid() public payable {
        require(msg.value > currentBid);

        if (currentFrontrunner != address(0)) {
            uint refundAmount = currentBid;
            address previousFrontrunner = currentFrontrunner;
            currentFrontrunner = msg.sender;
            currentBid = msg.value;

            require(previousFrontrunner.send(refundAmount));
        } else {
            currentFrontrunner = msg.sender;
            currentBid = msg.value;
        }
    }
}