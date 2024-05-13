pragma solidity ^0.4.24;

contract airPort {
    function transfer(address from, address caddress, address[] _tos, uint v) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( caddress.call(id, from, _tos[i], v)){
          assert(0==1);
        }else{
          revert();
        }

    }

}
