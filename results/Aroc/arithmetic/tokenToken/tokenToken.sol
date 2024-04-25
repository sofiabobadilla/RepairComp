pragma solidity ^0.4.18;

contract Token {
    function transfer(address _to, uint _value) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          require(balances[msg.sender]>=_value);


    }

}
