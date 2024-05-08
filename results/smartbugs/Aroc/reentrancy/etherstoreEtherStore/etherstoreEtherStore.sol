pragma solidity ^0.4.0;

contract EtherStore {
    function withdrawFunds(uint256 _weiToWithdraw) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

  } else {
    require(false);


    }

}
