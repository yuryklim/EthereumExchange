pragma solidity ^0.4.24;
import "./Owned.sol";

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




    //////////////////////////////////
    // DEPOSIT AND WITHDRAWAL ETHER //
    //////////////////////////////////
    function depositEther() payable {
    }

    function withdrawEther(uint amountInWei) {
    }

    function getEthBalanceInWei() constant returns (uint){
    }


    //////////////////////
    // TOKEN MANAGEMENT //
    //////////////////////

    function addToken(string symbolName, address erc20TokenAddress) onlyOwner {

    }

    function hasToken(string symbolName) constant returns (bool) {
    }


    function getSymbolIndex(string symbolName) internal returns (uint8) {
    }




    //////////////////////////////////
    // DEPOSIT AND WITHDRAWAL TOKEN //
    //////////////////////////////////
    function depositToken(string symbolName, uint amount) {
    }

    function withdrawToken(string symbolName, uint amount) {
    }

    function getBalance(string symbolName) constant returns (uint) {
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
