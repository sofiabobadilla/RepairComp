pragma solidity ^0.4.13;

library SafeMath {
    function sub(uint a, uint b) internal returns (uint) {
        assert(b <= a);
        return a - b;
    }
    function add(uint a, uint b) internal returns (uint) {
        uint c = a + b;
        assert(c >= a);
        return c;
    }
}

contract ERC20Basic {
    uint public totalSupply;
    address public owner; 
    address public animator; 
    function balanceOf(address who) constant returns (uint);
    function transfer(address to, uint value) public;
    event Transfer(address indexed from, address indexed to, uint value);
    function commitDividend(address who) internal; 
}

contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) constant returns (uint);
    function transferFrom(address from, address to, uint value) public;
    function approve(address spender, uint value) public;
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract BasicToken is ERC20Basic {
    using SafeMath for uint;
    mapping(address => uint) balances;

    modifier onlyPayloadSize(uint size) {
        assert(msg.data.length >= size + 4);
        _;
    }

    function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
        commitDividend(msg.sender);
        balances[msg.sender] = balances[msg.sender].sub(_value);
        if(_to == address(this)) {
            commitDividend(owner);
            balances[owner] = balances[owner].add(_value);
            Transfer(msg.sender, owner, _value);
        }
        else {
            commitDividend(_to);
            balances[_to] = balances[_to].add(_value);
            Transfer(msg.sender, _to, _value);
        }
    }

    function balanceOf(address _owner) public constant returns (uint balance) {
        return balances[_owner];
    }
}

contract StandardToken is BasicToken, ERC20 {
    mapping (address => mapping (address => uint)) allowed;

    function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
        var _allowance = allowed[_from][msg.sender];
        commitDividend(_from);
        commitDividend(_to);
        balances[_to] = balances[_to].add(_value);
        balances[_from] = balances[_from].sub(_value);
        allowed[_from][msg.sender] = _allowance.sub(_value);
        Transfer(_from, _to, _value);
    }

    function approve(address _spender, uint _value) public {
        assert(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
    }

    function allowance(address _owner, address _spender) public constant returns (uint remaining) {
        return allowed[_owner][_spender];
    }
}

contract SmartBillions is StandardToken {
    // Add your SmartBillions contract code here
}