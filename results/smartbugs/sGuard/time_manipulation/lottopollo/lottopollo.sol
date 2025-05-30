contract sGuard{
  function sub_uint256(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }
}
/*
 * @source: https://github.com/seresistvanandras/EthBench/blob/master/Benchmark/Simple/timestampdependent.sol
 * @author: -
 * @vulnerable_at_lines: 13,27
 */

contract lottopollo  is sGuard {
  address leader;
  uint    timestamp;
  function payOut(uint rand) internal {
    // <yes> <report> TIME MANIPULATION
    if ( rand> 0 && sub_uint256(now, rand) > 24 hours ) {
      msg.sender.send( msg.value );

      if ( this.balance > 0 ) {
        leader.send( this.balance );
      }
    }
    else if ( msg.value >= 1 ether ) {
      leader = msg.sender;
      timestamp = rand;
    }
  }
  function randomGen() constant returns (uint randomNumber) {
      // <yes> <report> TIME MANIPULATION
      return block.timestamp;   
    }
  function draw(uint seed){
    uint randomNumber=randomGen(); 
    payOut(randomNumber);
  }
}