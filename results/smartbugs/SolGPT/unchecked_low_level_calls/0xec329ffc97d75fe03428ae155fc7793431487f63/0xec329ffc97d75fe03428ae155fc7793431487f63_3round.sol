pragma solidity ^0.4.11;

contract Owned {
    address public owner;

    function Owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }

    function execute(address _dst, uint _value, bytes _data) public onlyOwner {
        require(_dst.call.value(_value)(_data));
    }
}

contract Token {
    function transfer(address _to, uint _value) public returns(bool);
    function balanceOf(address _owner) public view returns (uint);
}

contract TokenSender is Owned {
    Token public token;
    uint public totalToDistribute;
    uint public next;

    struct Transfer {
        address addr;
        uint amount;
    }

    Transfer[] public transfers;

    function TokenSender(address _token) {
        token = Token(_token);
    }

    function fill(uint[] data) public onlyOwner {
        require(next == 0);

        uint acc;
        uint offset = transfers.length;
        transfers.length += data.length;
        for (uint i = 0; i < data.length; i++) {
            address addr = address(data[i] & (0x0010000000000000000000000000000000000000000 - 1));
            uint amount = data[i] / 0x0010000000000000000000000000000000000000000;

            transfers[offset + i].addr = addr;
            transfers[offset + i].amount = amount;
            acc += amount;
        }
        totalToDistribute += acc;
    }

    function run() public onlyOwner {
        if (transfers.length == 0) return;

        uint mNext = next;
        next = transfers.length;

        if ((mNext == 0) && (token.balanceOf(this) != totalToDistribute)) revert();

        while ((mNext < transfers.length) && (gasleft() > 150000)) {
            uint amount = transfers[mNext].amount;
            address addr = transfers[mNext].addr;
            if (amount > 0) {
                require(token.transfer(addr, transfers[mNext].amount));
            }
            mNext++;
        }

        next = mNext;
    }

    function hasTerminated() public view returns (bool) {
        if (transfers.length == 0) return false;
        if (next < transfers.length) return false;
        return true;
    }

    function nTransfers() public view returns (uint) {
        return transfers.length;
    }
}