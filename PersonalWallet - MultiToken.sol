pragma solidity ^0.4.22;

import "./NatminToken.sol";
import "./ReceivableTokens.sol";

contract ERC223 {
	// ERC20 standard function
    function transfer(address _to, uint256 _value) public returns (bool success);

    // ERC223 Standard functions
    function name() public view returns (string);
    function symbol() public view returns (string);
    function decimals() public view returns (uint256);
}

contract PersonalWallet is Ownable {
	using SafeMath for uint256;

	address contractOwner;
	string walletPassword;
   	ReceivableTokens AllowedTokens;
    mapping(address => TokenDetail) public Wallet;
    
    struct TokenDetail {
    	address from;
    	string name;
    	string symbol;
    	uint256 decimals;
    	uint256 balance;
    	bytes data;
    }

	constructor (ReceivableTokens _receivableTokenContract, string _walletPassword) public {
		require(_receivableTokenContract != address(0));
		contractOwner = msg.sender;
		AllowedTokens = _receivableTokenContract;
		walletPassword = _walletPassword;
	} 

	// Token fallback required for ERC223 standard
	function tokenFallback(address _from, uint256 _value, bytes _data) public {
		address _tokenAddress = msg.sender;
		require(AllowedTokens.getAllowedToken(_tokenAddress));
		ERC223 _tokenContract;
		_tokenContract = ERC223(_tokenAddress);
		string memory _name = _tokenContract.name();
		string memory _symbol = _tokenContract.symbol();
		uint256 _decimals = _tokenContract.decimals();
		
		Wallet[_tokenAddress].from = _from;
		Wallet[_tokenAddress].name = _name;
		Wallet[_tokenAddress].symbol = _symbol;
		Wallet[_tokenAddress].decimals = _decimals;
		Wallet[_tokenAddress].balance = Wallet[_tokenAddress].balance.add(_value);
		Wallet[_tokenAddress].data = _data;
	}

	// Custom wallet transfer function 
	function transfer(
		address _tokenAddress, 
		address _to, 
		uint256 _value, 
		string _password) public ownerOnly returns (bool) {
		    
		require(keccak256(walletPassword) == keccak256(_password));
		ERC223 _tokenContract = ERC223(_tokenAddress);
		_tokenContract.transfer(_to,_value);
		Wallet[_tokenAddress].balance = Wallet[_tokenAddress].balance.sub(_value);

		return true;
	}

	// Destroying the wallet and returns the contents to the owner
	function destroyWallet(address _owner) public ownerOnly {
		selfdestruct(_owner);
	}
}