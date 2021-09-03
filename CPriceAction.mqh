//+------------------------------------------------------------------+
//|                                                 CPriceAction.mqh |
//|                                            Rafael Floriani Pinto |
//|                           https://www.mql5.com/en/users/rafaelfp |
//+------------------------------------------------------------------+
#ifndef CPRICEACTIONJIMYRFP
#define CPRICEACTIONJIMYRFP
#property copyright "Copyright 2021, JIMYRFP."
#property link      "https://github.com/JimyRFP"
class CPriceAction
  {
public:
   double            GetMaxPrice(ENUM_APPLIED_PRICE,const string symbol,ENUM_TIMEFRAMES,int start_pos,int count);
   double            GetMinPrice(ENUM_APPLIED_PRICE,const string symbol,ENUM_TIMEFRAMES,int start_pos,int count);
   int               GetCandlesSize(const string symbol,ENUM_TIMEFRAMES,int start_pos,int count,double &ret_array[]);
   double            GetCandlesPriceAverage(ENUM_APPLIED_PRICE,const string symbol,ENUM_TIMEFRAMES,int start_pos,int count);
   double            GetCandlesSizeAverage(const string symbol,ENUM_TIMEFRAMES,int start_pos,int count);
   int               GetCandles(ENUM_APPLIED_PRICE,const string symbol,ENUM_TIMEFRAMES,int start_pos,int count,double &ret_array[])const;
   int               GetMatchRegionsNumber(ENUM_APPLIED_PRICE,const string symbol,ENUM_TIMEFRAMES,int start_pos,int count,double tolerance,double &prices_array[],int &matchs_array[]);
   double            GetStrongerMatchRegion(ENUM_APPLIED_PRICE,const string symbol,ENUM_TIMEFRAMES,int start_pos,int count,double tolerance);
   int               GetCandlesCloseSubOpen(const string symbol,ENUM_TIMEFRAMES,int start_pos,int count,double &ret_array[]);
   double            GetCandlesVariantionAverage(const string symbol,ENUM_TIMEFRAMES,int start_pos,int count);
private:
   template<typename T>
   double              GetArrayAverage(T &array[],int size=-1)const;

  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CPriceAction::GetMinPrice(ENUM_APPLIED_PRICE applied_price,const string symbol,ENUM_TIMEFRAMES time_frame,int start_pos,int count)
  {
   double candles_price[];
   if(GetCandles(applied_price,symbol,time_frame,start_pos,count,candles_price)<0)
      return -1;
   int min_index=ArrayMinimum(candles_price);
   if(min_index<0)
      return -1;
   return candles_price[min_index];
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CPriceAction::GetCandlesSize(const string symbol,ENUM_TIMEFRAMES time_frame,int start_pos,int count,double &ret_array[])
  {
   double high[],low[];
   int high_size,low_size;
   high_size=GetCandles(PRICE_HIGH,symbol,time_frame,start_pos,count,high);
   low_size=GetCandles(PRICE_LOW,symbol,time_frame,start_pos,count,low);
   if((high_size<0 || low_size<0) || (high_size!=low_size))
      return -1;
   ArrayResize(ret_array,high_size);
   for(int i=0; i<high_size; i++)
     {
      ret_array[i]=high[i]-low[i];
     }
   return high_size;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CPriceAction::GetMaxPrice(ENUM_APPLIED_PRICE applied_price,const string symbol,ENUM_TIMEFRAMES time_frame,int start_pos,int count)
  {
   double candles_price[];
   if(GetCandles(applied_price,symbol,time_frame,start_pos,count,candles_price)<0)
      return -1;
   int max_index=ArrayMaximum(candles_price);
   if(max_index<0)
      return -1;
   return candles_price[max_index];
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CPriceAction::GetCandlesSizeAverage(const string symbol,ENUM_TIMEFRAMES time_frame,int start_pos,int count)
  {
   double candles_size[];
   int n_candles=GetCandlesSize(symbol,time_frame,start_pos,count,candles_size);
   if(n_candles<1)
      return -1;
   double sum=0;
   return GetArrayAverage(candles_size);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CPriceAction::GetCandlesPriceAverage(ENUM_APPLIED_PRICE applied_price,const string symbol,ENUM_TIMEFRAMES time_frame,int start_pos,int count)
  {
   double candles_price[];
   int num_candles=GetCandles(applied_price,symbol,time_frame,start_pos,count,candles_price);
   if(num_candles<1)
      return -1;
   return GetArrayAverage(candles_price);
  }




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CPriceAction::GetCandles(ENUM_APPLIED_PRICE applied_price,const string symbol,ENUM_TIMEFRAMES time_frame,int start_pos,int count,double &ret_array[])const
  {
   switch(applied_price)
     {
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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CPriceAction::GetMatchRegionsNumber(ENUM_APPLIED_PRICE applied_price,
                                        const string symbol,
                                        ENUM_TIMEFRAMES time_frame,
                                        int start_pos,
                                        int count,
                                        double tolerance,
                                        double &prices_array[],
                                        int &matchs_array[])
  {

   int number_candles=GetCandles(applied_price,symbol,time_frame,start_pos,count,prices_array);
   if(number_candles<1)
      return -1;
   if(ArrayResize(matchs_array,number_candles)!=number_candles)
      return -1;
   ArraySetAsSeries(matchs_array,ArrayGetAsSeries(prices_array));
   double less_tolerance,more_tolerance;
   for(int i=0; i<number_candles; i++)
     {
      matchs_array[i]=0;
      less_tolerance=prices_array[i]-tolerance;
      more_tolerance=prices_array[i]+tolerance;
      for(int j=0; j<number_candles; j++)
        {
         if(prices_array[j]<=more_tolerance && prices_array[j]>=less_tolerance)
            matchs_array[i]++;
        }
     }
   return number_candles;
  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CPriceAction::GetStrongerMatchRegion(ENUM_APPLIED_PRICE applied_price,const string symbol,ENUM_TIMEFRAMES time_frame,int start_pos,int count,double tolerance)
  {
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



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CPriceAction::GetCandlesCloseSubOpen(const string symbol,ENUM_TIMEFRAMES time_frame,int start_pos,int count,double &ret_array[])
  {
   int close_size,open_size;
   double close_prices[],open_prices[];
   close_size=GetCandles(PRICE_CLOSE,symbol,time_frame,start_pos,count,close_prices);
   open_size=GetCandles(PRICE_OPEN,symbol,time_frame,start_pos,count,open_prices);
   if(close_size<1)
      return -1;
   if(close_size!=open_size)
      return -1;
   int ret_size=ArrayResize(ret_array,close_size);
   if(ret_size!=close_size)
      return -1;
   for(int i=0; i<ret_size; i++)
     {
      ret_array[i]=close_prices[i]-open_prices[i];
     }
   return ret_size;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CPriceAction::GetCandlesVariantionAverage(const string symbol,ENUM_TIMEFRAMES time_frame,int start_pos,int count)
  {
   double candles_variation[];
   int candles_size=GetCandlesCloseSubOpen(symbol,time_frame,start_pos,count,candles_variation);
   if(candles_size<1)
      return -1;
   for(int i=0; i<candles_size; i++)
      candles_variation[i]=MathAbs(candles_variation[i]);
   return GetArrayAverage(candles_variation);
  }

//+------------------------------------------------------------------+

template<typename T>
double CPriceAction::GetArrayAverage(T &array[],int size=-1)const
  {
   int array_size=size;
   if(array_size<1)
      array_size=ArraySize(array);
   if(array_size<1)
      return -1;
   double sum=0;
   for(int i=0; i<array_size; i++)
     {
      sum+=array[i];
     }
   return sum/array_size;
  }
//+------------------------------------------------------------------+
#endif