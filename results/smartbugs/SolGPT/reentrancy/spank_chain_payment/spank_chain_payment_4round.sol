pragma solidity ^0.4.23;

contract Token {
    uint256 public totalSupply;

    function balanceOf(address _owner) public constant returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

library ECTools {
    function recoverSigner(bytes32 _hashedMsg, string _sig) public pure returns (address) {
        require(_hashedMsg != 0x00);

        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, _hashedMsg));

        if (bytes(_sig).length != 132) {
            return 0x0;
        }
        bytes32 r;
        bytes32 s;
        uint8 v;
        bytes memory sig = hexstrToBytes(substring(_sig, 2, 132));
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
        if (v < 27) {
            v += 27;
        }
        if (v < 27 || v > 28) {
            return 0x0;
        }
        return ecrecover(prefixedHash, v, r, s);
    }

    function isSignedBy(bytes32 _hashedMsg, string _sig, address _addr) public pure returns (bool) {
        require(_addr != 0x0);

        return _addr == recoverSigner(_hashedMsg, _sig);
    }

    function hexstrToBytes(string _hexstr) public pure returns (bytes) {
        uint len = bytes(_hexstr).length;
        require(len % 2 == 0);

        bytes memory bstr = bytes(new string(len / 2));
        uint k = 0;
        string memory s;
        string memory r;
        for (uint i = 0; i < len; i += 2) {
            s = substring(_hexstr, i, i + 1);
            r = substring(_hexstr, i + 1, i + 2);
            uint p = parseInt16Char(s) * 16 + parseInt16Char(r);
            bstr[k++] = uintToBytes32(p)[31];
        }
        return bstr;
    }

    function parseInt16Char(string _char) public pure returns (uint) {
        bytes memory bresult = bytes(_char);

        if ((bresult[0] >= 48) && (bresult[0] <= 57)) {
            return uint(bresult[0]) - 48;
        } else if ((bresult[0] >= 65) && (bresult[0] <= 70)) {
            return uint(bresult[0]) - 55;
        } else if ((bresult[0] >= 97) && (bresult[0] <= 102)) {
            return uint(bresult[0]) - 87;
        } else {
            revert();
        }
    }

    function uintToBytes32(uint _uint) public pure returns (bytes b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), _uint) }
    }

    function toEthereumSignedMessage(string _msg) public pure returns (bytes32) {
        uint len = bytes(_msg).length;
        require(len > 0);
        bytes memory prefix = "\x19Ethereum Signed Message:\n";
        return keccak256(abi.encodePacked(prefix, uintToString(len), _msg));
    }

    function uintToString(uint _uint) public pure returns (string str) {
        uint len = 0;
        uint m = _uint + 0;
        while (m != 0) {
            len++;
            m /= 10;
        }
        bytes memory b = new bytes(len);
        uint i = len - 1;
        while (_uint != 0) {
            uint remainder = _uint % 10;
            _uint = _uint / 10;
            b[i--] = byte(48 + remainder);
        }
        str = string(b);
    }

    function substring(string _str, uint _startIndex, uint _endIndex) public pure returns (string) {
        bytes memory strBytes = bytes(_str);
        require(_startIndex <= _endIndex);
        require(_startIndex >= 0);
        require(_endIndex <= strBytes.length);

        bytes memory result = new bytes(_endIndex - _startIndex);
        for (uint i = _startIndex; i < _endIndex; i++) {
            result[i - _startIndex] = strBytes[i];
        }
        return string(result);
    }
}

contract StandardToken is Token {
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
}

contract HumanStandardToken is StandardToken {
    string public name;
    uint8 public decimals;
    string public symbol;
    string public version = 'H0.1';

    constructor(
        uint256 _initialAmount,
        string _tokenName,
        uint8 _decimalUnits,
        string _tokenSymbol
    ) public {
        balances[msg.sender] = _initialAmount;
        totalSupply = _initialAmount;
        name = _tokenName;
        decimals = _decimalUnits;
        symbol = _tokenSymbol;
    }

    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);

        require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData);
        return true;
    }
}

