// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.19;
import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol";

contract NU10MSPTR {
    string  public name = "SPTRmockcoin";
    string  public symbol = "SPTR";
    string  public standard = "SPTR";
    uint8 public decimals=0;
    uint256 public totalSupply;
     uint256 public initialTimestamp;
    bool public timestampSet;
    uint256 public timePeriod;

    using SafeMath for uint256;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor (uint256 _initialSupply)  {
        balanceOf[msg.sender] = _initialSupply;
        totalSupply = _initialSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    
    modifier timestampNotSet() {
        require(timestampSet == false, "The time stamp has already been set.");
        _;
    }

     modifier timestampIsSet() {
        require(timestampSet == true, "Please set the time stamp first, then try again.");
        _;
    }


    function setTimestamp(uint256 _timePeriodInSeconds) public  timestampNotSet  {
        timestampSet = true;
        initialTimestamp = block.timestamp;
        timePeriod = initialTimestamp.add(_timePeriodInSeconds);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    function burn(uint256 _value) public timestampIsSet returns (bool success){
        require(balanceOf[msg.sender]>=_value);
if (block.timestamp >= timePeriod) {
        balanceOf[msg.sender]-=_value;
        totalSupply-=_value;

        return true;
}else {
            revert("Tokens are only available after correct time period has elapsed");
        }
    }

    function burnfrom(address _from, uint256 _value) public payable returns (bool success) {
        require(balanceOf[_from] >=_value);
        require(_value <= allowance[_from][msg.sender]);

        balanceOf[_from] -= _value;
        totalSupply -= _value;

        return true;

    }

}
