const CheckExceptions = require("./utils/checkexceptions");
const should = require("./utils/helpers");

const DaoStorage = artifacts.require("DaoStorage");
const GenericProposal = artifacts.require("GenericProposal");
const InformalProposal = artifacts.require("InformalProposal");
const StdDaoToken = artifacts.require("StdDaoToken");
const DaoBaseAuto = artifacts.require("DaoBaseAuto");
const DaoBase = artifacts.require("DaoBase");
const RobonomikaCore = artifacts.require("RobonomikaCore");
const Robonomika = artifacts.require("Robonomika");
const RobonomikaWithUnpackers = artifacts.require("RobonomikaWithUnpackers");
const RobonomikaAuto = artifacts.require("RobonomikaAuto");
const RobonomikaFactoryZeroStage = artifacts.require("RobonomikaFactoryZeroStage");
const RobonomikaFactoryFirstStage = artifacts.require("RobonomikaFactoryFirstStage");
const RobonomikaFactorySecondStage = artifacts.require("RobonomikaFactorySecondStage");

contract('RobonomikaCore functional', (accounts) => {
	const admin = accounts[0];
	const chief1 = accounts[1];
	const chief2 = accounts[2];
	const chief3 = accounts[3];
	const customer1 = accounts[4];
	const customer2 = accounts[5];
	const outsider = accounts[6];

	let robonomicaCore;
	let store;
	let roboToken;
	let repToken;
	let daoBase;
	let roboAuto;
	let roboZeroStage;
	let roboFirstStage;
	let roboSecondStage;
	let robonomikaAddr;
	let roboAutoAddr;
	let daoBaseAddr;
	let repTokenAddr;
	let roboTokenAddr;

	beforeEach(async () => {
		roboZeroStage = await RobonomikaFactoryZeroStage.new();
		roboTokenAddr = await roboZeroStage.getTokenAddress();		
		roboToken = StdDaoToken.at(roboTokenAddr);
		repTokenAddr = await roboZeroStage.getRepTokenAddress();
		repToken = StdDaoToken.at(repTokenAddr);

		roboFirstStage = await RobonomikaFactoryFirstStage.new(roboZeroStage.address);
		daoBaseAddr = await roboFirstStage.getDaoBaseAddress();
		daoBase = DaoBase.at(daoBaseAddr);
		
		roboSecondStage = await RobonomikaFactorySecondStage.new(roboZeroStage.address, roboFirstStage.address, [chief1, chief2]);
		roboAutoAddr = await roboSecondStage.roboAuto();
		roboAuto = RobonomikaAuto.at(roboAutoAddr);
		robonomikaAddr = await roboSecondStage.robonomika();
		robonomika = RobonomikaWithUnpackers.at(robonomikaAddr);
	});


	describe('func1()', ()=> {
		it('should add new chief', async () => {
			// await robonomika.IwantToBeChief({from:chief1});
			// await robonomika.approveCooker(chief1);
		});

		it('should', async () => {
			// await 
		});
	});
});