pragma solidity 0.4.25;

contract ReturnValue {

function callchecked(address callee) public returns (bool) {
bool success;
bytes memory data;
(success, data) = callee.call();
require(success);
return success;
}

function callnotchecked(address callee) public {
callee.call();
}
}