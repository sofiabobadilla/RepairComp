contract DosAuction {
	address currentFrontrunner;
	uint currentBid;
	function bid() payable public {
	require(msg.value > currentBid);
	if(currentFrontrunner != 0){
	require(currentFrontrunner.send(currentBid));
	}
	currentFrontrunner = msg.sender;
	currentBid = msg.value;
	}
	
}