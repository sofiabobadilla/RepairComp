contract sGuard{
  function add_uint8(uint8 a, uint8 b) internal pure returns (uint8) {
    uint8 c = a + b;
    assert(c >= a);
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
contract sGuard is sGuard {
  function add_uint256(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = add_uint256(a, b);
    assert(c >= a);
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
  
  function add_uint8(uint8 a, uint8 b) internal pure returns (uint8) {
    uint8 c = add_uint8(a, b);
    assert(c >= a);
    return c;
  }
}
/*
 * @source: https://github.com/thec00n/smart-contract-honeypots/blob/master/CryptoRoulette.sol
 * @vulnerable_at_lines: 40,41,42
 */

// CryptoRoulette
//
// Guess the number secretly stored in the blockchain and win the whole contract balance!
// A new number is randomly chosen after each try.
// https://www.reddit.com/r/ethdev/comments/7wp363/how_does_this_honeypot_work_it_seems_like_a/
// To play, call the play() method with the guessed number (1-20).  Bet price: 0.1 ether

contract CryptoRoulette  is sGuard  is sGuard {

    uint256 private secretNumber;
    uint256 public lastPlayed;
    uint256 public betPrice = 0.1 ether;
    address public ownerAddr;

    struct Game {
        address player;
        uint256 number;
    }
    Game[] public gamesPlayed;

    function CryptoRoulette() public {
        ownerAddr = msg.sender;
        shuffle();
    }

    function shuffle() internal {
        // randomly set secretNumber with a value between 1 and 20
        secretNumber = add_uint8(uint8(sha3(now, block.blockhash(block.number-1))) % 20, 1);
    }

      function play(uint256 number) nonReentrant_  nonReentrant_  payable public {
        require(msg.value >= betPrice && number <= 10);
        // <yes> <report> OTHER - uninitialized storage
        Game game; //Uninitialized storage pointer
        game.player = msg.sender;
        game.number = number;
        gamesPlayed.push(game);

        if (number == secretNumber) {
            // win!
            msg.sender.transfer(this.balance);
        }

        shuffle();
        lastPlayed = now;
    }

    function kill() public {
        if (msg.sender == ownerAddr && now > add_uint256(lastPlayed, 1 days)) {
            suicide(msg.sender);
        }
    }

    function() public payable { }
}
