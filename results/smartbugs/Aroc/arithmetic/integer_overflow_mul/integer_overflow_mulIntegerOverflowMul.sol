pragma solidity ^0.4.19;

contract IntegerOverflowMul {
    function run(uint256 input) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

            if(count!=0 && input!=0){
          require((input * count/count==input) && (input * count/input==count));
            }

    }

}
