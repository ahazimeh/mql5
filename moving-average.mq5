#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade/Trade.mqh>

CTrade trade;

int OnInit()
  {
  Print("OnInit");
  Print(_Symbol);
   return(INIT_SUCCEEDED);
  }
void OnDeinit(const int reason)
  {
  Print("OnDeinit");
  }
void OnTick()
  {
  static datetime timestamp;
  datetime time = iTime(_Symbol, PERIOD_CURRENT, 0);
  if(timestamp != time) {
  
     timestamp = time;
     static int handleSlowMa = iMA(_Symbol,PERIOD_CURRENT,200,0,MODE_SMA,PRICE_CLOSE);// static means it will run once
     double slowMaArray[];
     CopyBuffer(handleSlowMa,0,1,2,slowMaArray);
     ArraySetAsSeries(slowMaArray,true); // shows values from left to right
     
     static int handleFastMa = iMA(_Symbol,PERIOD_CURRENT,20,0,MODE_SMA,PRICE_CLOSE);
     double fastMaArray[];
     CopyBuffer(handleFastMa,0,1,2,fastMaArray);
     ArraySetAsSeries(fastMaArray,true); // shows values from left to right   
     if (fastMaArray[0] > slowMaArray[0] && fastMaArray[1] < slowMaArray[1]) {
     Print("Fast Ma is now > than slow ma");
     double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);// get ask price
     double sl = ask - 100 * SymbolInfoDouble(_Symbol,SYMBOL_POINT);// point is the last digit in a pair
     double tp = ask + 100 * SymbolInfoDouble(_Symbol,SYMBOL_POINT);// point is the last digit in a pair
     trade.Buy(0.01,_Symbol,ask,sl,tp,"This is a buy trade" );
     }
     
     if (fastMaArray[0] < slowMaArray[0] && fastMaArray[1] >slowMaArray[1]) {
     Print("Fast Ma is now < than slow ma");
     double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);// get ask price
     double sl = bid + 100 * SymbolInfoDouble(_Symbol,SYMBOL_POINT);// point is the last digit in a pair
     double tp = bid - 100 * SymbolInfoDouble(_Symbol,SYMBOL_POINT);// point is the last digit in a pair
     trade.Sell(0.01,_Symbol,bid,sl,tp,"This is a sell trade" );
     }
     
     Comment("\nslowMaArray[0]: ",slowMaArray[0],
             "\nslowMaArray[1]: ",slowMaArray[1],
             "\nfastMaArray[0]: ",fastMaArray[0],
             "\nfastMaArray[1]: ",fastMaArray[1]
     );
  }
}