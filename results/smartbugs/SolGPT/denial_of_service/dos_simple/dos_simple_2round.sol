pragma solidity ^0.4.25;

contract DosOneFunc {

    address[] listAddresses;

    function ifillArray() public returns (bool){
        if(listAddresses.length < 1500) {
            for(uint i=0; i<350; i++) {
                if(listAddresses.length < 1500) {
                    listAddresses.push(msg.sender);
                } else {
                    break;
                }
            }
            return true;
        } else {
            listAddresses = new address[](0);
            return false;
        }
    }
}