var DaoBaseLib = artifacts.require("./DaoBaseLib");
var DaoBase = artifacts.require("./DaoBase");
var RobonomicaCore = artifacts.require("./RobonomicaCore");
// var DaoBaseWithUnpackers = artifacts.require("./DaoBaseWithUnpackers");

module.exports = function (deployer) {
	deployer.deploy(DaoBaseLib).then(() => {
		deployer.link(DaoBaseLib, DaoBase);
		deployer.link(DaoBaseLib, RobonomicaCore);
		
		// deployer.link(DaoLib, DaoBaseWithUnpackers);
	});
};

