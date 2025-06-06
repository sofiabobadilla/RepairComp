pragma solidity ^0.4.21;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 constant PRICE_PER_TOKEN = 1 ether;
    uint256 public contractBalance;

    function TokenSaleChallenge(address _player) public payable {
        require(msg.value == 1 ether);
        contractBalance = msg.value;
    }

    function isComplete() public view returns (bool) {
        return contractBalance < 1 ether;
    }

    function buy(uint256 numTokens) public payable {
        require(msg.value == numTokens * PRICE_PER_TOKEN);
        
        balanceOf[msg.sender] += numTokens;
        contractBalance += msg.value;
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens);

        balanceOf[msg.sender] -= numTokens;
        uint256 amount = numTokens * PRICE_PER_TOKEN;
        require(contractBalance >= amount);

        contractBalance -= amount;
        msg.sender.transfer(amount);
    }
}