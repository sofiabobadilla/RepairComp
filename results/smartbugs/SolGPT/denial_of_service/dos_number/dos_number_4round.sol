pragma solidity ^0.4.25;

contract DosNumber {

    uint numElements = 0;
    uint[] array;

    function insertNnumbers(uint value, uint numbers) public {
        require(numbers < 100); // Limit the maximum value of numbers to prevent DoS attack
        for(uint i=0; i<numbers; i++) {
            if(numElements == array.length) {
                array.length += 1;
            }
            array[numElements++] = value;
        }
    }

    function clear() public {
        require(numElements > 1500 && numElements < 10000); // Limit the range of numElements to prevent DoS attack
        numElements = 0;
    }

    function clearDOS() public {
        require(numElements > 1500 && numElements < 10000); // Limit the range of numElements to prevent DoS attack
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