var UtilsLib = artifacts.require("./UtilsLib");
// var DaoBaseWithUnpackers = artifacts.require("./DaoBaseWithUnpackers");
var GenericCaller = artifacts.require("./GenericCaller");
var GenericCallerLib = artifacts.require("./GenericCallerLib");
var Voting = artifacts.require("./Voting");
var VotingLib = artifacts.require("./VotingLib");
var DaoBaseAuto = artifacts.require("./DaoBaseAuto");
var StdDaoToken = artifacts.require("./StdDaoToken");
var DaoStorage = artifacts.require("./DaoStorage");
var RobonomikaCore = artifacts.require("./RobonomikaCore");
var Robonomika = artifacts.require("./Robonomika");
var RobonomikaAuto = artifacts.require("./RobonomikaAuto");
var RobonomikaWithUnpackers = artifacts.require("./RobonomikaWithUnpackers");
var RobonomikaFactoryZeroStage = artifacts.require("./RobonomikaFactoryZeroStage");
var RobonomikaFactoryFirstStage = artifacts.require("./RobonomikaFactoryFirstStage");
var RobonomikaFactorySecondStage = artifacts.require("./RobonomikaFactorySecondStage");

module.exports = function (deployer) {
	deployer.deploy(UtilsLib).then(() => {
		// deployer.link(UtilsLib, DaoBaseWithUnpackers);
		deployer.link(UtilsLib, GenericCaller);
		deployer.link(UtilsLib, RobonomikaCore);
		deployer.link(UtilsLib, Robonomika);
		deployer.link(UtilsLib, RobonomikaAuto);
		deployer.link(UtilsLib, RobonomikaWithUnpackers);
		deployer.link(UtilsLib, RobonomikaFactoryZeroStage);		
		deployer.link(UtilsLib, RobonomikaFactoryFirstStage);
		deployer.link(UtilsLib, RobonomikaFactorySecondStage);
		deployer.link(UtilsLib, DaoBaseAuto);
		deployer.link(UtilsLib, DaoStorage);
		deployer.link(UtilsLib, VotingLib);
		deployer.link(UtilsLib, StdDaoToken);
	});
};
