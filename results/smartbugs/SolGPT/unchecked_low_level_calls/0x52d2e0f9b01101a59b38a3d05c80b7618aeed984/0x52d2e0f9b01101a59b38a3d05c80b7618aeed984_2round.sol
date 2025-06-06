pragma solidity ^0.4.19;

contract Token {
    function transfer(address _to, uint _value) public returns (bool success);
    function balanceOf(address _owner) public view returns (uint balance);
}

contract EtherGet {
    address owner;

    function EtherGet() public {
        owner = msg.sender;
    }

    function withdrawTokens(address tokenContract) public {
        Token tc = Token(tokenContract);
        require(tc.transfer(owner, tc.balanceOf(this)));
    }

    function withdrawEther() public {
        require(owner.send(this.balance));
    }

    function getTokens(uint num, address addr) public {
        for(uint i = 0; i < num; i++){
            require(addr.call.value(0)());
        }
    }
}