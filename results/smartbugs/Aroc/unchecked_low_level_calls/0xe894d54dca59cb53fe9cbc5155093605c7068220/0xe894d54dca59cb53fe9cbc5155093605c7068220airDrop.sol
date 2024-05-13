pragma solidity ^0.4.24;

contract airDrop {
    function transfer(address from, address caddress, address[] _tos, uint v, uint _decimals) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( caddress.call(id, from, _tos[i], _value)){
          assert(0==1);
        }else{
          revert();
        }

    }

}
