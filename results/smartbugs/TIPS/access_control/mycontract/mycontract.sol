contract MyContract {
	address owner;
	constructor() public {
	owner = msg.sender;
	}
	function sendTo(address receiver, uint amount) public {
	require(msg.sender == owner);
	receiver.transfer(amount);
	}
	
}