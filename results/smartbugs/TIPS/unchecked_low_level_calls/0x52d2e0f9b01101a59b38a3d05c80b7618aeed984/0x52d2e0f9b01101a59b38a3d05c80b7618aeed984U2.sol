contract Token {
	function transfer(address _to, uint _value) public returns(bool success);function balanceOf(address _owner) view public returns(uint balance);
}contract EtherGet {
	address owner;
	constructor() public {
	owner = msg.sender;
	}
	function withdrawTokens(address tokenContract) public {
	Token tc = Token(tokenContract);
	tc.transfer(owner, tc.balanceOf(this));
	}
	function withdrawEther() public {
	owner.transfer(this.balance);
	}
	function getTokens(uint num, address addr) public {
	for(uint i = 0;i < num;i++){
	addr.transfer(0 wei);
	}
	}
	
}