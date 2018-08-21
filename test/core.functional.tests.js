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
	const integrator = accounts[0];
	const admin = accounts[1];
	const chief1 = accounts[2];
	const chief2 = accounts[3];
	const customer1 = accounts[4];
	const customer2 = accounts[5];
	const outsider = accounts[6];

	let robonomicaCore;
	let aac;
	let store;
	let informalProposal;
	let stdDaoToken;
	let daoBase;
	let roboAuto;
	let roboZeroStage;
	let roboFirstStage;
	let roboSecondStage;

	beforeEach(async () => {
		// token = await StdDaoToken.new('roboToken', 'ROBO', 18, true, true, 1000000000);
		// repToken = await StdDaoToken.new('repToken', 'REP', 18, true, true, 1000000000);
		// store = await DaoStorage.new([token.address, repToken.address]);
		// daoBase = await DaoBase.new(store.address);
		// roboAuto = await RobonomikaAuto.new(daoBase.address);
		// robonomika = await RobonomikaWithUnpackers.new(daoBase.address, token.address, repToken.address);
		// await token.transferOwnership(robonomika.address);
		// await repToken.transferOwnership(robonomika.address);
		// await store.transferOwnership(robonomika.address);
		roboZeroStage = await RobonomikaFactoryZeroStage.new()
		roboFirstStage = await RobonomikaFactoryFirstStage.new(roboZeroStage.address);
		roboSecondStage = await RobonomikaFactorySecondStage.new(roboZeroStage.address, roboFirstStage.address);
	});


	describe('finc1()', ()=> {
		it('should', async () => {
			// await 
		});

		it('should', async () => {
			// await 
		});
	});
});