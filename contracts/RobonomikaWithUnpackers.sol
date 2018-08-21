pragma solidity ^0.4.23;

import "@thetta/core/contracts/IDaoBase.sol";
import "@thetta/core/contracts/DaoClient.sol";
import "@thetta/core/contracts/tokens/StdDaoToken.sol";
import "@thetta/core/contracts/utils/UtilsLib.sol";
import "./Robonomika.sol";

contract RobonomikaWithUnpackers is Robonomika {

	constructor(IDaoBase _dao, address _roboToken, address _repToken) public 
		Robonomika(_dao, _roboToken, _repToken) {}

	function addNewLunchGeneric(bytes32[] _params) public {
		string memory name = UtilsLib.bytes32ToString(_params[0]);
		uint price = uint(_params[1]);
		address cooker = address(_params[2]);
		addNewLunch(name, price, cooker);
	}

	function hireChiefGeneric(bytes32[] _params) public {
		address chief = address(_params[0]);
		hireChief(chief);
	}

	function fireChiefGeneric(bytes32[] _params) public {
		address chief = address(_params[0]);
		fireChief(chief);
	}

	function hireAdminGeneric(bytes32[] _params) public {
		address admin = address(_params[0]);
		hireAdmin(admin);
	}
}