contract LedgerChannel {
    string public constant NAME = "Ledger Channel";
    string public constant VERSION = "0.0.1";

    uint256 public numChannels = 0;

    event DidLCOpen (
        bytes32 indexed channelId,
        address indexed partyA,
        address indexed partyI,
        uint256 ethBalanceA,
        address token,
        uint256 tokenBalanceA,
        uint256 LCopenTimeout
    );

    event DidLCJoin (
        bytes32 indexed channelId,
        uint256 ethBalanceI,
        uint256 tokenBalanceI
    );

    event DidLCDeposit (
        bytes32 indexed channelId,
        address indexed recipient,
        uint256 deposit,
        bool isToken
    );

    event DidLCUpdateState (
        bytes32 indexed channelId,
        uint256 sequence,
        uint256 numOpenVc,
        uint256 ethBalanceA,
        uint256 tokenBalanceA,
        uint256 ethBalanceI,
        uint256 tokenBalanceI,
        bytes32 vcRoot,
        uint256 updateLCtimeout
    );

    event DidLCClose (
        bytes32 indexed channelId,
        uint256 sequence,
        uint256 ethBalanceA,
        uint256 tokenBalanceA,
        uint256 ethBalanceI,
        uint256 tokenBalanceI
    );

    event DidVCInit (
        bytes32 indexed lcId,
        bytes32 indexed vcId,
        bytes proof,
        uint256 sequence,
        address partyA,
        address partyB,
        uint256 balanceA,
        uint256 balanceB
    );

    event DidVCSettle (
        bytes32 indexed lcId,
        bytes32 indexed vcId,
        uint256 updateSeq,
        uint256 updateBalA,
        uint256 updateBalB,
        address challenger,
        uint256 updateVCtimeout
    );

    event DidVCClose(
        bytes32 indexed lcId,
        bytes32 indexed vcId,
        uint256 balanceA,
        uint256 balanceB
    );

    struct Channel {
        address[2] partyAddresses;
        uint256[4] ethBalances;
        uint256[4] erc20Balances;
        uint256[2] initialDeposit;
        uint256 sequence;
        uint256 confirmTime;
        bytes32 VCrootHash;
        uint256 LCopenTimeout;
        uint256 updateLCtimeout;
        bool isOpen;
        bool isUpdateLCSettling;
        uint256 numOpenVC;
        HumanStandardToken token;
    }

    struct VirtualChannel {
        bool isClose;
        bool isInSettlementState;
        uint256 sequence;
        address challenger;
        uint256 updateVCtimeout;

        address partyA;
        address partyB;
        address partyI;
        uint256[2] ethBalances;
        uint256[2] erc20Balances;
        uint256[2] bond;
        HumanStandardToken token;
    }

    mapping(bytes32 => VirtualChannel) public virtualChannels;
    mapping(bytes32 => Channel) public Channels;

    function createChannel(
        bytes32 _lcID,
        address _partyI,
        uint256 _confirmTime,
        address _token,
        uint256[2] _balances
    )
    public
    payable
    {
        require(Channels[_lcID].partyAddresses[0] == address(0), "Channel has already been created.");
        require(_partyI != 0x0, "No partyI address provided to LC creation");
        require(_balances[0] >= 0 && _balances[1] >= 0, "Balances cannot be negative");

        Channels[_lcID].partyAddresses[0] = msg.sender;
        Channels[_lcID].partyAddresses[1] = _partyI;

        if (_balances[0] != 0) {
            require(msg.value == _balances[0], "Eth balance does not match sent value");
            Channels[_lcID].ethBalances[0] = msg.value;
        }
        if (_balances[1] != 0) {
            Channels[_lcID].token = HumanStandardToken(_token);
            require(Channels[_lcID].token.transferFrom(msg.sender, this, _balances[1]), "CreateChannel: token transfer failure");
            Channels[_lcID].erc20Balances[0] = _balances[1];
        }

        Channels[_lcID].sequence = 0;
        Channels[_lcID].confirmTime = _confirmTime;

        Channels[_lcID].LCopenTimeout = now + _confirmTime;
        Channels[_lcID].initialDeposit = _balances;

        emit DidLCOpen(_lcID, msg.sender, _partyI, _balances[0], _token, _balances[1], Channels[_lcID].LCopenTimeout);
    }

    function LCOpenTimeout(bytes32 _lcID) public {
        require(msg.sender == Channels[_lcID].partyAddresses[0] && Channels[_lcID].isOpen == false);
        require(now > Channels[_lcID].LCopenTimeout);

        if (Channels[_lcID].initialDeposit[0] != 0) {
            Channels[_lcID].partyAddresses[0].transfer(Channels[_lcID].ethBalances[0]);
        }
        if (Channels[_lcID].initialDeposit[1] != 0) {
            require(Channels[_lcID].token.transfer(Channels[_lcID].partyAddresses[0], Channels[_lcID].erc20Balances[0]), "CreateChannel: token transfer failure");
        }