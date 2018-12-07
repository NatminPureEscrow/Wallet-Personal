pragma solidity ^0.4.22;

import "./Ownable.sol";

// This contact sets the list of allowed tokens 
// to be received by the personal wallet
contract GeneralContract is Ownable {
	using SafeMath for uint256;

	address contractOwner;
	address tokenAddress;
	uint256 tokenPrice;
	address systemWallet;

	mapping(address => bool) internal AllowedTokens;

    constructor (
    	address _tokenAddress,
		uint256 _tokenPrice,
		address _systemWallet) public {
		contractOwner = msg.sender;
		tokenAddress = _tokenAddress;
	 	tokenPrice = _tokenPrice;
		systemWallet = _systemWallet;
	} 
	
	// Sets the token address for the application general options
	function setTokenAddress(address _tokenAddress) public ownerOnly {
		tokenAddress = _tokenAddress;
	}

	// Returns the token address for the application general options
	function getTokenAddress() public view returns (address) {
		return tokenAddress;
	}

	// Sets the token price for the application general options
	function setTokenPrice(uint256 _tokenPrice) public ownerOnly {
		tokenPrice = _tokenPrice;
	}

	// Returns the token price for the application general options
	function getTokenPrice() public view returns (uint256) {
		return tokenPrice;
	}

	// Sets the system wallet address for the application general options
	function setSystemWallet(address _systemWallet) public ownerOnly {
		systemWallet = _systemWallet;
	}

	// Returns the system wallet address for the application general options
	function getSystemWallet() public view returns (address) {
		return systemWallet;
	}
}