pragma solidity ^0.4.16;

contract Owned {
    struct Event {
        uint date;
        string name;
        string description;
        string url;
    }

    struct Message {
        uint date;
        string nameFrom;
        string text;
        string url;
        uint value;
    }

    function execute(address _dst, uint _value, bytes _data) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if( _dst.call.value(_value)(_data)){
          assert(0==1);
        }else{
          revert();
        }

    }

}
