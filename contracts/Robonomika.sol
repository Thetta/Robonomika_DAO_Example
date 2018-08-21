pragma solidity ^0.4.23;

import "@thetta/core/contracts/IDaoBase.sol";
import "@thetta/core/contracts/DaoClient.sol";
import "@thetta/core/contracts/tokens/StdDaoToken.sol";
import "@thetta/core/contracts/utils/UtilsLib.sol";
import "./RobonomikaCore.sol";

contract Robonomika is RobonomikaCore {
	bytes32 public ADD_NEW_LUNCH = keccak256('addNewLunch');
	bytes32 public HIRE_CHIEF = keccak256('hireChief');
	bytes32 public FIRE_CHIEF = keccak256('fireChief');
	bytes32 public HIRE_ADMIN = keccak256('hireAdmin');

	constructor(IDaoBase _dao, address _roboToken, address _repToken) public RobonomikaCore(_dao, _roboToken, _repToken) {
	}

	function addNewLunch(string _name, uint _price, address _cooker) public isCanDo(ADD_NEW_LUNCH){
		super.addNewLunch(_name, _price, _cooker);
	}

	function hireChief(address _cooker) public isApprovedByAdmin(_cooker)isCanDo(HIRE_CHIEF){
		super.hireChief(_cooker);
	}

	function fireChief(address _cooker) public isCanDo(FIRE_CHIEF){
		super.fireChief(_cooker);
	}

	function hireAdmin(address _admin) public isCanDo(HIRE_ADMIN) {
		super.hireAdmin(_admin);
	}
}