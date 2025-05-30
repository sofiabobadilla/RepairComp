pragma solidity ^0.4.10;

contract IntegerOverflowAdd {
    mapping (address => uint256) public balanceOf;

    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        
        // Check for integer overflow before adding the value
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        
        balanceOf[_to] += _value;
    }
}