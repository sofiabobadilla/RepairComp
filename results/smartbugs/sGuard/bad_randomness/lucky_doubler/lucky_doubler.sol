contract sGuard{
  function div_uint256(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }
  
  function sub_uint256(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }
  
  function mul_uint256(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }
  
  bool internal locked_;
  constructor() internal {
    locked_ = false;
  }
  modifier nonReentrant_() {
    require(!locked_);
    locked_ = true;
    _;
    locked_ = false;
  }
  
  function add_uint256(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}
/*
 * @article: https://blog.positive.com/predicting-random-numbers-in-ethereum-smart-contracts-e5358c6b8620
 * @source: https://etherscan.io/address/0xF767fCA8e65d03fE16D4e38810f5E5376c3372A8#code
 * @vulnerable_at_lines: 127,128,129,130,132
 * @author: -
 */

 //added pragma version

 contract LuckyDoubler  is sGuard {
//##########################################################
//#### LuckyDoubler: A doubler with random payout order ####
//#### Deposit 1 ETHER to participate                   ####
//##########################################################
//COPYRIGHT 2016 KATATSUKI ALL RIGHTS RESERVED
//No part of this source code may be reproduced, distributed,
//modified or transmitted in any form or by any means without
//the prior written permission of the creator.

    address private owner;

    //Stored variables
    uint private balance = 0;
    uint private fee = 5;
    uint private multiplier = 125;

    mapping (address => User) private users;
    Entry[] private entries;
    uint[] private unpaidEntries;

    //Set owner on contract creation
    function LuckyDoubler() {
        owner = msg.sender;
    }

    modifier onlyowner { if (msg.sender == owner) _; }

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

    //Fallback function
    function() {
        init();
    }

    function init() private{

        if (msg.value < 1 ether) {
             msg.sender.send(msg.value);
            return;
        }

        join();
    }

    function join() private {

        //Limit deposits to 1ETH
        uint dValue = 1 ether;

        if (msg.value > 1 ether) {

        	msg.sender.send(sub_uint256(msg.value, 1 ether));
        	dValue = 1 ether;
        }

        //Add new users to the users array
        if (users[msg.sender].id == address(0))
        {
            users[msg.sender].id = msg.sender;
            users[msg.sender].deposits = 0;
            users[msg.sender].payoutsReceived = 0;
        }

        //Add new entry to the entries array
        entries.push(Entry(msg.sender, dValue, (div_uint256(mul_uint256(dValue, (multiplier)), 100)), false));
        users[msg.sender].deposits++;
        unpaidEntries.push(sub_uint256(entries.length, 1));

        //Collect fees and update contract balance
        balance = add_uint256(balance, div_uint256((mul_uint256(dValue, (sub_uint256(100, fee)))), 100));

        uint index = unpaidEntries.length > 1 ? rand(unpaidEntries.length) : 0;
        Entry theEntry = entries[unpaidEntries[index]];

        //Pay pending entries if the new balance allows for it
        if (balance > theEntry.payout) {

            uint payout = theEntry.payout;

            theEntry.entryAddress.send(payout);
            theEntry.paid = true;
            users[theEntry.entryAddress].payoutsReceived++;

            balance = sub_uint256(balance, payout);

            if (index < sub_uint256(unpaidEntries.length, 1))
                unpaidEntries[index] = unpaidEntries[sub_uint256(unpaidEntries.length, 1)];

            (unpaidEntries.length = sub_uint256(unpaidEntries.length, 1));

        }

        //Collect money from fees and possible leftovers from errors (actual balance untouched)
        uint fees = sub_uint256(this.balance, balance);
        if (fees > 0)
        {
                owner.send(fees);
        }

    }

    //Generate random number between 0 & max
    uint256 constant private FACTOR =  1157920892373161954235709850086879078532699846656405640394575840079131296399;
    // <yes> <report> BAD_RANDOMNESS
    function rand(uint max) constant private returns (uint256 result){
        uint256 factor = div_uint256(FACTOR * 100, max);
        uint256 lastBlockNumber = sub_uint256(block.number, 1);
        uint256 hashVal = uint256(block.blockhash(lastBlockNumber));

        return uint256((div_uint256(uint256(hashVal), factor))) % max;
    }


    //Contract management
     function changeOwner(address newOwner) nonReentrant_  onlyowner {
        owner = newOwner;
    }

     function changeMultiplier(uint multi) nonReentrant_  onlyowner {
        if (multi < 110 || multi > 150) throw;

        multiplier = multi;
    }

     function changeFee(uint newFee) nonReentrant_  onlyowner {
        if (fee > 5)
            throw;
        fee = newFee;
    }


    //JSON functions
    function multiplierFactor() constant returns (uint factor, string info) {
        factor = multiplier;
        info = 'The current multiplier applied to all deposits. Min 110%, max 150%.';
    }

    function currentFee() constant returns (uint feePercentage, string info) {
        feePercentage = fee;
        info = 'The fee percentage applied to all deposits. It can change to speed payouts (max 5%).';
    }

    function totalEntries() constant returns (uint count, string info) {
        count = entries.length;
        info = 'The number of deposits.';
    }

    function userStats(address user) constant returns (uint deposits, uint payouts, string info)
    {
        if (users[user].id != address(0x0))
        {
            deposits = users[user].deposits;
            payouts = users[user].payoutsReceived;
            info = 'Users stats: total deposits, payouts received.';
        }
    }

    function entryDetails(uint index) constant returns (address user, uint payout, bool paid, string info)
    {
        if (index < entries.length) {
            user = entries[index].entryAddress;
            payout = entries[index].payout / 1 finney;
            paid = entries[index].paid;
            info = 'Entry info: user address, expected payout in Finneys, payout status.';
        }
    }


}
