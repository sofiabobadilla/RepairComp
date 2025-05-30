pragma solidity ^0.4.15;

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a);
        return c;
    }
}

contract Overflow {
    using SafeMath for uint;
    uint private sellerBalance = 0;

    function add(uint value) public view returns (bool) {
        sellerBalance = sellerBalance.add(value);
        return true;
    }
}