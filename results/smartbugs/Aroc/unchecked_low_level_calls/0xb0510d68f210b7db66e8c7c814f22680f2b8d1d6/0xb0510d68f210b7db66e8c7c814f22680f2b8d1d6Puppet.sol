pragma solidity ^0.4.23;

contract Puppet {
    function fundPuppets() public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

    }

}
