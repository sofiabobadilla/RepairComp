pragma solidity ^0.4.19;

contract PrivateBank {
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    function PrivateBank(address _lib) {
        TransferLog = Log(_lib);
    }
    
    function Deposit() public payable {
        require(msg.value >= MinDeposit);
        
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }
    
    function CashOut(uint _am) {
        require(_am <= balances[msg.sender]);
        
        uint amountToWithdraw = _am;
        balances[msg.sender] -= amountToWithdraw;
        TransferLog.AddMessage(msg.sender, amountToWithdraw, "CashOut");
        
        require(msg.sender.call.value(amountToWithdraw)());
    }
    
    function() public payable {}
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }
    
    Message[] public History;
    
    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage;
        newMessage.Sender = _adr;
        newMessage.Time = now;
        newMessage.Val = _val;
        newMessage.Data = _data;
        History.push(newMessage);
    }
}