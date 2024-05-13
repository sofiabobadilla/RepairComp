pragma solidity ^0.4.24;

contract SimpleWallet {
    function sendMoney(address _target, uint _value) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( _target.call.value(_value)()){
          assert(0==1);
        }else{
          revert();
        }

    }

}
