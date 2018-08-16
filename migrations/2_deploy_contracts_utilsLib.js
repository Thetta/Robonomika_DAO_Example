var UtilsLib = artifacts.require("./UtilsLib");
// var DaoBaseWithUnpackers = artifacts.require("./DaoBaseWithUnpackers");
var GenericCaller = artifacts.require("./GenericCaller");
var GenericCallerLib = artifacts.require("./GenericCallerLib");
var Voting = artifacts.require("./Voting");
var VotingLib = artifacts.require("./VotingLib");
var DaoBaseAuto = artifacts.require("./DaoBaseAuto");
var StdDaoToken = artifacts.require("./StdDaoToken");
var DaoStorage = artifacts.require("./DaoStorage");


module.exports = function (deployer) {
	deployer.deploy(UtilsLib).then(() => {
		// deployer.link(UtilsLib, DaoBaseWithUnpackers);
		deployer.link(UtilsLib, GenericCaller);
		deployer.link(UtilsLib, DaoBaseAuto);
		deployer.link(UtilsLib, DaoStorage);
		deployer.link(UtilsLib, VotingLib);
		deployer.link(UtilsLib, StdDaoToken);
	});
};
