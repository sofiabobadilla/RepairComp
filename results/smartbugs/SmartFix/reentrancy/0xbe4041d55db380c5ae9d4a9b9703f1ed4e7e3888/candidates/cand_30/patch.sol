contract SmartFix {
  bool public _locked = false;

  modifier _nonReentrant() {
    require(!_locked);
    _locked = true;
    _;
    _locked = false;
  }
}

/*
 * @source: etherscan.io 
 * @author: -
 * @vulnerable_at_lines: 63
 */

pragma solidity ^0.4.19;

contract MONEY_BOX  
 is SmartFix {
    struct Holder   
    {
        uint unlockTime;
        uint balance;
    }
    
    mapping (address => Holder) public Acc;
    
    uint public MinSum;
    
    Log LogFile;
    
    bool intitalized;
    
    function SetMinSum(uint _val) _nonReentrant /* <FIX> Add Modifier:NR */
    public
    {
        if(intitalized)throw;
        MinSum = _val;
    }
    
    function SetLogFile(address _log) _nonReentrant /* <FIX> Add Modifier:NR */
    public
    {
        if(intitalized)throw;
        LogFile = Log(_log);
    }
    
    function Initialized() _nonReentrant /* <FIX> Add Modifier:NR */
    public
    {
        intitalized = true;
    }
    
    function Put(uint _lockTime) _nonReentrant /* <FIX> Add Modifier:NR */
    public
    payable
    {
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        if(now+_lockTime>acc.unlockTime)acc.unlockTime=now+_lockTime;
        LogFile.AddMessage(msg.sender,msg.value,"Put");
    }
    
    function Collect(uint _am) _nonReentrant /* <FIX> Add Modifier:NR */
    public
    payable
    {
        var acc = Acc[msg.sender];
        if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime)
        {
            // <yes> <report> REENTRANCY
            if(msg.sender.call.value(_am)())
            {
                require((acc.balance >= _am)); /* <FIX> Insert:BC */
                acc.balance-=_am;
                LogFile.AddMessage(msg.sender,_am,"Collect");
            }
        }
    }
    
    function() 
    public 
    payable
    {
        Put(0);
    }
    
}


contract Log 
{
    struct Message
    {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }
    
    Message[] public History;
    
    Message LastMsg;
    
    function AddMessage(address _adr,uint _val,string _data)
    public
    {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}
