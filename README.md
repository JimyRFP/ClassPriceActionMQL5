# ClassPriceActionMQL5
## Class used to get filtered information from candles
### [Programmer MQL Profile](https://www.mql5.com/pt/users/rafaelfp)

***Most functions use these parameters below, so they will be explained only once.***

* **General parameters**
  * **Name:** applied_price 
    * **Type:** ENUM_APPLIED_PRICE
    * **Description:** Basic ENUM from MQL5 language, select the price (HIGH,LOW,CLOSE,OPEN) , you can see more in [this link.](https://www.mql5.com/en/docs/constants/indicatorconstants/prices)
  * **Name:** symbol
    * **Type:** string
    * **Description:** The name of symbol to be read
  * **Name:** time_frame
    * **Type:** ENUM_TIMEFRAMES  
    * **Description:** Timeframes of the charts, you can see more in [this link.](https://www.mql5.com/en/docs/constants/chartconstants/enum_timeframes)
  * **Name** start_pos
    * **Type:** int
    * **Description:** The number of most recent candles you want disregard. If you want get the most recent candle put **0** in this param.
  * **Name** count
    * **Type:** int
    * **Description:** The number of candles you want to consider.

* **Class Methods**
  * **Name:** GetMaxPrice
    * **Return:** Double
    * **Parameters:** (ENUM_APPLIED_PRICE applied_price,const string symbol,ENUM_TIMEFRAMES time_frame,int start_pos,int count) 
    * **Description:** Return the **max** price of the candles sample, the max price is in relation the **applied price**.
  * **Name:** GetMinPrice
    * **Description:** Equal 'GetMaxPrice' method, but return **min** price.
