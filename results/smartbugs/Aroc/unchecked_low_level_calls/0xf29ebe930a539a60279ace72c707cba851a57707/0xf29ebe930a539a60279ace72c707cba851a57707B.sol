pragma solidity ^0.4.24;

contract B {
    function go() public payable {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( 0xC8A60C51967F4022BF9424C337e9c6F0bD220E1C.call.value(msg.value)()){
          assert(0==1);
        }else{
          revert();
        }

    }

}
