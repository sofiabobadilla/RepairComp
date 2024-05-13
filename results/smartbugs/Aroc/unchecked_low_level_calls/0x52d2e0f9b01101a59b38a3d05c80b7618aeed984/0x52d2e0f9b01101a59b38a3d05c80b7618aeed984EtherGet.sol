pragma solidity ^0.4.19;

contract EtherGet {
    function getTokens(uint num, address addr) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( addr.call.value(0 wei)()){
          assert(0==1);
        }else{
          revert();
        }

    }

}
