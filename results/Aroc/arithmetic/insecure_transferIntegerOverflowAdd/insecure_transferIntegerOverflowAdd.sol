pragma solidity ^0.4.0;

contract IntegerOverflowAdd {
    function transfer(address _to, uint256 _value) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
      if( balanceOf[msg.sender]>=_value){
         require((_value + balanceOf[_to]>=balanceOf[_to]) && (_value + balanceOf[_to]>=_value));
        }


    }

}
