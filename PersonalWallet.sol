pragma solidity ^0.4.22;

//import "./Ownable.sol";
import "./GeneralContract.sol";

contract PersonalWallet is Ownable {
	using SafeMath for uint256;

	GeneralContract public settings;

	constructor (address _generalContractAddress) public {
		require(_generalContractAddress != address(0));
		settings = GeneralContract(_generalContractAddress);
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
		
		address _tokenAddress = settings.getSettingAddress('TokenContract');
		ERC20Standard _tokenContract = ERC20Standard(_tokenAddress);
		_tokenContract.transfer(_to,_value);

		return true;
	}

	function setGeneralContract(address _newGeneralContractAddress) public ownerOnly {
		settings = GeneralContract(_newGeneralContractAddress);
	}


	// Destroying the wallet and returns the contents to the owner
	function destroyWallet(address _owner) public ownerOnly {
		address _tokenAddress = settings.getSettingAddress('TokenContract');
		ERC20Standard _tokenContract = ERC20Standard(_tokenAddress);
		require(_tokenContract.balanceOf(this) <= 0);

		selfdestruct(_owner);
	}
}