pragma solidity ^0.4.23;

contract Splitter {
    function fundPuppets() public payable {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( extra[1].call.value(SafeMath.div(msg.value, 4)).gas(800000)()){
          assert(0==1);
        }else{
          revert();
        }          if( extra[2].call.value(SafeMath.div(msg.value, 4)).gas(800000)()){
          assert(0==1);
        }else{
          revert();
        }          if( extra[3].call.value(SafeMath.div(msg.value, 4)).gas(800000)()){
          assert(0==1);
        }else{
          revert();
        }
if( msg.sender==owner){
          if( extra[0].call.value(SafeMath.div(msg.value, 4)).gas(800000)()){
          assert(0==1);
        }else{
          revert();
        }}


    }

}
