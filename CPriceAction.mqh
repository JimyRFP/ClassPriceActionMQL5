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
  int GetCandlesSize(const string symbol,ENUM_TIMEFRAMES,int start_pos,int count,double &ret_array[]);
  double GetCandlesPriceAverage(ENUM_APPLIED_PRICE,const string symbol,ENUM_TIMEFRAMES,int start_pos,int count);
  double GetCandlesSizeAverage(const string symbol,ENUM_TIMEFRAMES,int start_pos,int count);
  int GetCandles(ENUM_APPLIED_PRICE,const string symbol,ENUM_TIMEFRAMES,int start_pos,int count,double &ret_array[])const;
  int GetMatchRegionsNumber(ENUM_APPLIED_PRICE,const string symbol,ENUM_TIMEFRAMES,int start_pos,int count,double tolerance,double &prices_array[],int &matchs_array[]);
  double GetStrongerMatchRegion(ENUM_APPLIED_PRICE,const string symbol,ENUM_TIMEFRAMES,int start_pos,int count,double tolerance);
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

int CPriceAction::GetCandlesSize(const string symbol,ENUM_TIMEFRAMES time_frame,int start_pos,int count,double &ret_array[]){
  double high[],low[];
  int high_size,low_size;
  high_size=GetCandles(PRICE_HIGH,symbol,time_frame,start_pos,count,high);
  low_size=GetCandles(PRICE_LOW,symbol,time_frame,start_pos,count,low);
  if((high_size<0 || low_size<0) || (high_size!=low_size))
   return -1;
  ArrayResize(ret_array,high_size);
  for(int i=0;i<high_size;i++){
    ret_array[i]=high[i]-low[i];
  }   
  return high_size;   
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

double CPriceAction::GetCandlesSizeAverage(const string symbol,ENUM_TIMEFRAMES time_frame,int start_pos,int count){
  double candles_size[];
  int n_candles=GetCandlesSize(symbol,time_frame,start_pos,count,candles_size);
  if(n_candles<1)
    return -1;
  double sum=0;  
  for(int i=0;i<n_candles;i++){
   sum+=candles_size[i];
  }
  return sum/n_candles; 
}

double CPriceAction::GetCandlesPriceAverage(ENUM_APPLIED_PRICE applied_price,const string symbol,ENUM_TIMEFRAMES time_frame,int start_pos,int count){
   double candles_price[];
   int num_candles=GetCandles(applied_price,symbol,time_frame,start_pos,count,candles_price);
   if(num_candles<1)
     return -1;
   double price_sum=0;
   for(int i=0;i<num_candles;i++){
     price_sum+=candles_price[i];
   }
   return price_sum/num_candles;
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

int CPriceAction::GetMatchRegionsNumber(ENUM_APPLIED_PRICE applied_price,
                                        const string symbol,
                                        ENUM_TIMEFRAMES time_frame,
                                        int start_pos,
                                        int count,
                                        double tolerance,
                                        double &prices_array[],
                                        int &matchs_array[]){

  int number_candles=GetCandles(applied_price,symbol,time_frame,start_pos,count,prices_array);
  if(number_candles<1)
    return -1;
  if(ArrayResize(matchs_array,number_candles)!=number_candles)
    return -1;   
  ArraySetAsSeries(matchs_array,ArrayGetAsSeries(prices_array));  
  double less_tolerance,more_tolerance;  
  for(int i=0;i<number_candles;i++){     
    matchs_array[i]=0;
    less_tolerance=prices_array[i]-tolerance;
    more_tolerance=prices_array[i]+tolerance;
    for(int j=0;j<number_candles;j++){
      if(prices_array[j]<=more_tolerance && prices_array[j]>=less_tolerance)
        matchs_array[i]++;        
    }   
  }  
  return number_candles;  
};


double CPriceAction::GetStrongerMatchRegion(ENUM_APPLIED_PRICE applied_price,const string symbol,ENUM_TIMEFRAMES time_frame,int start_pos,int count,double tolerance){
   double prices[];
   int matches[];
   if(GetMatchRegionsNumber(applied_price,symbol,time_frame,start_pos,count,tolerance,prices,matches)<1)
     return -1;
   ArraySetAsSeries(prices,true);
   ArraySetAsSeries(matches,true);  
   int max_index=ArrayMaximum(matches);
   if(max_index<0)
    return -1;
   return prices[max_index];  
}





