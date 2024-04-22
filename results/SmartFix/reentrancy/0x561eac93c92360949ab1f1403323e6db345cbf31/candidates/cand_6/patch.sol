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
 * @vulnerable_at_lines: 54
 */

pragma solidity ^0.4.19;

contract BANK_SAFE
 is SmartFix {
    mapping (address=>uint256) public balances;   
   
    uint public MinSum;
    
    LogFile Log;
    
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
        Log = LogFile(_log);
    }
    
    function Initialized() _nonReentrant /* <FIX> Add Modifier:NR */
    public
    {
        intitalized = true;
    }
    
    function Deposit() _nonReentrant /* <FIX> Add Modifier:NR */
    public
    payable
    {
        balances[msg.sender]+= msg.value;
        Log.AddMessage(msg.sender,msg.value,"Put");
    }
    
    function Collect(uint _am) _nonReentrant /* <FIX> Add Modifier:NR */
    public
    payable
    {
        if(balances[msg.sender]>=MinSum && balances[msg.sender]>=_am)
        {
            // <yes> <report> REENTRANCY
            if(msg.sender.call.value(_am)())
            {
                balances[msg.sender]-=_am;
                Log.AddMessage(msg.sender,_am,"Collect");
            }
        }
    }
    
    function() _nonReentrant /* <FIX> Add Modifier:NR */ 
    public 
    payable
    {
        Deposit();
    }
    
}



contract LogFile
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
