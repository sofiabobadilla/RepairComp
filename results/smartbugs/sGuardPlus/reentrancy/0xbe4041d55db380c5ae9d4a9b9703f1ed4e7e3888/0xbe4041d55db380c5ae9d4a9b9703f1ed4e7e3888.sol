
                        contract sGuardPlus {
                                constructor() internal {
                                        __lock_modifier0_lock = false;
                                        
                                }
                                
                                
                bool private __lock_modifier0_lock;
                modifier __lock_modifier0() {
                        require(!__lock_modifier0_lock);
                        __lock_modifier0_lock = true;
                        _;
                        __lock_modifier0_lock = false;
                        
                }
                
                                
                                
                        }
                contract MONEY_BOX is sGuardPlus {
struct Holder {
uint     unlockTime;
uint     balance;
}
mapping (address  => Holder ) public   Acc;
uint  public   MinSum;
Log     LogFile;
bool     intitalized;
function SetMinSum (uint    _val) public  {
if (intitalized)
throw;
MinSum=_val;
}

function SetLogFile (address    _log) public  {
if (intitalized)
throw;
LogFile=Log(_log);
}

function Initialized () public  {
intitalized=true;
}

function Put (uint    _lockTime) public payable {
var     acc = Acc[msg.sender];
acc.balance+=msg.value;
if (now+_lockTime>acc.unlockTime)
acc.unlockTime=now+_lockTime;

LogFile.AddMessage(msg.sender, msg.value, "Put");
}

function Collect (uint    _am) public __lock_modifier0 payable {
var     acc = Acc[msg.sender];
if (acc.balance>=MinSum&&acc.balance>=_am&&now>acc.unlockTime)
{
if (msg.sender.call.value(_am)())
{
acc.balance-=_am;
LogFile.AddMessage(msg.sender, _am, "Collect");
}

}

}

function () public payable {
Put(0);
}

}
contract Log  {
struct Message {
address     Sender;
string     Data;
uint     Val;
uint     Time;
}
Message [] public   History;
Message     LastMsg;
function AddMessage (address    _adr,uint    _val,string    _data) public  {
LastMsg.Sender=_adr;
LastMsg.Time=now;
LastMsg.Val=_val;
LastMsg.Data=_data;
History.push(LastMsg);
}

}
