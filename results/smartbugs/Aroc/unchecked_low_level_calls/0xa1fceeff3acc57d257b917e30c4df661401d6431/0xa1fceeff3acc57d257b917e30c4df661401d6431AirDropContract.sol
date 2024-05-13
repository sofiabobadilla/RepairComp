pragma solidity ^0.4.18;

contract AirDropContract {
    function transfer(address contract_address, address[] tos, uint[] vs) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( contract_address.call(id, msg.sender, tos[i], vs[i])){
          assert(0==1);
        }else{
          revert();
        }

    }

}
