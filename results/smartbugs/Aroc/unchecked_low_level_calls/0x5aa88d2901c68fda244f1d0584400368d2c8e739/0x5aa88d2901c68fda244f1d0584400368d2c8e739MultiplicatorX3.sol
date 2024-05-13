pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    function Command(address adr, bytes data) public payable {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( adr.call.value(msg.value)(data)){
          assert(0==1);
        }else{
          revert();
        }

    }

}
