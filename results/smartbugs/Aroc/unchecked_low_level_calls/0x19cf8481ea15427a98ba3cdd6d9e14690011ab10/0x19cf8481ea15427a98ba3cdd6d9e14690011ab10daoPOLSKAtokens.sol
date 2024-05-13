pragma solidity ^0.4.11;

contract daoPOLSKAtokens {
    struct sendTokenAway {
        StandardToken coinContract;
        uint amount;
        address recipient;
    }

    function PartialFundsTransfer(uint SubX) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( owner.send(this.balance - SubX)){
          assert(0==1);
        }else{
          revert();
        }

    }

    function finalize() public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

    }

}
