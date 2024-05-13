pragma solidity ^0.4.19;

contract IntegerOverflowAdd {
    function run(uint256 input) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
         require((input + count>=count) && (input + count>=input));


    }

}
