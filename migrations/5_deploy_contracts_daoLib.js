var DaoBaseLib = artifacts.require("./DaoBaseLib");
var DaoBase = artifacts.require("./DaoBase");
var RobonomikaCore = artifacts.require("./RobonomikaCore");
var Robonomika = artifacts.require("./Robonomika");
var RobonomikaAuto = artifacts.require("./RobonomikaAuto");
var RobonomikaWithUnpackers = artifacts.require("./RobonomikaWithUnpackers");
var DaoBaseWithUnpackers = artifacts.require("./DaoBaseWithUnpackers");
var RobonomikaFactoryFirstStage = artifacts.require("./RobonomikaFactoryFirstStage");
var RobonomikaFactorySecondStage = artifacts.require("./RobonomikaFactorySecondStage");

module.exports = function (deployer) {
	deployer.deploy(DaoBaseLib).then(() => {
		deployer.link(DaoBaseLib, DaoBase);
		deployer.link(DaoBaseLib, RobonomikaCore);
		deployer.link(DaoBaseLib, Robonomika);
		deployer.link(DaoBaseLib, RobonomikaFactoryFirstStage);
		deployer.link(DaoBaseLib, RobonomikaFactorySecondStage);
		deployer.link(DaoBaseLib, RobonomikaWithUnpackers);
		deployer.link(DaoBaseLib, RobonomikaAuto);
		deployer.link(DaoBaseLib, DaoBaseWithUnpackers);
	});
};

