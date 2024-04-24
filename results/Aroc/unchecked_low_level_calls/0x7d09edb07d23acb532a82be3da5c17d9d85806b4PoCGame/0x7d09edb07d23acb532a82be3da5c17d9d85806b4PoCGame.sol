pragma solidity ^0.4.21;

contract PoCGame {
    function donateToWhale(uint256 amount) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( whale.call.value(amount)(bytes4(keccak256("donate()")))){
          assert(0==1);
        }else{
          revert();
        }

    }

    function loseWager(uint256 amount) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( whale.call.value(amount)(bytes4(keccak256("donate()")))){
          assert(0==1);
        }else{
          revert();
        }

    }

}
