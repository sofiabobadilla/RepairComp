pragma solidity ^0.4.0;

contract Reentrancy_bonus {
    function getFirstWithdrawalBonus(address recipient) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
      if( !(claimedBonus[recipient])){
claimedBonus[recipient] = true;
  } else {
    require(false);
        }


    }

}
