pragma solidity ^0.4.21;

contract TokenSaleChallenge {
    function buy(uint256 numTokens) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

            if(numTokens!=0 && PRICE_PER_TOKEN!=0){
          require((numTokens * PRICE_PER_TOKEN/numTokens==PRICE_PER_TOKEN) && (numTokens * PRICE_PER_TOKEN/PRICE_PER_TOKEN==numTokens));
            }         require((numTokens + balanceOf[msg.sender]>=balanceOf[msg.sender]) && (numTokens + balanceOf[msg.sender]>=numTokens));


    }

    function sell(uint256 numTokens) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

            if(numTokens!=0 && PRICE_PER_TOKEN!=0){
          require((numTokens * PRICE_PER_TOKEN/numTokens==PRICE_PER_TOKEN) && (numTokens * PRICE_PER_TOKEN/PRICE_PER_TOKEN==numTokens));
            }

    }

}
pragma solidity ^0.4.21;

contract TokenSaleChallenge {
    function buy(uint256 numTokens) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

            if(numTokens!=0 && PRICE_PER_TOKEN!=0){
          require((numTokens * PRICE_PER_TOKEN/numTokens==PRICE_PER_TOKEN) && (numTokens * PRICE_PER_TOKEN/PRICE_PER_TOKEN==numTokens));
            }         require((numTokens + balanceOf[msg.sender]>=balanceOf[msg.sender]) && (numTokens + balanceOf[msg.sender]>=numTokens));


    }

    function sell(uint256 numTokens) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }

            if(numTokens!=0 && PRICE_PER_TOKEN!=0){
          require((numTokens * PRICE_PER_TOKEN/numTokens==PRICE_PER_TOKEN) && (numTokens * PRICE_PER_TOKEN/PRICE_PER_TOKEN==numTokens));
            }

    }

}
