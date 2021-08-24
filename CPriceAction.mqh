//+------------------------------------------------------------------+
//|                                                 CPriceAction.mqh |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
class CPriceAction{
  public:
  double GetMaxPrice(ENUM_APPLIED_PRICE,const string symbol,ENUM_TIMEFRAMES,int start_pos,int count);
  double GetMinPrice(ENUM_APPLIED_PRICE,const string symbol,ENUM_TIMEFRAMES,int start_pos,int count);
  private:
  //FUNCTIONS
  int GetCandles(ENUM_APPLIED_PRICE,const string symbol,ENUM_TIMEFRAMES,int start_pos,int count,double &ret_array[])const;
};

double CPriceAction::GetMinPrice(ENUM_APPLIED_PRICE applied_price,const string symbol,ENUM_TIMEFRAMES time_frame,int start_pos,int count){
  double candles_price[];
  if(GetCandles(applied_price,symbol,time_frame,start_pos,count,candles_price)<0)
    return -1;
  int min_index=ArrayMinimum(candles_price);
  if(min_index<0)
    return -1;
  return candles_price[min_index];     
}


double CPriceAction::GetMaxPrice(ENUM_APPLIED_PRICE applied_price,const string symbol,ENUM_TIMEFRAMES time_frame,int start_pos,int count){
  double candles_price[];
  if(GetCandles(applied_price,symbol,time_frame,start_pos,count,candles_price)<0)
    return -1;
  int max_index=ArrayMaximum(candles_price);
  if(max_index<0)
    return -1;
  return candles_price[max_index];  
}


int CPriceAction::GetCandles(ENUM_APPLIED_PRICE applied_price,const string symbol,ENUM_TIMEFRAMES time_frame,int start_pos,int count,double &ret_array[])const{
  switch(applied_price){
    case PRICE_CLOSE:
      return CopyClose(symbol,time_frame,start_pos,count,ret_array);
    case PRICE_HIGH:
      return CopyHigh(symbol,time_frame,start_pos,count,ret_array);
    case PRICE_LOW:
      return CopyLow(symbol,time_frame,start_pos,count,ret_array);
    case PRICE_OPEN:
      return CopyOpen(symbol,time_frame,start_pos,count,ret_array);    
  };
  return -1;
}

