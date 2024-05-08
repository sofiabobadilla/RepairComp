pragma solidity 0.4.25;

contract Overflow_Add {
    function add(uint256 deposit) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
         require((deposit + balance>=balance) && (deposit + balance>=deposit));


    }

}
