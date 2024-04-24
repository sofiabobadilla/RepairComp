pragma solidity ^0.4.18;

contract Reentrance {
    function withdraw(uint _amount) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

  } else {
    require(false);


    }

}
