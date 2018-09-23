pragma solidity ^0.4.24;
import "./Owned.sol";
import "./FixedSupplyToken.sol";

contract Exchange is Owned {

    ///////////////////////
    // GENERAL STRUCTURE //
    ///////////////////////
    struct Offer {
      uint amount;
      address who;
    }

    struct OrderBook {
      uint higherPrice;
      uint lowerPrice;

      mapping (uint => Offer) offers;

      uint offers_key;
      uint offers_length;
    }

    struct Token {
      address tokenContract;
      string symbolName;

      mapping (uint => OrderBook) buyBook;
      uint curBuyPrice;
      uint lowestBuyPrice;
      uint amountBuyPrices;

      mapping (uint => OrderBook) sellBook;
      uint curSellPrice;
      uint highestSellPrice;
      uint amountSellPrices;
    }


    //we support a max of 255 tokens...
    mapping (uint8 => Token) tokens;
    uint8 symbolNameIndex;


    //////////////
    // BALANCES //
    //////////////
    mapping (address => mapping (uint8 => uint)) tokenBalanceForAddress;

    mapping (address => uint) balanceEthForAddress;




    ////////////
    // EVENTS //
    ////////////
    //EVENTS for Deposit/withdrawal
        event DepositForTokenReceived(address indexed _from, uint indexed _symbolIndex, uint _amount, uint _timestamp);
        event WithdrawalToken(address indexed _to, uint indexed _symbolIndex, uint _amount, uint _timestamp);
        event DepositForEthReceived(address indexed _from, uint _amount, uint _timestamp);
        event WithdrawalEth(address indexed _to, uint _amount, uint _timestamp);

        //events for orders
        event LimitSellOrderCreated(uint indexed _symbolIndex, address indexed _who, uint _amountTokens, uint _priceInWei, uint _orderKey);
        event SellOrderFulfilled(uint indexed _symbolIndex, uint _amount, uint _priceInWei, uint _orderKey);
        event SellOrderCanceled(uint indexed _symbolIndex, uint _priceInWei, uint _orderKey);
        event LimitBuyOrderCreated(uint indexed _symbolIndex, address indexed _who, uint _amountTokens, uint _priceInWei, uint _orderKey);
        event BuyOrderFulfilled(uint indexed _symbolIndex, uint _amount, uint _priceInWei, uint _orderKey);
        event BuyOrderCanceled(uint indexed _symbolIndex, uint _priceInWei, uint _orderKey);

        //events for management
        event TokenAddedToSystem(uint _symbolIndex, string _token, uint _timestamp);



    //////////////////////////////////
    // DEPOSIT AND WITHDRAWAL ETHER //
    //////////////////////////////////
    function depositEther() payable {
      require(balanceEthForAddress[msg.sender] + msg.value >= balanceEthForAddress[msg.sender]);
      balanceEthForAddress[msg.sender] += msg.value;
      DepositForEthReceived(msg.sender, msg.value, now);
    }

    function withdrawEther(uint amountInWei) {
      require(balanceEthForAddress[msg.sender] - amountInWei >= 0);
      require(balanceEthForAddress[msg.sender] - amountInWei <= balanceEthForAddress[msg.sender]);
      balanceEthForAddress[msg.sender] -= amountInWei;
      msg.sender.transfer(amountInWei);
      WithdrawalEth(msg.sender, amountInWei, now);
    }

    function getEthBalanceInWei() constant returns (uint){
      return balanceEthForAddress[msg.sender];
    }


    //////////////////////
    // TOKEN MANAGEMENT //
    //////////////////////

    function addToken(string symbolName, address erc20TokenAddress) onlyOwner {
        require(!hasToken(symbolName));
        symbolNameIndex++;
        tokens[symbolNameIndex].symbolName = symbolName;
        tokens[symbolNameIndex].tokenContract = erc20TokenAddress;
        TokenAddedToSystem(symbolNameIndex, symbolName, now);
    }

    function hasToken(string symbolName) constant returns (bool) {
      uint8 index = getSymbolIndex(symbolName);
        if (index == 0) {
          return false;
        }
        return true;
    }


    function getSymbolIndex(string symbolName) internal returns (uint8) {
      for(uint8 i = 1; i <= symbolNameIndex; i++){
        if(stringsEqual(tokens[i].symbolName, symbolName)){
          return i;
        }
      }
      return 0;
    }
    //////////////////////////////////
    // STRING COMPARISON FUNCTION //
    //////////////////////////////////
    function stringsEqual(string storage _a, string memory _b) internal returns (bool) {
      bytes storage a = bytes(_a);
      bytes memory b = bytes(_b);
        if(a.length != b.length)
          return false;
      //todo unroll this loop
        for(uint i = 0; i < a.length; i++)
          if(a[i] != b[i])
            return false;
        return true;
    }


    //////////////////////////////////
    // DEPOSIT AND WITHDRAWAL TOKEN //
    //////////////////////////////////
    function depositToken(string symbolName, uint amount) {
      uint8 symbolNameIndex = getSymbolIndexOrThrow(symbolName);
      require(tokens[symbolNameIndex].tokenContract != address(0));
      ERC20Interface token = ERC20Interface(tokens[symbolNameIndex].tokenContract);
      require(token.transferFrom(msg.sender, address(this), amount) == true);
      require(tokenBalanceForAddress[msg.sender][symbolNameIndex] + amount >= tokenBalanceForAddress[msg.sender][symbolNameIndex]);
      tokenBalanceForAddress[msg.sender][symbolNameIndex] += amount;
      DepositForTokenReceived(msg.sender, symbolNameIndex, amount, now);
    }

    function withdrawToken(string symbolName, uint amount) {
      uint8 symbolNameIndex = getSymbolIndexOrThrow(symbolName);
      require(tokens[symbolNameIndex].tokenContract != address(0));
      ERC20Interface token = ERC20Interface(tokens[symbolNameIndex].tokenContract);
      require(tokenBalanceForAddress[msg.sender][symbolNameIndex] - amount >= 0);
      require(tokenBalanceForAddress[msg.sender][symbolNameIndex] - amount <= tokenBalanceForAddress[msg.sender][symbolNameIndex]);
      tokenBalanceForAddress[msg.sender][symbolNameIndex] -= amount;
      require(token.transfer(msg.sender, amount) == true);
      WithdrawalToken(msg.sender, symbolNameIndex, amount, now);
    }

    function getBalance(string symbolName) constant returns (uint) {
      uint8 symbolNameIndex = getSymbolIndexOrThrow(symbolName);
      return tokenBalanceForAddress[msg.sender][symbolNameIndex];
    }

    function getSymbolIndexOrThrow(string symbolName) returns (uint8) {
      uint8 index = getSymbolIndex(symbolName);
      require(index > 0);
      return index;
    }



    /////////////////////////////
    // ORDER BOOK - BID ORDERS //
    /////////////////////////////
    function getBuyOrderBook(string symbolName) constant returns (uint[], uint[]) {
    }


    /////////////////////////////
    // ORDER BOOK - ASK ORDERS //
    /////////////////////////////
    function getSellOrderBook(string symbolName) constant returns (uint[], uint[]) {
    }



    ////////////////////////////
    // NEW ORDER - BID ORDER //
    ///////////////////////////
    function buyToken(string symbolName, uint priceInWei, uint amount) {
    }





    ////////////////////////////
    // NEW ORDER - ASK ORDER //
    ///////////////////////////
    function sellToken(string symbolName, uint priceInWei, uint amount) {
    }



    //////////////////////////////
    // CANCEL LIMIT ORDER LOGIC //
    //////////////////////////////
    function cancelOrder(string symbolName, bool isSellOrder, uint priceInWei, uint offerKey) {
    }

}
