pragma solidity ^0.4.0;

contract Reentrancy_cross_function {
    function withdrawBalance() public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

    }

}
