var FixedSupplyToken = artifacts.require("./FixedSupplyToken.sol");
var Owned = artifacts.require("./Owned.sol");


module.exports = function(deployer) {
  deployer.deploy(Owned);
  deployer.deploy(FixedSupplyToken);

};
