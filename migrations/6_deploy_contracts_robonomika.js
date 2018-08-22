var DaoBaseLib = artifacts.require("./DaoBaseLib");
var DaoBase = artifacts.require("./DaoBase");
var DaoStorage = artifacts.require("./DaoStorage");
var RobonomikaCore = artifacts.require("./RobonomikaCore");
var Robonomika = artifacts.require("./Robonomika");
var RobonomikaAuto = artifacts.require("./RobonomikaAuto");
var RobonomikaWithUnpackers = artifacts.require("./RobonomikaWithUnpackers");
var DaoBaseWithUnpackers = artifacts.require("./DaoBaseWithUnpackers");
var StdDaoToken = artifacts.require("./StdDaoToken");
// var StdDaoToken2 = artifacts.require("./StdDaoToken");
var token, repToken, store, daoBase, roboAuto, robonomika;
module.exports = function (deployer, network, accounts) { 
	deployer.then(function() {
		return StdDaoToken.new('roboToken', 'ROBO', 18, true, true, 1000000000,{overwrite:true});
	}).then(function(instance) {
		token = instance;
		return StdDaoToken.new('repToken', 'REP', 18, true, true, 1000000000,{overwrite:true});
	}).then(function(instance) {
		repToken = instance;
		return DaoStorage.new([token.address, repToken.address],{overwrite:true});
	}).then(function(instance) {
		store = instance;
		return DaoBase.new(store.address,{overwrite:true});
	}).then(function(instance) {
		daoBase = instance;
		return RobonomikaAuto.new(daoBase.address,{overwrite:true});
	}).then(function(instance) {
		roboAuto = instance;
		return RobonomikaWithUnpackers.new(daoBase.address, token.address, repToken.address, [accounts[1]], {overwrite:true});
	}).then(function(instance) {
		robonomika = instance;
		token.transferOwnership(robonomika.address);
	}).then(function() {	
		repToken.transferOwnership(robonomika.address);
	}).then(function() {
		store.transferOwnership(robonomika.address);
	})
};
