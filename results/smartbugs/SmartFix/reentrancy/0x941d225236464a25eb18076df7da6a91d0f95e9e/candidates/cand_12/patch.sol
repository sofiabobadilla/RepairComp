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
 * @vulnerable_at_lines: 44
 */

pragma solidity ^0.4.19;

contract ETH_FUND
 is SmartFix {
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    uint lastBlock;
    
    function ETH_FUND(address _log)
    public 
    {
        TransferLog = Log(_log);
    }
    
    function Deposit() _nonReentrant /* <FIX> Add Modifier:NR */
    public
    payable
    {
        if(msg.value > MinDeposit)
        {
            balances[msg.sender]+=msg.value;
            TransferLog.AddMessage(msg.sender,msg.value,"Deposit");
            lastBlock = block.number;
        }
    }
    
    function CashOut(uint _am) _nonReentrant /* <FIX> Add Modifier:NR */
    public
    payable
    {
        if((_am > balances[msg.sender])&&block.number>lastBlock) /* <FIX> Replace: "(_am <= balances[msg.sender])" => "(_am > balances[msg.sender])" */
        {
            // <yes> <report> REENTRANCY
            if(msg.sender.call.value(_am)())
            {
                balances[msg.sender]-=_am;
                TransferLog.AddMessage(msg.sender,_am,"CashOut");
            }
        }
    }
    
    function() _nonReentrant /* <FIX> Add Modifier:NR */ public payable{}    
    
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
