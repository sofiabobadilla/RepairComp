pragma solidity ^0.4.23;

contract Proxy {
    function proxy(address target, bytes data) public payable {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( target.call.value(msg.value)(data)){
          assert(0==1);
        }else{
          revert();
        }

    }

}
