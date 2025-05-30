pragma solidity ^0.4.25;

contract DosNumber {

    uint numElements = 0;
    uint[] array;

    function insertNnumbers(uint value, uint numbers) public {
        require(value != 0 && numbers > 0);
        
        for(uint i=0; i<numbers; i++) {
            if(numElements == array.length) {
                array.push(value);
            } else {
                array[numElements] = value;
            }
            numElements++;
        }
    }

    function clear() public {
        require(numElements > 0 && numElements <= 1500);
        numElements = 0;
    }

    function clearDOS() public {
        require(numElements > 0 && numElements <= 1500);
        delete array;
        numElements = 0;
    }

    function getLengthArray() public view returns(uint) {
        return numElements;
    }

    function getRealLengthArray() public view returns(uint) {
        return array.length;
    }
}