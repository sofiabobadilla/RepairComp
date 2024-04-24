pragma solidity ^0.4.9;

contract TownCrier {
    struct Request {
        address requester;
        uint fee;
        address callbackAddr;
        bytes4 callbackFID;
        bytes32 paramsHash;
    }

    function deliver(uint64 requestId, bytes32 paramsHash, uint64 error, bytes32 respData) public {
         if(flag[msg.sender] == false){
  flag[msg.sender] = true;
  }
          if(           if(           if(           if(           if(           if( requests[requestId].callbackAddr.call.gas(callbackGas)(requests[requestId].callbackFID, requestId, error, respData)){
          assert(0==1);
        }else{
          revert();
        }){
          assert(0==1);
        }else{
          revert();
        }){
          assert(0==1);
        }else{
          revert();
        }){
          assert(0==1);
        }else{
          revert();
        }){
          assert(0==1);
        }else{
          revert();
        }){
          assert(0==1);
        }else{
          revert();
        }          if(           if( requests[requestId].requester.call.gas(2300).value(fee)()){
          assert(0==1);
        }else{
          revert();
        }){
          assert(0==1);
        }else{
          revert();
        }          if( SGX_ADDRESS.send(CANCELLATION_FEE)){
          assert(0==1);
        }else{
          revert();
        }          if( SGX_ADDRESS.send(fee)){
          assert(0==1);
        }else{
          revert();
        }

    }

}
