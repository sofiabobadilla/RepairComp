pragma solidity ^0.4.0;

contract TimeLock {
    function increaseLockTime(uint _secondsToIncrease) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
         require((_secondsToIncrease + lockTime[msg.sender]>=lockTime[msg.sender]) && (_secondsToIncrease + lockTime[msg.sender]>=_secondsToIncrease));


    }

}
