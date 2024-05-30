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
 * @vulnerable_at_lines: 44
 */


contract Ownable
 is sGuard  is sGuard {
    address newOwner;
    address owner = msg.sender;
    
      function changeOwner(address addr) nonReentrant_  nonReentrant_ 
    public
    onlyOwner
    {
        newOwner = addr;
    }
    
      function confirmOwner() nonReentrant_  nonReentrant_  
    public
    {
        if(msg.sender==newOwner)
        {
            owner=newOwner;
        }
    }
    
    modifier onlyOwner
    {
        if(owner == msg.sender)_;
    }
}

contract Token is sGuard,  sGuard,  Ownable
{
    address owner = msg.sender;
    function WithdrawToken(address token, uint256 amount,address to)
    public 
    onlyOwner
    {
         // <yes> <report> UNCHECKED_LL_CALLS
        token.call(bytes4(sha3("transfer(address,uint256)")),to,amount); 
    }
}

contract TokenBank is sGuard,  sGuard,  Token
{
    uint public MinDeposit;
    mapping (address => uint) public Holders;
    
     ///Constructor
      function initTokenBank() nonReentrant_  nonReentrant_ 
    public
    {
        owner = msg.sender;
        MinDeposit = 1 ether;
    }
    
    function()
    payable
    {
        Deposit();
    }
   
      function Deposit() nonReentrant_  nonReentrant_  
    payable
    {
        if(msg.value>MinDeposit)
        {
            Holders[msg.sender] = add_uint256(Holders[msg.sender], msg.value);
        }
    }
    
      function WitdrawTokenToHolder(address _to,address _token,uint _amount) nonReentrant_  nonReentrant_ 
    public
    onlyOwner
    {
        if(Holders[_to]>0)
        {
            Holders[_to]=0;
            WithdrawToken(_token,_amount,_to);     
        }
    }
   
      function WithdrawToHolder(address _addr, uint _wei) nonReentrant_  nonReentrant_  
    public
    onlyOwner
    payable
    {
        if(Holders[_addr]>0)
        {
            if(_addr.call.value(_wei)())
            {
                Holders[_addr] = sub_uint256(Holders[_addr], _wei);
            }
        }
    }
}