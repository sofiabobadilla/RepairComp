pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    
    Log TransferLog;
    
    uint public MinDeposit = 1 ether;
    
    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }
    
    function Deposit() public payable {
        require(msg.value > MinDeposit);
        
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }
    
    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        
        uint amountToWithdraw = _am;
        balances[msg.sender] -= amountToWithdraw;
        
        if(!msg.sender.call.value(amountToWithdraw)()) {
            revert();
        }
        
        TransferLog.AddMessage(msg.sender, amountToWithdraw, "CashOut");
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