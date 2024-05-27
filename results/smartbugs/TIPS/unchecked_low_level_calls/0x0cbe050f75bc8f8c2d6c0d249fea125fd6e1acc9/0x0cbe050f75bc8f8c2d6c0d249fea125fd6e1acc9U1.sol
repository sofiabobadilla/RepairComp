contract Caller {
	function callAddress(address a) public {
	if(! a.call()){
	throw;}
	}
	
}