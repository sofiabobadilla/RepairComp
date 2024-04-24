pragma solidity ^0.4.19;

contract TokenBank {
    function WithdrawToHolder(address _addr, uint _wei) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

  } else {
    require(false);


    }

}
