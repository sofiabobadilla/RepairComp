pragma solidity ^0.4.11;

contract ClockAuction {
    struct Panda {
        uint256[] genes;
    }

    struct Auction {
        address seller;
        uint128 startingPrice;
        uint128 endingPrice;
        uint64 duration;
        uint64 startedAt;
        uint64 isGen0;
    }

    function withdrawBalance() public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( bool res = nftAddress.send(this.balance)){
          assert(0==1);
        }else{
          revert();
        }

    }

}
