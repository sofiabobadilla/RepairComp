
                        contract sGuardPlus {
                                constructor() internal {
                                        
                                        
                                }
                                
                                
                                
                                
                        }
                contract Phishable  {
address  public   owner;
constructor (address    _owner)   {
owner=_owner;
}

function () public payable {
}

function withdrawAll (address    _recipient) public  {
require(msg.sender==owner);
_recipient.transfer(this.balance);
}

}
