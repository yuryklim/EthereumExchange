var FixedSupplyToken = artifacts.require("./FixedSupplyToken.sol");
var Owned = artifacts.require("./Owned.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var Exchange = artifacts.require("./Exchange.sol");

module.exports = function(deployer) {
  deployer.deploy(Owned);
  deployer.deploy(SafeMath);
  deployer.deploy(Exchange);
  deployer.deploy(FixedSupplyToken);
};
