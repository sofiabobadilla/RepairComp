contract sGuard{
  function div_uint256(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }
  
  function mul_uint256(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }
  
  function sub_uint64(uint64 a, uint64 b) internal pure returns (uint64) {
    assert(b <= a);
    return a - b;
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
  
  function sub_uint256(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }
  
  function add_uint64(uint64 a, uint64 b) internal pure returns (uint64) {
    uint64 c = a + b;
    assert(c >= a);
    return c;
  }
}
contract sGuard is sGuard {
  function sub_uint256(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return sub_uint256(a, b);
  }
  
  function sub_uint64(uint64 a, uint64 b) internal pure returns (uint64) {
    assert(b <= a);
    return sub_uint64(a, b);
  }
  
  function add_uint64(uint64 a, uint64 b) internal pure returns (uint64) {
    uint64 c = add_uint64(a, b);
    assert(c >= a);
    return c;
  }
  
  function mul_uint256(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = mul_uint256(a, b);
    assert(div_uint256(c, a) == b);
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
  
  function div_uint256(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = div_uint256(a, b);
    return c;
  }
}
/*
 * @source: etherscan.io 
 * @author: -
 * @vulnerable_at_lines: 162,175,180,192
 */


contract TownCrier  is sGuard  is sGuard {
    struct Request { // the data structure for each request
        address requester; // the address of the requester
        uint fee; // the amount of wei the requester pays for the request
        address callbackAddr; // the address of the contract to call for delivering response
        bytes4 callbackFID; // the specification of the callback function
        bytes32 paramsHash; // the hash of the request parameters
    }
   
    event Upgrade(address newAddr);
    event Reset(uint gas_price, uint min_fee, uint cancellation_fee); 
    event RequestInfo(uint64 id, uint8 requestType, address requester, uint fee, address callbackAddr, bytes32 paramsHash, uint timestamp, bytes32[] requestData); // log of requests, the Town Crier server watches this event and processes requests
    event DeliverInfo(uint64 requestId, uint fee, uint gasPrice, uint gasLeft, uint callbackGas, bytes32 paramsHash, uint64 error, bytes32 respData); // log of responses
    event Cancel(uint64 requestId, address canceller, address requester, uint fee, int flag); // log of cancellations

    address public constant SGX_ADDRESS = 0x18513702cCd928F2A3eb63d900aDf03c9cc81593;// address of the SGX account

    uint public GAS_PRICE = 5 * 10**10;
    uint public MIN_FEE = 30000 * GAS_PRICE; // minimum fee required for the requester to pay such that SGX could call deliver() to send a response
    uint public CANCELLATION_FEE = 25000 * GAS_PRICE; // charged when the requester cancels a request that is not responded

    uint public constant CANCELLED_FEE_FLAG = 1;
    uint public constant DELIVERED_FEE_FLAG = 0;
    int public constant FAIL_FLAG = -2 ** 250;
    int public constant SUCCESS_FLAG = 1;

    bool public killswitch;

    bool public externalCallFlag;

    uint64 public requestCnt;
    uint64 public unrespondedCnt;
    Request[2**64] public requests;

    int public newVersion = 0;

    // Contracts that receive Ether but do not define a fallback function throw
    // an exception, sending back the Ether (this was different before Solidity
    // v0.4.0). So if you want your contract to receive Ether, you have to
    // implement a fallback function.
    function () {}

    function TownCrier() public {
        // Start request IDs at 1 for two reasons:
        //   1. We can use 0 to denote an invalid request (ids are unsigned)
        //   2. Storage is more expensive when changing something from zero to non-zero,
        //      so this means the first request isn't randomly more expensive.
        requestCnt = 1;
        requests[0].requester = msg.sender;
        killswitch = false;
        unrespondedCnt = 0;
        externalCallFlag = false;
    }

      function upgrade(address newAddr) nonReentrant_  nonReentrant_  {
        if (msg.sender == requests[0].requester && unrespondedCnt == 0) {
            newVersion = -int(newAddr);
            killswitch = true;
            Upgrade(newAddr);
        }
    }

      function reset(uint price, uint minGas, uint cancellationGas) nonReentrant_  nonReentrant_  public {
        if (msg.sender == requests[0].requester && unrespondedCnt == 0) {
            GAS_PRICE = price;
            MIN_FEE = mul_uint256(price, minGas);
            CANCELLATION_FEE = mul_uint256(price, cancellationGas);
            Reset(GAS_PRICE, MIN_FEE, CANCELLATION_FEE);
        }
    }

      function suspend() nonReentrant_  nonReentrant_  public {
        if (msg.sender == requests[0].requester) {
            killswitch = true;
        }
    }

      function restart() nonReentrant_  nonReentrant_  public {
        if (msg.sender == requests[0].requester && newVersion == 0) {
            killswitch = false;
        }
    }

    function withdraw() public {
        if (msg.sender == requests[0].requester && unrespondedCnt == 0) {
            if (!requests[0].requester.call.value(this.balance)()) {
                throw;
            }
        }
    }

      function request(uint8 requestType, address callbackAddr, bytes4 callbackFID, uint timestamp, bytes32[] requestData) nonReentrant_  nonReentrant_  public payable returns (int) {
        if (externalCallFlag) {
            throw;
        }

        if (killswitch) {
            externalCallFlag = true;
            if (!msg.sender.call.value(msg.value)()) {
                throw;
            }
            externalCallFlag = false;
            return newVersion;
        }

        if (msg.value < MIN_FEE) {
            externalCallFlag = true;
            // If the amount of ether sent by the requester is too little or 
            // too much, refund the requester and discard the request.
            if (!msg.sender.call.value(msg.value)()) {
                throw;
            }
            externalCallFlag = false;
            return FAIL_FLAG;
        } else {
            // Record the request.
            uint64 requestId = requestCnt;
            (requestCnt = add_uint64(requestCnt, 1));
            (unrespondedCnt = add_uint64(unrespondedCnt, 1));

            bytes32 paramsHash = sha3(requestType, requestData);
            requests[requestId].requester = msg.sender;
            requests[requestId].fee = msg.value;
            requests[requestId].callbackAddr = callbackAddr;
            requests[requestId].callbackFID = callbackFID;
            requests[requestId].paramsHash = paramsHash;

            // Log the request for the Town Crier server to process.
            RequestInfo(requestId, requestType, msg.sender, msg.value, callbackAddr, paramsHash, timestamp, requestData);
            return requestId;
        }
    }

      function deliver(uint64 requestId, bytes32 paramsHash, uint64 error, bytes32 respData) nonReentrant_  nonReentrant_  public {
        if (msg.sender != SGX_ADDRESS ||
                requestId <= 0 ||
                requests[requestId].requester == 0 ||
                requests[requestId].fee == DELIVERED_FEE_FLAG) {
            // If the response is not delivered by the SGX account or the 
            // request has already been responded to, discard the response.
            return;
        }

        uint fee = requests[requestId].fee;
        if (requests[requestId].paramsHash != paramsHash) {
            // If the hash of request parameters in the response is not 
            // correct, discard the response for security concern.
            return;
        } else if (fee == CANCELLED_FEE_FLAG) {
            // If the request is cancelled by the requester, cancellation 
            // fee goes to the SGX account and set the request as having
            // been responded to.
            // <yes> <report> UNCHECKED_LL_CALLS
            SGX_ADDRESS.send(CANCELLATION_FEE);
            requests[requestId].fee = DELIVERED_FEE_FLAG;
            (unrespondedCnt = sub_uint64(unrespondedCnt, 1));
            return;
        }

        requests[requestId].fee = DELIVERED_FEE_FLAG;
        (unrespondedCnt = sub_uint64(unrespondedCnt, 1));

        if (error < 2) {
            // Either no error occurs, or the requester sent an invalid query.
            // Send the fee to the SGX account for its delivering.
            // <yes> <report> UNCHECKED_LL_CALLS
            SGX_ADDRESS.send(fee);         
        } else {
            // Error in TC, refund the requester.
            externalCallFlag = true;
            // <yes> <report> UNCHECKED_LL_CALLS
            requests[requestId].requester.call.gas(2300).value(fee)();
            externalCallFlag = false;
        }

        uint callbackGas = div_uint256((sub_uint256(fee, MIN_FEE)), tx.gasprice); // gas left for the callback function
        DeliverInfo(requestId, fee, tx.gasprice, msg.gas, callbackGas, paramsHash, error, respData); // log the response information
        if (callbackGas > sub_uint256(msg.gas, 5000)) {
            callbackGas = sub_uint256(msg.gas, 5000);
        }
        
        externalCallFlag = true;
        // <yes> <report> UNCHECKED_LL_CALLS
        requests[requestId].callbackAddr.call.gas(callbackGas)(requests[requestId].callbackFID, requestId, error, respData); // call the callback function in the application contract
        externalCallFlag = false;
    }

      function cancel(uint64 requestId) nonReentrant_  nonReentrant_  public returns (int) {
        if (externalCallFlag) {
            throw;
        }

        if (killswitch) {
            return 0;
        }

        uint fee = requests[requestId].fee;
        if (requests[requestId].requester == msg.sender && fee >= CANCELLATION_FEE) {
            // If the request was sent by this user and has money left on it,
            // then cancel it.
            requests[requestId].fee = CANCELLED_FEE_FLAG;
            externalCallFlag = true;
            if (!msg.sender.call.value(sub_uint256(fee, CANCELLATION_FEE))()) {
                throw;
            }
            externalCallFlag = false;
            Cancel(requestId, msg.sender, requests[requestId].requester, requests[requestId].fee, 1);
            return SUCCESS_FLAG;
        } else {
            Cancel(requestId, msg.sender, requests[requestId].requester, fee, -1);
            return FAIL_FLAG;
        }
    }
}