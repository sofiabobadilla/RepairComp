pragma solidity ^0.4.11;

interface tokenRecipient {
    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
}

contract MigrationAgent {
    function migrateFrom(address _from, uint256 _value) public;
}

contract ERC20 {
    uint public totalSupply;
    
    function balanceOf(address who) public constant returns (uint);
    function allowance(address owner, address spender) public constant returns (uint);
    
    function transfer(address to, uint value) public returns (bool);
    function transferFrom(address from, address to, uint value) public returns (bool);
    function approve(address spender, uint value) public returns (bool);
    
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract SafeMath {
    function safeMul(uint a, uint b) internal returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function safeDiv(uint a, uint b) internal returns (uint) {
        assert(b > 0);
        uint c = a / b;
        assert(a == b * c + a % b);
        return c;
    }

    function safeSub(uint a, uint b) internal returns (uint) {
        assert(b <= a);
        return a - b;
    }

    function safeAdd(uint a, uint b) internal returns (uint) {
        uint c = a + b;
        assert(c >= a && c >= b);
        return c;
    }

    function max64(uint64 a, uint64 b) internal constant returns (uint64) {
        return a >= b ? a : b;
    }

    function min64(uint64 a, uint64 b) internal constant returns (uint64) {
        return a < b ? a : b;
    }

    function max256(uint256 a, uint256 b) internal constant returns (uint256) {
        return a >= b ? a : b;
    }

    function min256(uint256 a, uint256 b) internal constant returns (uint256) {
        return a < b ? a : b;
    }

    function assert(bool assertion) internal {
        require(assertion, "Assertion failed");
    }
}

contract StandardToken is ERC20, SafeMath {
    event Minted(address receiver, uint amount);

    mapping(address => uint) balances;
    mapping(address => uint) balancesRAW;
    mapping (address => mapping (address => uint)) allowed;

    function isToken() public constant returns (bool weAre) {
        return true;
    }

    function transfer(address _to, uint _value) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], _value);
        balances[_to] = safeAdd(balances[_to], _value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        uint _allowance = allowed[_from][msg.sender];

        balances[_to] = safeAdd(balances[_to], _value);
        balances[_from] = safeSub(balances[_from], _value);
        allowed[_from][msg.sender] = safeSub(_allowance, _value);
        Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public constant returns (uint balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint _value) public returns (bool success) {
        require(_value == 0 || allowed[msg.sender][_spender] == 0, "Allowance already set");
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public constant returns (uint remaining) {
        return allowed[_owner][_spender];
    }
}

contract daoPOLSKAtokens is StandardToken {
    string public name = "DAO POLSKA TOKEN version 1";
    string public symbol = "DPL";
    uint8 public constant decimals = 18;
    
    address public owner;
    address public migrationMaster;
    
    uint256 public otherchainstotalsupply = 1 ether;
    uint256 public supplylimit = 10000 ether;
    
    uint256 public totalMigrated;
    
    address public migrationAgent = 0x8585D5A25b1FA2A0E6c3BcfC098195bac9789BE2;
    
    event Migrate(address indexed _from, address indexed _to, uint256 _value);
    event Refund(address indexed _from, uint256 _value);
    
    struct sendTokenAway {
        StandardToken coinContract;
        uint amount;
        address recipient;
    }
    
    mapping(uint => sendTokenAway) transfers;
    uint public numTransfers = 0;
    
    event UpdatedTokenInformation(string newName, string newSymbol);
    
    event receivedEther(address indexed _from, uint256 _value);
    
    event Burn(address indexed from, uint256 value);
    
    bool public supplylimitset = false;
    bool public otherchainstotalset = false;
    
    function daoPOLSKAtokens() public {
        owner = msg.sender;
        migrationMaster = msg.sender;
    }
    
    // Rest of the contract functions...
}