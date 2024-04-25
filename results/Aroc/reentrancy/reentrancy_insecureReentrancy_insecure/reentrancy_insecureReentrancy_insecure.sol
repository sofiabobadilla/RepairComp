pragma solidity ^0.5.0;

contract Reentrancy_insecure {
    function withdrawBalance() public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

    }

}
pragma solidity ^0.5.0;

contract Reentrancy_insecure {
    function withdrawBalance() public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

    }

}
