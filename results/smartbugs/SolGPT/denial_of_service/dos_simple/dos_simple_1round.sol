pragma solidity ^0.4.25;

contract DosOneFunc {

    address[] listAddresses;

    function ifillArray() public returns (bool){
        if(listAddresses.length < 1500) {
            uint numAddressesToAdd = 350;
            if(listAddresses.length + numAddressesToAdd > 1500) {
                numAddressesToAdd = 1500 - listAddresses.length;
            }

            for(uint i = 0; i < numAddressesToAdd; i++) {
                listAddresses.push(msg.sender);
            }
            return true;
        } else {
            listAddresses = new address[](0);
            return false;
        }
    }
}