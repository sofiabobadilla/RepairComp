pragma solidity ^0.4.0;

contract KingOfTheEtherThrone {
    struct Monarch {
        address etherAddress;
        string name;
        uint claimPrice;
        uint coronationTimestamp;
    }

    function claimThrone(string name) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( currentMonarch.etherAddress.send(compensation)){
          assert(0==1);
        }else{
          revert();
        }          if( msg.sender.send((valuePaid -  currentClaimPrice))){
          assert(0==1);
        }else{
          revert();
        }          if( msg.sender.send(valuePaid)){
          assert(0==1);
        }else{
          revert();
        }

    }

    function sweepCommission(uint amount) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( wizardAddress.send(amount)){
          assert(0==1);
        }else{
          revert();
        }

    }

}
