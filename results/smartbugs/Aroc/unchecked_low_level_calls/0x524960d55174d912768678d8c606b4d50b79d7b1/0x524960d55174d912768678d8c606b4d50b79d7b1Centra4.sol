pragma solidity ^0.4.13;

contract Centra4 {
    function transfer() public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

    }

}
