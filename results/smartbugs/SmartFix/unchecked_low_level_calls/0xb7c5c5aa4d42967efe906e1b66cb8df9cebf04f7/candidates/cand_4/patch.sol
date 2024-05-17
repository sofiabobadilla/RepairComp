/*
 * @source: etherscan.io 
 * @author: -
 * @vulnerable_at_lines: 25
 */

pragma solidity ^0.4.23;

/*
!!! THIS CONTRACT IS EXPLOITABLE AND FOR EDUCATIONAL PURPOSES ONLY !!!

This smart contract allows a user to (insecurely) store funds
in this smart contract and withdraw them at any later point in time
*/

contract keepMyEther {
    mapping(address => uint256) public balances;
    
    function () payable public {
        require(((balances[msg.sender] + msg.value) >= balances[msg.sender])); /* <FIX> Insert:BC */
        balances[msg.sender] += msg.value;
    }
    
    function withdraw() public {
        // <yes> <report> UNCHECKED_LL_CALLS
        uint256 tmp__1 = balances[msg.sender]; /* <FIX> Insert */
        balances[msg.sender] = 0; /* <FIX> Move */
        msg.sender.call.value(tmp__1)(); /* <FIX> Replace: "balances[msg.sender]" => "tmp__1" */
        /* <FIX> Move: balances[msg.sender] = 0; */
    }
}
