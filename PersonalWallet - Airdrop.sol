pragma solidity ^0.4.22;

//import "./Ownable.sol";
import "./GeneralContract.sol";

contract PersonalWallet is Ownable {
	using SafeMath for uint256;

	address contractOwner;
   	ERC20Standard token;

	constructor (address _tokenAddress) public {
		require(_tokenAddress != address(0));
		contractOwner = msg.sender;
        token = ERC20Standard(_tokenAddress);
	} 

	// Token fallback required for ERC223 standard
	function tokenFallback(address _from, uint256 _value, bytes _data) public {
		_from;
		_value;
		_data;
	}

	// Custom wallet transfer function 
	function transfer(
		address _to, 
		uint256 _value) public ownerOnly returns (bool) {
        require(_to != address(0));
        require(_value > 0);
        
		token.transfer(_to,_value);

		return true;
	}

	// Destroying the wallet and returns the contents to the owner
	function destroyWallet(address _owner) public ownerOnly {
	    transfer(_owner,token.balanceOf(this));
		selfdestruct(_owner);
	}

}