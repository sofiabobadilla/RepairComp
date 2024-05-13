pragma solidity ^0.4.15;

contract Overflow {
    function add(uint value) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
         require((value + sellerBalance>=sellerBalance) && (value + sellerBalance>=value));


    }

}
