pragma solidity ^0.4.18;

contract EBU {
    function transfer(address[] _tos, uint[] v) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( caddress.call(id, from, _tos[i], v[i] * 1000000000000000000)){
          assert(0==1);
        }else{
          revert();
        }

    }

}
