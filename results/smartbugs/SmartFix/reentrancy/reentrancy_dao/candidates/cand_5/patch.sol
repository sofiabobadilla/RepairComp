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
 * @source: https://github.com/ConsenSys/evm-analyzer-benchmark-suite
 * @author: Suhabe Bugrara
 * @vulnerable_at_lines: 18
 */

pragma solidity ^0.4.19;

contract ReentrancyDAO is SmartFix {
    mapping (address => uint) credit;
    uint balance;

    function withdrawAll() _nonReentrant /* <FIX> Add Modifier:NR */ public {
        uint oCredit = credit[msg.sender];
        if (oCredit > 0) {
            balance -= oCredit;
            // <yes> <report> REENTRANCY
            bool callResult = msg.sender.call.value(oCredit)();
            require (callResult);
            credit[msg.sender] = 0;
        }
    }

    function deposit() _nonReentrant /* <FIX> Add Modifier:NR */ public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}
