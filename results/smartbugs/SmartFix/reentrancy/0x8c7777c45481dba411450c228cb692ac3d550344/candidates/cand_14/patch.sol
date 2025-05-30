/*
 * @source: etherscan.io 
 * @author: -
 * @vulnerable_at_lines: 41
 */
 
pragma solidity ^0.4.19;

contract ETH_VAULT
{
    mapping (address => uint) public balances;
    
    Log TransferLog;
    
    uint public MinDeposit = 1 ether;
    
    function ETH_VAULT(address _log)
    public 
    {
        TransferLog = Log(_log);
    }
    
    function Deposit()
    public
    payable
    {
        if(msg.value > MinDeposit)
        {
            require(((balances[msg.sender] + msg.value) >= balances[msg.sender])); /* <FIX> Insert:BC */
            balances[msg.sender]+=msg.value;
            TransferLog.AddMessage(msg.sender,msg.value,"Deposit");
        }
    }
    
    function CashOut(uint _am)
    public
    payable
    {
        if((_am > balances[msg.sender])) /* <FIX> Replace: "(_am <= balances[msg.sender])" => "(_am > balances[msg.sender])" */
        {
            // <yes> <report> REENTRANCY
            balances[msg.sender] = (balances[msg.sender] - _am); /* <FIX> Move */
            if(msg.sender.call.value(_am)())
            {
                /* <FIX> Move: balances[msg.sender]-=_am; */
                TransferLog.AddMessage(msg.sender,_am,"CashOut");
            } else {revert (); } /* <FIX> add revert */
        }
    }
    
    function() public payable{}    
    
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
