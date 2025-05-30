contract SmartFix {
  bool public _locked = false;

  modifier _nonReentrant() {
    require(!_locked);
    _locked = true;
    _;
    _locked = false;
  }
}

/*
 * @source: https://github.com/trailofbits/not-so-smart-contracts/blob/master/reentrancy/Reentrancy.sol
 * @author: -
 * @vulnerable_at_lines: 24
 */

 pragma solidity ^0.4.15;

 contract Reentrance is SmartFix {
     mapping (address => uint) userBalance;

     function getBalance(address u) constant returns(uint){
         return userBalance[u];
     }

     function addToBalance() _nonReentrant /* <FIX> Add Modifier:NR */ payable{
         require(((userBalance[msg.sender] + msg.value) >= userBalance[msg.sender])); /* <FIX> Insert:BC */
         userBalance[msg.sender] += msg.value;
     }

     function withdrawBalance() _nonReentrant /* <FIX> Add Modifier:NR */{
         // send userBalance[msg.sender] ethers to msg.sender
         // if mgs.sender is a contract, it will call its fallback function
         // <yes> <report> REENTRANCY
         if( ! (msg.sender.call.value(userBalance[msg.sender])() ) ){
             throw;
         }
         userBalance[msg.sender] = 0;
     }
 }
