pragma solidity ^0.4.23;

contract DrainMe {
    function callFirstTarget() public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

    }

    function callSecondTarget() public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

    }

    function winPrize() public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

    }

}
