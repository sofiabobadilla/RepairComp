pragma solidity ^0.4.25;

contract DosNumber {

    uint constant MAX_ELEMENTS = 1500;
    uint numElements = 0;
    uint[] array;

    function insertNnumbers(uint value, uint numbers) public {
        require(numElements + numbers <= MAX_ELEMENTS, "Exceeds maximum elements limit");
        
        for(uint i=0; i<numbers; i++) {
            if(numElements == array.length) {
                array.length += 1;
            }
            array[numElements++] = value;
        }
    }

    function clear() public {
        require(numElements > MAX_ELEMENTS, "Number of elements is not greater than the limit");
        numElements = 0;
    }

    function clearDOS() public {
        require(numElements > MAX_ELEMENTS, "Number of elements is not greater than the limit");
        array = new uint[](0);
        numElements = 0;
    }

    function getLengthArray() public view returns(uint) {
        return numElements;
    }

    function getRealLengthArray() public view returns(uint) {
        return array.length;
    }
}