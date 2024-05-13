pragma solidity ^0.4.0;

contract EtherBank {
    function withdrawBalance() public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

  } else {
    require(false);


    }

}
