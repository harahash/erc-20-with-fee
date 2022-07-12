// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

library SafeMath {
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

contract MyToken {
    using SafeMath for uint256;

    address public manager;
    string public constant name = "MyToken";
    string public constant symbol = "TKN";
    uint8 public constant decimals = 18;

    uint256 public totalSupply;
    uint256 public totalSpending;

    mapping (address => uint256) balances;
    mapping (address => mapping(address => uint256)) allowed;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _from, address indexed _to, uint256 _value);

    constructor() {
        manager = msg.sender;
    }

    function mint(address to, uint256 value) public {
        balances[to] = balances[to].add(value);
        totalSupply = totalSupply.add(value);
    }

    function transfer(address _to, uint256 _value) public {
        totalSpending = _value + _value.mul(5).div(100);
        require(balances[msg.sender] >= totalSpending);
        // require(balances[msg.sender] >= _value);
        balances[msg.sender] = balances[msg.sender].sub(totalSpending);
        balances[_to] = balances[_to].add(_value);
        balances[manager] = balances[manager].add(_value.mul(5).div(100)); // 5% fee

        emit Transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public {
        totalSpending = _value + _value.mul(5).div(100);
        require(balances[_from] >= totalSpending &&
                allowed[_from][msg.sender] >= _value
                );
        balances[_from] = balances[_from].sub(totalSpending) ;
        balances[_to] = balances[_to].add(_value);
        balances[manager] = balances[manager].add(_value.mul(5).div(100)); // 5% fee
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

        emit Transfer(_from, _to, _value);
    }

    function approve(address _spender, uint256 _value) public {
        allowed[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
    }

    function balanceOf(address owner) public view returns(uint256) {
        return balances[owner];
    }

    function allowance(address _owner, address _spender) public view returns(uint256){
        return allowed[_owner][_spender];
    }
}