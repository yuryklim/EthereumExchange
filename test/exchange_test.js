var fixedSupplyToken = artifacts.require("./FixedSupplyToken.sol");
var exchange = artifacts.require("./Exchange.sol");

contract('exchange_test', function(accounts) {
  it("should be possible to add tokens", function () {
        var myTokenInstance;
        var myExchangeInstance;
        return fixedSupplyToken.deployed().then(function (instance) {
            myTokenInstance = instance;
            return exchange.deployed();
        }).then(function (exchangeInstance) {
            myExchangeInstance = exchangeInstance;
            return myExchangeInstance.addToken("FIXED", myTokenInstance.address);
        }).then(function (txResult) {
            console.log(txResult);
            assert.equal(txResult.logs[0].event, "TokenAddedToSystem", "TokenAddedToSystem event should be emitted");
            return myExchangeInstance.hasToken.call("FIXED");
        }).then(function (booleanHasToken) {
            assert.equal(booleanHasToken, true, "The Token was not added");
            return myExchangeInstance.hasToken.call("SOMETHING");
        }).then(function (booleanHasNotToken) {
            assert.equal(booleanHasNotToken, false, "A Token that doesn't exist was found.");
        });
    });
    it("should be possible to Deposit Token", function () {
        var myExchangeInstance;
        var myTokenInstance;
        return fixedSupplyToken.deployed().then(function (instance) {
            myTokenInstance = instance;
            return instance;
        }).then(function (tokenInstance) {
            myTokenInstance = tokenInstance;
            return exchange.deployed();
        }).then(function (exchangeInstance) {
            myExchangeInstance = exchangeInstance;
            return myTokenInstance.approve(myExchangeInstance.address, 2000);
        }).then(function(txResult) {
            return myExchangeInstance.depositToken("FIXED", 2000);
        }).then(function(txResult) {
            return myExchangeInstance.getBalance("FIXED");
        }).then(function(balanceToken) {
            assert.equal(balanceToken, 2000, "There should be 2000 tokens for the address");
        });
    });
    it("should be possible to Withdraw Token", function () {
        var myExchangeInstance;
        var myTokenInstance;
        var balancedTokenInExchangeBeforeWithdrawal;
        var balanceTokenInTokenBeforeWithdrawal;
        var balanceTokenInExchangeAfterWithdrawal;
        var balanceTokenInTokenAfterWithdrawal;

        return fixedSupplyToken.deployed().then(function (instance) {
            myTokenInstance = instance;
            return instance;
        }).then(function (tokenInstance) {
            myTokenInstance = tokenInstance;
            return exchange.deployed();
        }).then(function (exchangeInstance) {
            myExchangeInstance = exchangeInstance;
            return myExchangeInstance.getBalance.call("FIXED");
        }).then(function(balanceExchange) {
            balancedTokenInExchangeBeforeWithdrawal = balanceExchange.toNumber();
            return  myTokenInstance.balanceOf.call(accounts[0]);
        }).then(function(balanceToken) {
            balanceTokenInTokenBeforeWithdrawal = balanceToken.toNumber();
            return myExchangeInstance.withdrawToken("FIXED", balancedTokenInExchangeBeforeWithdrawal);
        }).then(function(txResult) {
            console.log(txResult);
              assert.equal(txResult.logs[0].event, "WithdrawalToken",
              "WithdrawalToken event should be emitted");
            return myExchangeInstance.getBalance.call("FIXED");
        }).then(function(balanceExchange) {
            balanceTokenInExchangeAfterWithdrawal = balanceExchange.toNumber();
            return myTokenInstance.balanceOf.call(accounts[0]);
        }).then(function(balanceToken) {
            balanceTokenInTokenAfterWithdrawal = balanceToken.toNumber();
            assert.equal(balanceTokenInExchangeAfterWithdrawal, 0, "There should be 0 tokens left in the exchange");
            assert.equal(balanceTokenInTokenAfterWithdrawal, balancedTokenInExchangeBeforeWithdrawal + balanceTokenInTokenBeforeWithdrawal, "There should be 0 tokens left in the exchange");
        });
    });
});
