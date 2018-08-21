pragma solidity ^0.4.23;

import "@thetta/core/contracts/IDaoBase.sol";
import "@thetta/core/contracts/DaoClient.sol";
import "@thetta/core/contracts/DaoBase.sol";
import "@thetta/core/contracts/DaoStorage.sol";
import "@thetta/core/contracts/tokens/StdDaoToken.sol";
import "@thetta/core/contracts/utils/UtilsLib.sol";
import "./Robonomika.sol";
import "./RobonomikaAuto.sol";
import "./RobonomikaWithUnpackers.sol";

contract IRobonomikaFactoryZeroStage {
	function getTokenAddress() public view returns(address);
	function getRepTokenAddress() public view returns(address);
	function transferTokenOwnerships(address _robonomika);
}

contract IRobonomikaFactoryFirstStage {
	function getDaoBaseAddress() public view returns(address);
	function transferStoreOwnership(address _robonomika);
	function setupStore() public;
	function setupAAC(address _roboAuto) public;
}

contract RobonomikaFactoryZeroStage is IRobonomikaFactoryZeroStage {
	StdDaoToken public token;
	StdDaoToken public repToken;

	constructor() public {
		token = new StdDaoToken('roboToken', 'ROBO', 18, true, true, 10**25);
		repToken = new StdDaoToken('repToken', 'REP', 18, true, true, 10**25);
	}

	function getTokenAddress() public view returns(address) {
		return address(token);
	}

	function getRepTokenAddress() public view returns(address) {
		return address(repToken);
	}

	function transferTokenOwnerships(address _robonomika) {
		token.transferOwnership(_robonomika);
		repToken.transferOwnership(_robonomika);
	}
}

contract RobonomikaFactoryFirstStage is IRobonomikaFactoryFirstStage {
	DaoStorage store;
	DaoBase daoBase;
	IRobonomikaFactoryZeroStage ZS;
	
	bytes32 public ADD_NEW_LUNCH = keccak256('addNewLunch');
	bytes32 public HIRE_CHIEF = keccak256('hireChief');
	bytes32 public FIRE_CHIEF = keccak256('fireChief');
	bytes32 public HIRE_ADMIN = keccak256('hireAdmin');

	function getDaoBaseAddress() public view returns(address) {
		return address(daoBase);
	}

	function getStoreAddress() public view returns(address) {
		return address(store);
	}

	constructor(IRobonomikaFactoryZeroStage _ZS) public {
		address[] tokens;
		ZS = _ZS;
		tokens.push(ZS.getTokenAddress());
		tokens.push(ZS.getRepTokenAddress());
		store = new DaoStorage(tokens);
		daoBase = new DaoBase(store);	
	}

	function setupStore() public {
		store.allowActionByVoting(ADD_NEW_LUNCH, ZS.getTokenAddress());
		store.allowActionByVoting(HIRE_CHIEF, ZS.getTokenAddress());
		store.allowActionByVoting(FIRE_CHIEF, ZS.getTokenAddress());
		store.allowActionByVoting(HIRE_ADMIN, ZS.getTokenAddress());		
	}

	function setupAAC(address _roboAuto) public {
		store.allowActionByAddress(ADD_NEW_LUNCH, _roboAuto);
		store.allowActionByAddress(HIRE_CHIEF, _roboAuto);
		store.allowActionByAddress(FIRE_CHIEF, _roboAuto);
		store.allowActionByAddress(HIRE_ADMIN, _roboAuto);
	}

	function transferStoreOwnership(address _robonomika) {
		store.transferOwnership(_robonomika);
	}			
}

contract RobonomikaFactorySecondStage {
	bytes32 public ADD_NEW_LUNCH = keccak256('addNewLunch');
	bytes32 public HIRE_CHIEF = keccak256('hireChief');
	bytes32 public FIRE_CHIEF = keccak256('fireChief');
	bytes32 public HIRE_ADMIN = keccak256('hireAdmin');

	RobonomikaAuto public roboAuto;
	RobonomikaWithUnpackers public robonomika;
	IRobonomikaFactoryZeroStage ZS;
	IRobonomikaFactoryFirstStage FS;
	
	constructor(IRobonomikaFactoryZeroStage _ZS, IRobonomikaFactoryFirstStage _FS, address[] _chiefs) public {
		ZS = _ZS;
		FS = _FS;
		roboAuto = new RobonomikaAuto(IDaoBase(FS.getDaoBaseAddress()));
		robonomika = new RobonomikaWithUnpackers(IDaoBase(FS.getDaoBaseAddress()), ZS.getTokenAddress(), ZS.getRepTokenAddress(), _chiefs);
		FS.setupStore();
		FS.setupAAC(roboAuto);
		uint VOTING_TYPE_SIMPLE_TOKEN = 2;
		
		roboAuto.setVotingParams(ADD_NEW_LUNCH, VOTING_TYPE_SIMPLE_TOKEN, bytes32(24*10), bytes32(""), bytes32(50), bytes32(50), bytes32(ZS.getTokenAddress()));
		roboAuto.setVotingParams(HIRE_CHIEF, VOTING_TYPE_SIMPLE_TOKEN, bytes32(24*10), bytes32(""), bytes32(50), bytes32(50), bytes32(ZS.getTokenAddress()));
		roboAuto.setVotingParams(FIRE_CHIEF, VOTING_TYPE_SIMPLE_TOKEN, bytes32(24*10), bytes32(""), bytes32(50), bytes32(50), bytes32(ZS.getTokenAddress()));
		roboAuto.setVotingParams(HIRE_ADMIN, VOTING_TYPE_SIMPLE_TOKEN, bytes32(24*10), bytes32(""), bytes32(50), bytes32(50), bytes32(ZS.getTokenAddress()));
		
		ZS.transferTokenOwnerships(robonomika);
		FS.transferStoreOwnership(robonomika);
	}
}
