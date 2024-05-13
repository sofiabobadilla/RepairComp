pragma solidity ^0.4.18;

contract Lotto {
    function sendToWinner() public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( winner.send(winAmount)){
          assert(0==1);
        }else{
          revert();
        }

    }

    function withdrawLeftOver() public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( msg.sender.send(this.balance)){
          assert(0==1);
        }else{
          revert();
        }

    }

}
