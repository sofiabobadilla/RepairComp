pragma solidity ^0.4.24;

contract LuckyDoubler {
    address private owner;
    uint private balance = 0;
    uint private fee = 5;
    uint private multiplier = 125;

    mapping (address => User) private users;
    Entry[] private entries;
    uint[] private unpaidEntries;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyowner {
        require(msg.sender == owner);
        _;
    }

    struct User {
        address id;
        uint deposits;
        uint payoutsReceived;
    }

    struct Entry {
        address entryAddress;
        uint deposit;
        uint payout;
        bool paid;
    }

    function() public {
        init();
    }

    function init() private {
        if (msg.value < 1 ether) {
            msg.sender.transfer(msg.value);
            return;
        }
        join();
    }

    function join() private {
        uint dValue = 1 ether;

        if (msg.value > 1 ether) {
            msg.sender.transfer(msg.value - 1 ether);
            dValue = 1 ether;
        }

        if (users[msg.sender].id == address(0)) {
            users[msg.sender].id = msg.sender;
            users[msg.sender].deposits = 0;
            users[msg.sender].payoutsReceived = 0;
        }

        entries.push(Entry(msg.sender, dValue, (dValue * multiplier) / 100, false));
        users[msg.sender].deposits++;
        unpaidEntries.push(entries.length - 1);

        balance += (dValue * (100 - fee)) / 100;

        uint index = unpaidEntries.length > 1 ? rand(unpaidEntries.length) : 0;
        Entry storage theEntry = entries[unpaidEntries[index]];

        if (balance > theEntry.payout) {
            uint payout = theEntry.payout;
            require(theEntry.entryAddress.send(payout));
            theEntry.paid = true;
            users[theEntry.entryAddress].payoutsReceived++;

            balance -= payout;

            if (index < unpaidEntries.length - 1) {
                unpaidEntries[index] = unpaidEntries[unpaidEntries.length - 1];
            }
            unpaidEntries.length--;
        }

        uint fees = address(this).balance - balance;
        if (fees > 0) {
            owner.transfer(fees);
        }
    }

    uint256 constant private FACTOR = 1157920892373161954235709850086879078532699846656405640394575840079131296399;

    function rand(uint max) private view returns (uint256 result) {
        uint256 factor = FACTOR * 100 / max;
        uint256 lastBlockNumber = block.number - 1;
        uint256 hashVal = uint256(block.blockhash(lastBlockNumber));
        return uint256((uint256(hashVal) / factor)) % max;
    }

    function changeOwner(address newOwner) public onlyowner {
        owner = newOwner;
    }

    function changeMultiplier(uint multi) public onlyowner {
        require(multi >= 110 && multi <= 150);
        multiplier = multi;
    }

    function changeFee(uint newFee) public onlyowner {
        require(newFee <= 5);
        fee = newFee;
    }

    function multiplierFactor() public view returns (uint factor, string memory info) {
        factor = multiplier;
        info = "The current multiplier applied to all deposits. Min 110%, max 150%.";
    }

    function currentFee() public view returns (uint feePercentage, string memory info) {
        feePercentage = fee;
        info = "The fee percentage applied to all deposits. It can change to speed payouts (max 5%).";
    }

    function totalEntries() public view returns (uint count, string memory info) {
        count = entries.length;
        info = "The number of deposits.";
    }

    function userStats(address user) public view returns (uint deposits, uint payouts, string memory info) {
        if (users[user].id != address(0)) {
            deposits = users[user].deposits;
            payouts = users[user].payoutsReceived;
            info = "Users stats: total deposits, payouts received.";
        }
    }

    function entryDetails(uint index) public view returns (address user, uint payout, bool paid, string memory info) {
        if (index < entries.length) {
            user = entries[index].entryAddress;
            payout = entries[index].payout / 1 finney;
            paid = entries[index].paid;
            info = "Entry info: user address, expected payout in Finneys, payout status.";
        }
    }
}