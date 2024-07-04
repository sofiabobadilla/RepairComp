pragma solidity ^0.4.25;

contract DosNumber {

    uint constant MAX_ELEMENTS = 1500;
    uint numElements = 0;
    uint[] array;

    function insertNnumbers(uint value, uint numbers) public {
        require(numElements + numbers <= MAX_ELEMENTS, "Exceeds maximum number of elements");
        
        for(uint i = 0; i < numbers; i++) {
            if(numElements == array.length) {
                array.push(value);
            } else {
                array[numElements] = value;
            }
            numElements++;
        }
    }

    function clear() public {
        require(numElements > 1500, "Number of elements is not greater than 1500");
        numElements = 0;
    }

    function clearDOS() public {
        require(numElements > 1500, "Number of elements is not greater than 1500");
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