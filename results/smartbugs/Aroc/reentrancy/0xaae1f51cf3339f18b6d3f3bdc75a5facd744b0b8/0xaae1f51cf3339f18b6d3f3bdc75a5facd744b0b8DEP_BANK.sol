pragma solidity ^0.4.19;

contract DEP_BANK {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    function Collect(uint _am) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

  } else {
    require(false);


    }

}
