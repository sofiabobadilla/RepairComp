
                        contract sGuardPlus {
                                constructor() internal {
                                        
                                        
                                }
                                function add_uint(uint a, uint b) internal pure returns (uint) {
                                uint c = a + b;
                                assert(c >= a);
                                return c;
                        }
function sub_uint256(uint256 a, uint256 b) internal pure returns (uint256) {
                                assert(b <= a);
                                return a - b;
                        }
function add_uint8(uint8 a, uint8 b) internal pure returns (uint8) {
                                uint8 c = a + b;
                                assert(c >= a);
                                return c;
                        }
function add_uint256(uint256 a, uint256 b) internal pure returns (uint256) {
                                uint256 c = a + b;
                                assert(c >= a);
                                return c;
                        }
function mul_uint256(uint256 a, uint256 b) internal pure returns (uint256) {
                                if (a == 0) {
                                        return 0;
                                }
                                uint256 c = a * b;
                                assert(c / a == b);
                                return c;
                        }
function pow_uint256(uint256 a, uint256 b) internal pure returns (uint256) {
                                uint256 c = 1;
                                for(uint256 i = 0; i < b; i = add_uint256(i, 1)){
                                        c = mul_uint256(c, a);
                                }
                                return c;
                        }
function div_uint(uint a, uint b) internal pure returns (uint) {
                                uint c = a / b;
                                return c;
                        }
function mul_uint(uint a, uint b) internal pure returns (uint) {
                                if (a == 0) {
                                        return 0;
                                }
                                uint c = a * b;
                                assert(c / a == b);
                                return c;
                        }
function sub_uint(uint a, uint b) internal pure returns (uint) {
                                assert(b <= a);
                                return a - b;
                        }
function add_uint32(uint32 a, uint32 b) internal pure returns (uint32) {
                                uint32 c = a + b;
                                assert(c >= a);
                                return c;
                        }
                                
                                
                                
                        }
                contract Government is sGuardPlus {
uint32  public   lastCreditorPayedOut;
uint  public   lastTimeOfNewCredit;
uint  public   profitFromCrash;
address [] public   creditorAddresses;
uint [] public   creditorAmounts;
address  public   corruptElite;
mapping (address  => uint )    buddies;
uint   constant  TWELVE_HOURS = 43200;
uint8  public   round;
constructor ()   {
profitFromCrash=msg.value;
corruptElite=msg.sender;
lastTimeOfNewCredit=block.timestamp;
}

function lendGovernmentMoney (address    buddy)   returns (bool    ){
uint     amount = msg.value;
if (add_uint(lastTimeOfNewCredit, TWELVE_HOURS)<block.timestamp)
{
bool     __sent_result107 = msg.sender.send(amount);
require(__sent_result107);
bool     __sent_result108 = creditorAddresses[sub_uint256(creditorAddresses.length, 1)].send(profitFromCrash);
require(__sent_result108);
bool     __sent_result109 = corruptElite.send(this.balance);
require(__sent_result109);
lastCreditorPayedOut=0;
lastTimeOfNewCredit=block.timestamp;
profitFromCrash=0;
creditorAddresses=new address [](0);
creditorAmounts=new uint [](0);
round=add_uint8(round, 1);
return false;
}
 else 
{
if (amount>=pow_uint256(10, 18))
{
lastTimeOfNewCredit=block.timestamp;
creditorAddresses.push(msg.sender);
creditorAmounts.push(div_uint(mul_uint(amount, 110), 100));
bool     __sent_result114 = corruptElite.send(div_uint(mul_uint(amount, 5), 100));
require(__sent_result114);
if (profitFromCrash<mul_uint256(10000, pow_uint256(10, 18)))
{
profitFromCrash=add_uint(profitFromCrash, div_uint(mul_uint(amount, 5), 100));
}

if (buddies[buddy]>=amount)
{
bool     __sent_result117 = buddy.send(div_uint(mul_uint(amount, 5), 100));
require(__sent_result117);
}

buddies[msg.sender]=add_uint(buddies[msg.sender], div_uint(mul_uint(amount, 110), 100));
if (creditorAmounts[lastCreditorPayedOut]<=sub_uint(address(this).balance, profitFromCrash))
{
bool     __sent_result118 = creditorAddresses[lastCreditorPayedOut].send(creditorAmounts[lastCreditorPayedOut]);
require(__sent_result118);
buddies[creditorAddresses[lastCreditorPayedOut]]=sub_uint(buddies[creditorAddresses[lastCreditorPayedOut]], creditorAmounts[lastCreditorPayedOut]);
lastCreditorPayedOut=add_uint32(lastCreditorPayedOut, 1);
}

return true;
}
 else 
{
bool     __sent_result119 = msg.sender.send(amount);
require(__sent_result119);
return false;
}

}

}

function ()   {
lendGovernmentMoney(0);
}

function totalDebt ()   returns (uint    debt){
for(uint     i = lastCreditorPayedOut;i<creditorAmounts.length; i ++ ){
debt+=creditorAmounts[i];
}

}

function totalPayedOut ()   returns (uint    payout){
for(uint     i = 0;i<lastCreditorPayedOut; i ++ ){
payout+=creditorAmounts[i];
}

}

function investInTheSystem ()   {
profitFromCrash+=msg.value;
}

function inheritToNextGeneration (address    nextGeneration)   {
if (msg.sender==corruptElite)
{
corruptElite=nextGeneration;
}

}

function getCreditorAddresses ()   returns (address []   ){
return creditorAddresses;
}

function getCreditorAmounts ()   returns (uint []   ){
return creditorAmounts;
}

}
