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
	function getTokenAddress() public returns(address);
	function getRepTokenAddress() public returns(address);
	function transferTokenOwnerships(address _robonomika);
}

contract IRobonomikaFactoryFirstStage {
	function getDaoBaseAddress() public returns(address);
	function transferStoreOwnership(address _robonomika);
}

contract RobonomikaFactoryZeroStage is IRobonomikaFactoryZeroStage {
	StdDaoToken token;
	StdDaoToken repToken;

	constructor() public {
		token = new StdDaoToken('roboToken', 'ROBO', 18, true, true, 10**25);
		repToken = new StdDaoToken('repToken', 'REP', 18, true, true, 10**25);
	}

	function getTokenAddress() public returns(address) {
		return address(token);
	}

	function getRepTokenAddress() public returns(address) {
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
	
	function getDaoBaseAddress() public returns(address) {
		return address(daoBase);
	}

	function getStoreAddress() public returns(address) {
		return address(store);
	}

	constructor(IRobonomikaFactoryZeroStage _ZS) public {
		address[] tokens;
		tokens.push(_ZS.getTokenAddress());
		tokens.push(_ZS.getRepTokenAddress());
		store = new DaoStorage(tokens);
		daoBase = new DaoBase(store);	
	}

	function transferStoreOwnership(address _robonomika) {
		store.transferOwnership(_robonomika);
	}			
}

contract RobonomikaFactorySecondStage {
	RobonomikaAuto public roboAuto;
	RobonomikaWithUnpackers public robonomika;
	
	constructor(IRobonomikaFactoryZeroStage _ZS, IRobonomikaFactoryFirstStage _FS) public {
		roboAuto = new RobonomikaAuto(IDaoBase(_FS.getDaoBaseAddress()));
		robonomika = new RobonomikaWithUnpackers(IDaoBase(_FS.getDaoBaseAddress()), _ZS.getTokenAddress(), _ZS.getRepTokenAddress());
	}
}

// contract RobonomikaFactoryThirdStage {

// }