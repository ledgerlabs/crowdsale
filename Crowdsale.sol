contract Standard_Token {
  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function Standard_Token(uint256 _initialAmount) {
        balances[msg.sender] = _initialAmount;
        totalSupply = _initialAmount;
    }

    function () {
        throw;
    }

    function transfer(address _to, uint256 _value) returns (bool success) {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            balances[_to] += _value;
            Transfer(_from, _to, _value);
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            return true;
        } else { return false; }
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    uint256 public totalSupply;
}

contract Crowdsale {
  event Contributed(address _sender, uint _value, uint _amount);
  uint public price;
  address public token;

  function Crowdsale (uint _price, uint _initialAmount) {
    price = _price;
    token = address(new Standard_Token(_initialAmount));
    Standard_Token(token).transfer(this, _initialAmount);
  }

  function () {
    if(msg.value > 0) {
      Standard_Token(token).transfer(msg.sender, msg.value * price);
      Contributed(msg.sender, msg.value, msg.value * price);
    }
  }
}
