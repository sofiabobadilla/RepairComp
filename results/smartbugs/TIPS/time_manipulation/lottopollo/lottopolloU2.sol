contract lottopollo {
	address leader;
	uint timestamp;
	function payOut(uint rand) internal {
	if(rand > 0 && now - rand > 24 hours){
	msg.sender.transfer(msg.value);
	if(this.balance > 0){
	leader.transfer(this.balance);
	}
	}
	else{
	if(msg.value >= 1 ether){
	leader = msg.sender;
	timestamp = rand;
	}
	}
	}
	function randomGen() view public returns(uint randomNumber){
	return block.timestamp;
	}
	function draw(uint seed) public {
	uint randomNumber = randomGen();
	payOut(randomNumber);
	}
	
}