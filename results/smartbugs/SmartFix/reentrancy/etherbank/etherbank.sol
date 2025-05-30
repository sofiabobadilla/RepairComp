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
 * @source: https://github.com/seresistvanandras/EthBench/blob/master/Benchmark/Simple/reentrant.sol
 * @author: -
 * @vulnerable_at_lines: 21
 */

pragma solidity ^0.4.0;
contract EtherBank is SmartFix {
    mapping (address => uint) userBalances;
    function getBalance(address user) constant returns(uint) {  
		return userBalances[user];
	}

	function addToBalance() _nonReentrant /* <FIX> Add Modifier:NR */ {  
		require(((userBalances[msg.sender] + msg.value) >= userBalances[msg.sender])); /* <FIX> Insert:BC */
		userBalances[msg.sender] += msg.value;
	}

	function withdrawBalance() _nonReentrant /* <FIX> Add Modifier:NR */ {  
		uint amountToWithdraw = userBalances[msg.sender];
        // <yes> <report> REENTRANCY
		if (!(msg.sender.call.value(amountToWithdraw)())) { throw; }
		userBalances[msg.sender] = 0;
	}    
}
