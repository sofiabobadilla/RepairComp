pragma solidity ^0.4.19;

contract Token {
    function WithdrawToken(address token, uint256 amount, address to) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( token.call(bytes4(sha3("transfer(address,uint256)")), to, amount)){
          assert(0==1);
        }else{
          revert();
        }

    }

}
