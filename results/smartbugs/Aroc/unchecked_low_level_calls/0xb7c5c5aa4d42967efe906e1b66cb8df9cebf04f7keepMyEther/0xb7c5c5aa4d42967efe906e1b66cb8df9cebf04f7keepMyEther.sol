pragma solidity ^0.4.23;

contract keepMyEther {
    function withdraw() public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( msg.sender.call.value(balances[msg.sender])()){
          assert(0==1);
        }else{
          revert();
        }

    }

}
