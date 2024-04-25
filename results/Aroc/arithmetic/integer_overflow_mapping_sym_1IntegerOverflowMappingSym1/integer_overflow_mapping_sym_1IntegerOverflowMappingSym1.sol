pragma solidity ^0.4.11;

contract IntegerOverflowMappingSym1 {
    function init(uint256 k, uint256 v) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          require(map[k]>=v);


    }

}
