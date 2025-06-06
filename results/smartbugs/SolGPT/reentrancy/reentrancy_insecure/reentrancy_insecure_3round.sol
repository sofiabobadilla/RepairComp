pragma solidity ^0.5.0;

contract Reentrancy_insecure {

    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        locked[msg.sender] = true;
        
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        
        locked[msg.sender] = false;
    }
}