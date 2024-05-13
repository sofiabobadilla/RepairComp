pragma solidity ^0.4.2;

contract SimpleDAO {
    function withdraw(uint amount) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
credit[msg.sender] -= amount;credit[msg.sender] -= amount;
  } else {
    require(false);


    }

}
