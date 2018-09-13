var FixedSupplyToken = artifacts.require("./FixedSupplyToken.sol");
var Owned = artifacts.require("./Owned.sol");
var Exchange = artifacts.require("./Exchange.sol");

module.exports = function(deployer) {
  deployer.deploy(Owned);
  deployer.deploy(Exchange);
  deployer.deploy(FixedSupplyToken);
};
