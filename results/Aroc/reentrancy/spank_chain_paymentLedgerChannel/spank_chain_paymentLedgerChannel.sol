pragma solidity ^0.4.23;

contract LedgerChannel {
    struct Channel {
        address[] partyAddresses;
    }

    struct VirtualChannel {
        bool isClose;
        bool isInSettlementState;
        uint256 sequence;
        address challenger;
        uint256 updateVCtimeout;
        address partyA;
        address partyB;
        address partyI;
        uint256[] ethBalances;
    }

    function LCOpenTimeout(bytes32 _lcID) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

  } else {
    require(false);


    }

}
