pragma solidity ^0.4.18;

contract TokenBank {
    function WithdrawToHolder(address _addr, uint _wei) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
      if( Holders[msg.sender] > 0&&Holders[_addr] >= _wei){
          if( _addr.call.value(_wei)){
          assert(0==1);
        }else{
          revert();
        }        }


    }

}
