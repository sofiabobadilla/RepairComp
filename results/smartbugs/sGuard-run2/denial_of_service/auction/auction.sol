contract sGuard{
  bool internal locked_;
  constructor() internal {
    locked_ = false;
  }
  modifier nonReentrant_() {
    require(!locked_);
    locked_ = true;
    _;
    locked_ = false;
  }
}
contract sGuard is sGuard {
  bool internal locked_;
  constructor() internal {
    locked_ = false;
  }
  modifier nonReentrant_() {
    require(!locked_);
    locked_ = true;
    _;
    locked_ = false;
  }
}
/*
 * @source: https://github.com/trailofbits/not-so-smart-contracts/blob/master/denial_of_service/auction.sol
 * @author: -
 * @vulnerable_at_lines: 23
 */


//Auction susceptible to DoS attack
contract DosAuction  is sGuard  is sGuard {
  address currentFrontrunner;
  uint currentBid;

  //Takes in bid, refunding the frontrunner if they are outbid
    function bid() nonReentrant_  nonReentrant_  payable {
    require(msg.value > currentBid);

    //If the refund fails, the entire transaction reverts.
    //Therefore a frontrunner who always fails will win
    if (currentFrontrunner != 0) {
      //E.g. if recipients fallback function is just revert()
      // <yes> <report> DENIAL_OF_SERVICE
      require(currentFrontrunner.send(currentBid));
    }

    currentFrontrunner = msg.sender;
    currentBid         = msg.value;
  }
}
