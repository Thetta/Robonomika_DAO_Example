// var DaoBaseWithUnpackers = artifacts.require("./DaoBaseWithUnpackers");
var GenericCaller = artifacts.require("./GenericCaller");
var GenericCallerLib = artifacts.require("./GenericCallerLib");
var DaoBaseAuto = artifacts.require("./DaoBaseAuto");
var Voting = artifacts.require("./Voting");
var VotingLib = artifacts.require("./VotingLib");
var RobonomikaAuto = artifacts.require("./RobonomikaAuto");
var RobonomikaFactoryFirstStage = artifacts.require("./RobonomikaFactoryFirstStage");
var RobonomikaFactorySecondStage = artifacts.require("./RobonomikaFactorySecondStage");

module.exports = function (deployer) {
	deployer.deploy(GenericCallerLib).then(() => {
		deployer.link(GenericCallerLib, GenericCaller);
		deployer.link(GenericCallerLib, DaoBaseAuto);
		deployer.link(GenericCallerLib, RobonomikaAuto);
		deployer.link(GenericCallerLib, RobonomikaFactoryFirstStage);
		deployer.link(GenericCallerLib, RobonomikaFactorySecondStage);
	});
};
