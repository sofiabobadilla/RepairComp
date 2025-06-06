/*
 * @source: https://github.com/ConsenSys/evm-analyzer-benchmark-suite
 * @author: Suhabe Bugrara
 * @vulnerable_at_lines: 18
 */

pragma solidity ^0.4.19;

contract ReentrancyDAO {
    mapping (address => uint) credit;
    uint balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        if (oCredit > 0) {
            balance -= oCredit;
            // <yes> <report> REENTRANCY
            credit[msg.sender] = 0; /* <FIX> Move */
            bool callResult = msg.sender.call.value(oCredit)();
            require (callResult);
            /* <FIX> Move: credit[msg.sender] = 0; */
        }
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        require(((balance + msg.value) >= balance)); /* <FIX> Insert:BC */
        balance += msg.value;
    }
}
