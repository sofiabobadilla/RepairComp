pragma solidity ^0.4.23;

contract IntegerOverflowMultiTxMultiFuncFeasible {
    function run(uint256 input) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          require(count>=input);


    }

}
