pragma solidity ^0.4.23;

import "@thetta/core/contracts/DaoBase.sol";
import "@thetta/core/contracts/DaoStorage.sol";
import "@thetta/core/contracts/IDaoBase.sol";
import "@thetta/core/contracts/utils/GenericCaller.sol";
import "@thetta/core/contracts/tokens/StdDaoToken.sol";
import "@thetta/core/contracts/utils/UtilsLib.sol";

contract RobonomikaAuto is GenericCaller {
	bytes32 public ADD_NEW_LUNCH = keccak256('addNewLunch');
	bytes32 public HIRE_CHIEF = keccak256('hireChief');
	bytes32 public FIRE_CHIEF = keccak256('fireChief');
	bytes32 public HIRE_ADMIN = keccak256('hireAdmin');

	constructor(IDaoBase _dao)public
		GenericCaller(_dao) {}

	function addNewLunchAuto(string _name, uint _price, address _cooker) public returns(address proposalOut){
		bytes32[] memory params = new bytes32[](3);
		params[0] = UtilsLib.stringToBytes32(_name);
		params[1] = bytes32(_price);
		params[2] = bytes32(_cooker);
		return doAction(ADD_NEW_LUNCH, dao, msg.sender, "addNewLunchGeneric(bytes32[])", params);
	}

	function hireChiefAuto(address _cooker) public returns(address proposalOut){
		bytes32[] memory params = new bytes32[](1);
		params[0] = bytes32(_cooker);
		return doAction(HIRE_CHIEF, dao, msg.sender, "hireChiefGeneric(bytes32[])", params);
	}

	function fireChiefAuto(address _cooker) public returns(address proposalOut){
		bytes32[] memory params = new bytes32[](1);
		params[0] = bytes32(_cooker);
		return doAction(FIRE_CHIEF, dao, msg.sender, "fireChiefGeneric(bytes32[])", params);
	}

	function hireAdminAuto(address _admin) public returns(address proposalOut){
		bytes32[] memory params = new bytes32[](1);
		params[0] = bytes32(_admin);
		return doAction(HIRE_ADMIN, dao, msg.sender, "hireAdminGeneric(bytes32[])", params);
	}
}