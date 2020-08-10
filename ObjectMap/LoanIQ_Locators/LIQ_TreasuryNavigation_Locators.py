###Treasury Navigation###
LIQ_Treasury_Window = 'JavaWindow("title:=Treasury Navigation.*")'
LIQ_Treasury_Navigation = 'JavaWindow("title:=Treasury Navigation").JavaTree("tagname:=Drill down to make selection")'
LIQ_TreasuryNavigation_Window = 'JavaWindow("title:=Treasury Navigation")'

###Currency Exchange Rates###
LIQ_CurrencyExchangeRate_Window = 'JavaWindow("title:=Currency Exchange Rates.*")'
LIQ_CurrencyExchangeRate_Tree = 'JavaWindow("title:=Currency Exchange Rates.*").JavaTree("tagname:=Drill down to modify.*")'
LIQ_ExchangeRate_Field = 'JavaWindow("title:=Please Enter Currency.*").JavaEdit("to_class:=JavaEdit")'
LIQ_ExchangeRate_History_Button = 'JavaWindow("title:=Please Enter Currency.*").JavaButton("label:=History")'
LIQ_ExchangeRate_Events_Button = 'JavaWindow("title:=Please Enter Currency.*").JavaButton("label:=Events")'
LIQ_ExchangeRate_FundingDesk_List = 'JavaWindow("title:=Currency Exchange Rates.*").JavaList("tagname:=Funding Desk.*")'
LIQ_ExchangeRate_Currency_Label_AUD = 'JavaWindow("title:=Currency Exchange Rates.*").JavaStaticText("text:=AUD")'
LIQ_ExchangeRate_Fundingdesk_Label_AU = 'JavaWindow("title:=Please Enter Currency.*").JavaStaticText("text:=Australian.*")'
LIQ_ExchangeRate_FundingDesk_Currency_Label_AUD =   'JavaWindow("title:=Please Enter Currency.*").JavaStaticText("text:=AUD")'
LIQ_ExchangeRate_Currency_Label_USD =   'JavaWindow("title:=Please Enter Currency.*").JavaStaticText("text:=USD")'
# LIQ_ExchangeRate_Currency_Label_GBP = 'JavaWindow("title:=Please Enter Currency.*").JavaStaticText("text:=GBP")'
LIQ_ExchangeRate_Exit_Button = 'JavaWindow("title:=Currency Exchange Rates.*").JavaButton("label:=Exit.*")'
LIQ_ExchangeRate_Cancel_Button = 'JavaWindow("title:=Please Enter Currency.*").JavaButton("label:=Cancel.*")'

###Cross Currency History###
LIQ_CrossCurrency_Hist_Tree = 'JavaWindow("title:=Cross Currency.*").JavaTree("tagname:=Drill down to update.*")'
LIQ_CrossCurrency_Rate_Hist_Field = 'JavaWindow("title:=Set.*rate History").JavaEdit("to_class:=JavaEdit","editable:=1")'
LIQ_CrossCurrency_Start_Date_Hist_Field = 'JavaWindow("title:=Set.*rate History").JavaEdit("to_class:=JavaEdit","text:=.*-.*-.*")'
LIQ_CrossCurrency_Rate_Hist_Cancel_Button = 'JavaWindow("title:=Set.*rate History").JavaButton("label:=Cancel")'
LIQ_CrossCurrency_Hist_Cancel_Button = 'JavaWindow("title:=Cross Currency.*").JavaButton("label:=Cancel")'

###Currency Exchange Rates Events###
LIQ_CurrencyExchangeRate_Event_Tree = 'JavaWindow("title:=Currency Exchange Rate.*Event.*").JavaTree("tagname:=Exchange Rate.*")'
LIQ_CurrencyExchangeRate_Event_Exit_Button = 'JavaWindow("title:=Currency Exchange Rate.*Event.*").JavaButton("label:=Exit")'
LIQ_CurrencyExchangeRate_Event_FundingDesk_Label_AU   =   'JavaWindow("title:=Currency Exchange Rate.*Event.*").JavaStaticText("label:=Australian.*")'
LIQ_CurrencyExchangeRate_Event_FundingDesk_Currency_Label_AUD   =   'JavaWindow("title:=Currency Exchange Rate.*Event.*").JavaStaticText("label:=AUD.*")'
LIQ_CurrencyExchangeRate_Event_Currency_Label_AUD   =   'JavaWindow("title:=Currency Exchange Rate.*Event.*").JavaStaticText("label:=USD.*")'

###Funding Rates Events List###
LIQ_FundingRatesEvents_Exit_Button = 'JavaWindow("label:=Funding Rate Events List*").JavaButton("label:=Exit.*")'
LIQ_FundingRatesDetails_Exit_Button = 'JavaWindow("label:=Funding Rate Details*").JavaButton("label:=Exit.*")'