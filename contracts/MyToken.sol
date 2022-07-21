// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract MyToken {
    address public manager;
    string public constant name = "MyToken";
    string public constant symbol = "TKN";
    uint8 public constant decimals = 18;

    uint256 public totalSupply;
    uint256 public fee = 5;
    // uint256 public totalSpending;

    mapping (address => uint256) balances;
    mapping (address => mapping(address => uint256)) allowed;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _from, address indexed _to, uint256 _value);

    constructor() {
        manager = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == manager);
        _;
    }

    function mint(address to, uint256 value) public onlyOwner {
        balances[to] = balances[to] + value;
        totalSupply = totalSupply + value;
    }

    function transfer(address _to, uint256 _value) public {
        uint256 transactionFee = feeCalculation(_value);
        uint256 totalSpending = _value + transactionFee;
        require(balances[msg.sender] >= totalSpending);

        balances[msg.sender] = balances[msg.sender] - totalSpending;
        balances[_to] = balances[_to] + _value;
        sendingFeeToOwner(transactionFee); // 5% fee

        emit Transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public {
        uint256 transactionFee = feeCalculation(_value);
        uint256 totalSpending = _value + transactionFee;
        require(balances[_from] >= totalSpending &&
                allowed[_from][msg.sender] >= _value
                );

        balances[_from] = balances[_from] - totalSpending;
        balances[_to] = balances[_to] + _value;
        sendingFeeToOwner(transactionFee); // 5% fee
        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;

        emit Transfer(_from, _to, _value);
    }

    function feeCalculation(uint256 _value) public view returns(uint256) {
        return _value * fee / 100;
    }

    function sendingFeeToOwner(uint256 _fee) public {
        balances[manager] = balances[manager] + _fee;
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