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

function addressToBytes32 (addr) {
	while (addr.length < 66) {
		addr = '0' + addr;
	}
	return '0x' + addr.replace('0x', '');
}

function UintToToBytes32 (n) {
	n = Number(n).toString(16);
	while (n.length < 64) {
		n = '0' + n;
	}
	return '0x' + n;
}


contract('RobonomikaCore functional', (accounts) => {
	const admin = accounts[0];
	const chief1 = accounts[1];
	const chief2 = accounts[2];
	const chief3 = accounts[3];
	const customer1 = accounts[4];
	const customer2 = accounts[5];
	const customer3 = accounts[6];
	const outsider = accounts[7];

	let token;
	let repToken;
	let store;
	let daoBase;
	let roboAuto;
	let robonomika;

	beforeEach(async () => {
		token = await StdDaoToken.new('roboToken', 'ROBO', 18, true, true, 1000000000);
		repToken = await StdDaoToken.new('repToken', 'REP', 18, true, true, 1000000000);
	
		await token.mintFor(admin, 5000);
		await token.mintFor(chief1, 1000);
		await token.mintFor(chief2, 1000);
		await token.mintFor(chief3, 1000);
		await token.mintFor(customer1, 100);
		await token.mintFor(customer2, 100);
		await token.mintFor(customer3, 100);

		await repToken.mintFor(admin, 5000);
		await repToken.mintFor(chief1, 1000);
		await repToken.mintFor(chief2, 1000);
		await repToken.mintFor(chief3, 1000);
		await repToken.mintFor(customer1, 100);
		await repToken.mintFor(customer2, 100);
		await repToken.mintFor(customer3, 100);	

		store = await DaoStorage.new([token.address, repToken.address]);
		daoBase = await DaoBase.new(store.address);
		roboAuto = await RobonomikaAuto.new(daoBase.address);
		robonomika = await RobonomikaWithUnpackers.new(daoBase.address, token.address, repToken.address, [chief1, chief2]);
	
		await store.allowActionByAddress(await daoBase.MANAGE_GROUPS(), admin);

		await token.transferOwnership(robonomika.address);
		await repToken.transferOwnership(robonomika.address);
		await store.transferOwnership(robonomika.address);

		await daoBase.allowActionByVoting(await robonomika.ADD_NEW_LUNCH(), token.address);
		await daoBase.allowActionByVoting(await robonomika.HIRE_CHIEF(), token.address);
		await daoBase.allowActionByVoting(await robonomika.FIRE_CHIEF(), token.address);
		await daoBase.allowActionByVoting(await robonomika.HIRE_ADMIN(), token.address);				

		await daoBase.allowActionByAddress(await robonomika.ADD_NEW_LUNCH(), roboAuto.address);
		await daoBase.allowActionByAddress(await robonomika.HIRE_CHIEF(), roboAuto.address);
		await daoBase.allowActionByAddress(await robonomika.FIRE_CHIEF(), roboAuto.address);
		await daoBase.allowActionByAddress(await robonomika.HIRE_ADMIN(), roboAuto.address);

		await daoBase.allowActionByAddress(await daoBase.ISSUE_TOKENS(), robonomika.address);
		await daoBase.allowActionByAddress(await daoBase.BURN_TOKENS(), robonomika.address);

		await daoBase.allowActionByShareholder(await daoBase.ADD_NEW_PROPOSAL(), token.address)
		await daoBase.allowActionByAddress(await daoBase.ADD_NEW_PROPOSAL(), roboAuto.address)

		var VOTING_TYPE_SIMPLE_TOKEN = 2;
		
		await roboAuto.setVotingParams(await robonomika.ADD_NEW_LUNCH(), VOTING_TYPE_SIMPLE_TOKEN, UintToToBytes32(24*10), UintToToBytes32(""), UintToToBytes32(50), UintToToBytes32(50), addressToBytes32(token.address));
		await roboAuto.setVotingParams(await robonomika.HIRE_CHIEF(), VOTING_TYPE_SIMPLE_TOKEN, UintToToBytes32(24*10), UintToToBytes32(""), UintToToBytes32(50), UintToToBytes32(50), addressToBytes32(token.address));
		await roboAuto.setVotingParams(await robonomika.FIRE_CHIEF(), VOTING_TYPE_SIMPLE_TOKEN, UintToToBytes32(24*10), UintToToBytes32(""), UintToToBytes32(50), UintToToBytes32(50), addressToBytes32(token.address));
		await roboAuto.setVotingParams(await robonomika.HIRE_ADMIN(), VOTING_TYPE_SIMPLE_TOKEN, UintToToBytes32(24*10), UintToToBytes32(""), UintToToBytes32(50), UintToToBytes32(50), addressToBytes32(token.address));
	});


	describe('func1()', ()=> {
		it('should add new chief', async () => {
			await robonomika.IwantToBeChief({from:chief3});
			await robonomika.approveCooker(chief3);
			await roboAuto.hireChiefAuto(admin, {from:admin});

		});

		it('should', async () => {
			// await 
		});
	});
});