pragma solidity ^0.4.22;

//import "./Ownable.sol";
import "./GeneralContract.sol";

contract ERC223 {
	// ERC20 standard function
    function transfer(address _to, uint256 _value) public returns (bool success);

    // ERC223 Standard functions
    function symbol() public view returns (string);
}

contract PersonalWallet is Ownable {
	using SafeMath for uint256;

	address contractOwner;
	string walletPassword;
	address generalContractAddress;
   	GeneralContract generalContract;

	constructor (address _generalContractAddress, string _walletPassword) public {
		require(_generalContractAddress != address(0));
		contractOwner = msg.sender;
		generalContractAddress = _generalContractAddress;
		generalContract = GeneralContract(_generalContractAddress);
		walletPassword = _walletPassword;
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
		uint256 _value, 
		string _password) public ownerOnly returns (bool) {
		    
		require(keccak256(walletPassword) == keccak256(_password));

		address _tokenAddress = generalContract.getTokenAddress();
		ERC223 _tokenContract = ERC223(_tokenAddress);
		_tokenContract.transfer(_to,_value);

		return true;
	}

	function setGeneralContract(address _newGeneralContractAddress) public ownerOnly {
		generalContractAddress = _newGeneralContractAddress;
		generalContract = GeneralContract(_newGeneralContractAddress);
	}

	function getGeneralContract() public ownerOnly returns (address) {
		return generalContractAddress;
	}

	// Destroying the wallet and returns the contents to the owner
	function destroyWallet(address _owner) public ownerOnly {
		selfdestruct(_owner);
	}

}