var DaoBaseLib = artifacts.require("./DaoBaseLib");
var DaoBase = artifacts.require("./DaoBase");
var RobonomikaCore = artifacts.require("./RobonomikaCore");
var Robonomika = artifacts.require("./Robonomika");
// var DaoBaseWithUnpackers = artifacts.require("./DaoBaseWithUnpackers");

module.exports = function (deployer) {
	deployer.deploy(DaoBaseLib).then(() => {
		deployer.link(DaoBaseLib, DaoBase);
		deployer.link(DaoBaseLib, RobonomikaCore);
		deployer.link(DaoBaseLib, Robonomika);
		
		// deployer.link(DaoLib, DaoBaseWithUnpackers);
	});
};

