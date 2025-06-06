pragma solidity ^0.4.21;

contract GuessTheRandomNumberChallenge {
    uint8 answer;
    bool public isCompleted;

    function GuessTheRandomNumberChallenge() public payable {
        require(msg.value == 1 ether);

        answer = uint8(keccak256(block.blockhash(block.number - 1), now));
        isCompleted = false;
    }

    function isComplete() public view returns (bool) {
        return isCompleted;
    }

    function guess(uint8 n) public payable {
        require(msg.value == 1 ether);

        if (n == answer) {
            msg.sender.transfer(2 ether);
            isCompleted = true;
        }
    }
}