pragma solidity ^0.4.22;

import "./NatminToken.sol";

// This contact sets the list of allowed tokens 
// to be received by the personal wallet
contract ReceivableTokens is Ownable {
	using SafeMath for uint256;

	address contractOwner;
	mapping(address => bool) internal AllowedTokens;

    constructor () public {
		contractOwner = msg.sender;
	} 

	// Adds a token to the allowed list
	function addAllowedToken (address _allowedToken) public ownerOnly {
		AllowedTokens[_allowedToken] = true;
	}

	// Checks if a token is allowed or not
	function getAllowedToken (address _allowedToken) public view returns (bool) {
		return AllowedTokens[_allowedToken];
	}
}