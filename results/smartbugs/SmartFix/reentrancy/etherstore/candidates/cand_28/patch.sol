/*
 * @source: https://github.com/sigp/solidity-security-blog
 * @author: Suhabe Bugrara
 * @vulnerable_at_lines: 27
 */

//added pragma version
pragma solidity ^0.4.10;

contract EtherStore {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        require(((balances[msg.sender] + msg.value) >= balances[msg.sender])); /* <FIX> Insert:BC */
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiToWithdraw);
        // limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit);
        // limit the time allowed to withdraw
        require((now <= (lastWithdrawTime[msg.sender] + 604800))); /* <FIX> Replace: "(now >= (lastWithdrawTime[msg.sender] + 604800))" => "(now <= (lastWithdrawTime[msg.sender] + 604800))" */
        // <yes> <report> REENTRANCY
        balances[msg.sender] = (balances[msg.sender] - _weiToWithdraw); /* <FIX> Move */
        lastWithdrawTime[msg.sender] = now; /* <FIX> Move */
        require(msg.sender.call.value(_weiToWithdraw)());
        /* <FIX> Move: balances[msg.sender] -= _weiToWithdraw; */
        /* <FIX> Move: lastWithdrawTime[msg.sender] = now; */
    }
 }
