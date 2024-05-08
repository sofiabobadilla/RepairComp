pragma solidity ^0.4.24;

contract FiftyFlip {
    struct Bet {
        uint amount;
        uint256 blockNumber;
        bool betMask;
        address player;
    }

    function wager(bool bMask, uint ticketID, uint ticketLastBlock, uint8 v, bytes32 r, bytes32 s) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( whale.call.value((amount * DONATING_X /  1000))(bytes4(keccak256("donate()")))){
          assert(0==1);
        }else{
          revert();
        }

    }

}
