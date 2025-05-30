contract sGuard{
  function add_uint256(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
  
  bool internal locked_;
  constructor() internal {
    locked_ = false;
  }
  modifier nonReentrant_() {
    require(!locked_);
    locked_ = true;
    _;
    locked_ = false;
  }
  
  function sub_uint256(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }
}
contract sGuard is sGuard {
  function sub_uint256(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return sub_uint256(a, b);
  }
  
  bool internal locked_;
  constructor() internal {
    locked_ = false;
  }
  modifier nonReentrant_() {
    require(!locked_);
    locked_ = true;
    _;
    locked_ = false;
  }
  
  function add_uint256(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = add_uint256(a, b);
    assert(c >= a);
    return c;
  }
}
/*
 * @source: etherscan.io 
 * @author: -
 * @vulnerable_at_lines: 29
 */


contract MY_BANK
 is sGuard  is sGuard {
      function Put(uint _unlockTime) nonReentrant_  nonReentrant_ 
    public
    payable
    {
        var acc = Acc[msg.sender];
        acc.balance = add_uint256(acc.balance, msg.value);
        acc.unlockTime = _unlockTime>now?_unlockTime:now;
        LogFile.AddMessage(msg.sender,msg.value,"Put");
    }

      function Collect(uint _am) nonReentrant_  nonReentrant_ 
    public
    payable
    {
        var acc = Acc[msg.sender];
        if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime)
        {
            // <yes> <report> REENTRANCY
            if(msg.sender.call.value(_am)())
            {
                acc.balance = sub_uint256(acc.balance, _am);
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

    struct Holder   
    {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;    

    function MY_BANK(address log) public{
        LogFile = Log(log);
    }
}


contract Log 
 is sGuard  is sGuard {
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