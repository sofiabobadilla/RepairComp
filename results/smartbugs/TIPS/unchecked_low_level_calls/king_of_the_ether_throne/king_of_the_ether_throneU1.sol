contract KingOfTheEtherThrone {
	struct Monarch{
	address etherAddress;
	string name;
	uint claimPrice;
	uint coronationTimestamp;
	}
	address wizardAddress;
	modifier onlywizard(){
	if(msg.sender == wizardAddress){
	_;}
	}
	uint constant startingClaimPrice = 100 finney;
	uint constant claimPriceAdjustNum = 3;
	uint constant claimPriceAdjustDen = 2;
	uint constant wizardCommissionFractionNum = 1;
	uint constant wizardCommissionFractionDen = 100;
	uint public currentClaimPrice;
	Monarch public currentMonarch;
	Monarch[] public pastMonarchs;
	constructor() public {
	wizardAddress = msg.sender;
	currentClaimPrice = startingClaimPrice;
	currentMonarch = Monarch(wizardAddress, "[Vacant]", 0, block.timestamp);
	}
	function numberOfMonarchs() view public returns(uint n){
	return pastMonarchs.length;
	}
	event ThroneClaimed(address usurperEtherAddress, string usurperName, uint newClaimPrice);
	function () public {
	claimThrone(string(msg.data));
	}
	function claimThrone(string name) public {
	uint valuePaid = msg.value;
	if(valuePaid < currentClaimPrice){
	if(! msg.sender.send(valuePaid)){
	throw;}
	return ;
	}
	if(valuePaid > currentClaimPrice){
	uint excessPaid = valuePaid - currentClaimPrice;
	if(! msg.sender.send(excessPaid)){
	throw;}
	valuePaid = valuePaid - excessPaid;
	}
	uint wizardCommission = (valuePaid * wizardCommissionFractionNum) / wizardCommissionFractionDen;
	uint compensation = valuePaid - wizardCommission;
	if(currentMonarch.etherAddress != wizardAddress){
	if(! currentMonarch.etherAddress.send(compensation)){
	throw;}
	}
	else{
	}
	pastMonarchs.push(currentMonarch);
	currentMonarch = Monarch(msg.sender, name, valuePaid, block.timestamp);
	uint rawNewClaimPrice = currentClaimPrice * claimPriceAdjustNum / claimPriceAdjustDen;
	if(rawNewClaimPrice < 10 finney){
	currentClaimPrice = rawNewClaimPrice;
	}
	else{
	if(rawNewClaimPrice < 100 finney){
	currentClaimPrice = 100 szabo * (rawNewClaimPrice / 100 szabo);
	}
	else{
	if(rawNewClaimPrice < 1 ether){
	currentClaimPrice = 1 finney * (rawNewClaimPrice / 1 finney);
	}
	else{
	if(rawNewClaimPrice < 10 ether){
	currentClaimPrice = 10 finney * (rawNewClaimPrice / 10 finney);
	}
	else{
	if(rawNewClaimPrice < 100 ether){
	currentClaimPrice = 100 finney * (rawNewClaimPrice / 100 finney);
	}
	else{
	if(rawNewClaimPrice < 1000 ether){
	currentClaimPrice = 1 ether * (rawNewClaimPrice / 1 ether);
	}
	else{
	if(rawNewClaimPrice < 10000 ether){
	currentClaimPrice = 10 ether * (rawNewClaimPrice / 10 ether);
	}
	else{
	currentClaimPrice = rawNewClaimPrice;
	}
	}
	}
	}
	}
	}
	}
	ThroneClaimed(currentMonarch.etherAddress, currentMonarch.name, currentClaimPrice);
	}
	function sweepCommission(uint amount) onlywizard public {
	if(! wizardAddress.send(amount)){
	throw;}
	}
	function transferOwnership(address newOwner) onlywizard public {
	wizardAddress = newOwner;
	}
	
}