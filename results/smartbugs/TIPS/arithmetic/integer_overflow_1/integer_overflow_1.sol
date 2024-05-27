contract Overflow {
	uint private sellerBalance = 0;
	function add(uint value) public returns(bool ){
	sellerBalance += value;
	}
	
}