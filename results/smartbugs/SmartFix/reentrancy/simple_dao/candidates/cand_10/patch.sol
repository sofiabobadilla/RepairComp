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
 * @source: http://blockchain.unica.it/projects/ethereum-survey/attacks.html#simpledao
 * @author: -
 * @vulnerable_at_lines: 19
 */

pragma solidity ^0.4.2;

contract SimpleDAO is SmartFix {
  mapping (address => uint) public credit;

  function donate(address to) _nonReentrant /* <FIX> Add Modifier:NR */ payable {
    require(((credit[to] + msg.value) >= credit[to])); /* <FIX> Insert:BC */
    credit[to] += msg.value;
  }

  function withdraw(uint amount) _nonReentrant /* <FIX> Add Modifier:NR */ {
    if (credit[msg.sender]>= amount) {
      // <yes> <report> REENTRANCY
      bool res = msg.sender.call.value(amount)();
      credit[msg.sender]-=amount;
    }
  }

  function queryCredit(address to) returns (uint){
    return credit[to];
  }
}
