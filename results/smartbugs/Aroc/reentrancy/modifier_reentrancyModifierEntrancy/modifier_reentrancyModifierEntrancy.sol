pragma solidity ^0.4.24;

contract ModifierEntrancy {
    function airDrop() public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

    }

}
