// var DaoBaseWithUnpackers = artifacts.require("./DaoBaseWithUnpackers");
var GenericCaller = artifacts.require("./GenericCaller");
var GenericCallerLib = artifacts.require("./GenericCallerLib");
var DaoBaseAuto = artifacts.require("./DaoBaseAuto");
var Voting = artifacts.require("./Voting");
var VotingLib = artifacts.require("./VotingLib");
var RobonomikaAuto = artifacts.require("./RobonomikaAuto");

module.exports = function (deployer) {
	deployer.deploy(GenericCallerLib).then(() => {
		deployer.link(GenericCallerLib, GenericCaller);
		deployer.link(GenericCallerLib, DaoBaseAuto);
		deployer.link(GenericCallerLib, RobonomikaAuto);
	});
};
