// var DaoBaseWithUnpackers = artifacts.require("./DaoBaseWithUnpackers");
var GenericCaller = artifacts.require("./GenericCaller");
var GenericCallerLib = artifacts.require("./GenericCallerLib");
var Voting = artifacts.require("./Voting");
var VotingLib = artifacts.require("./VotingLib");
var DaoBaseAuto = artifacts.require("./DaoBaseAuto");
var DaoBaseLib = artifacts.require("./DaoBaseLib");
var RobonomikaAuto = artifacts.require("./RobonomikaAuto");
var RobonomikaFactoryFirstStage = artifacts.require("./RobonomikaFactoryFirstStage");
var RobonomikaFactorySecondStage = artifacts.require("./RobonomikaFactorySecondStage");

module.exports = function (deployer) {
	deployer.deploy(VotingLib).then(() => {
		deployer.link(VotingLib, Voting);
		deployer.link(VotingLib, GenericCaller);
		deployer.link(VotingLib, GenericCallerLib);
		deployer.link(VotingLib, DaoBaseAuto);
		deployer.link(VotingLib, DaoBaseLib);
		deployer.link(VotingLib, RobonomikaAuto);
		deployer.link(VotingLib, RobonomikaFactoryFirstStage);
		deployer.link(VotingLib, RobonomikaFactorySecondStage);
	});
};
