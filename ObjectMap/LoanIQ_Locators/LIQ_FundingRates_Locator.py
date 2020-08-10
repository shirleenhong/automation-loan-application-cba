
LIQ_Treasury_Icon = 'JavaWindow("title:=Fusion Loan IQ.*").JavaButton("index:=6")'
LIQ_TreasuryNav_Tree_Field = 'JavaWindow("title:=Treasury Navigation").JavaTree("tagname:=Drill down to make selection")'

LIQ_FundingRates_Window = 'JavaWindow("title:=Funding Rates.*")'
LIQ_BaseRate_Table_Row  = 'JavaWindow("title:=Funding Rates.*").JavaTree("attached text:=Drill down to view details.*")'
LIQ_FundingRate_Sort_Btn = 'JavaWindow("title:=Funding Rates").JavaButton("label:=Sort")'
LIQ_FundingRate_Exit_Btn = 'JavaWindow("title:=Funding Rate Details.*").JavaButton("label:=Exit")'
LIQ_FundingRate_Sort_Tree_Table = 'JavaWindow("title:=Column.*Sort.*").JavaTree("attached text:=Drill-down.*")'
LIQ_FundingRate_Sort_OK_Btn = 'JavaWindow("title:=Column.*Sort.*").JavaButton("label:=OK")'
LIQ_FundingRate_Sort_OKSave_Btn = 'JavaWindow("title:=Column.*Sort.*").JavaButton("label:=Save/OK")'

LIQ_FundingRatesDetails_Window = 'JavaWindow("title:=Funding Rate Details")'
LIQ_Base_Rate_AUD_Text = 'JavaWindow("title:=Funding Rate Details.*").JavaStaticText("attached text:=AUD Bank Bill Swap Rate.*")'

LIQ_FundingDesk_Text = 'JavaWindow("title:=Funding Rate Details.*").JavaStaticText("attached text:=Australian.*")'
LIQ_Repricing_Freq_Text = 'JavaWindow("title:=Funding Rate Details.*").JavaStaticText("attached text:=3.*")'
LIQ_Currency_AUD_Text = 'JavaWindow("title:=Funding Rate Details.*").JavaStaticText("attached text:=AUD","label:=AUD")'
LIQ_FundingRateDetails_Rate_Text = 'JavaWindow("title:=Funding Rate Details").JavaEdit("index:=1")'
#LIQ_DateEffective_Text = 'JavaWindow("title:=Funding Rate Details").JavaEdit("start_selection:=6","text:=18-Jun-2018","value:=18-Jun-2018")'
LIQ_DateEffective_Text = 'JavaWindow("title:=Funding Rate Details.*").JavaEdit("tagname:=Text","path:=Text;Shell;","text:=18-Jun-2018","value:=18-Jun-2018")'
LIQ_SpreadRate_Text = 'JavaWindow("Funding Rate Details.*").JavaEdit("attached text:=Spread:","text:=100.000000%","value:=100.000000%")'
LIQ_SpreadDateEffective_Text = 'JavaWindow("title:=Funding Rate Details.*").JavaEdit("attached text:=Effective Date:","text:=18-Jun-2018","value:=18-Jun-2018")'
LIQ_SpreadRate_Empty_0_Text = 'JavaWindow("title:=Funding Rate Details.*").JavaEdit("attached text:=Spread:.*","value:=0.000000%.*")'

LIQ_History_Button = 'JavaWindow("title:=Funding Rate Details.*").JavaButton("label:=History")'



LIQ_History_Window = 'JavaWindow("title:=Funding Rate.*History.*")'
# LIQ_History_Tree_Field = 'JavaWindow("title:=Funding Rate.*History.*").JavaTree("attached text:=Drill down to update")'
LIQ_History_Tree_Field = 'JavaWindow("title:=Funding Rate.*History.*").JavaTree("attached text:=Drill down to update.*","to_class:=JavaTree")'

# LIQ_FundHistory_Rate_TextField  = 'JavaWindow("title:=Please Enter New Rate").JavaEdit("attached text:=Rate:")'
LIQ_FundHistory_Rate_TextField  = 'JavaWindow("title:=Please.*").JavaEdit("to_class:=JavaEdit","editable:=1")'
LIQ_FundHistory_StartDate_Field = 'JavaWindow("title:=Please Enter New Rate.*").JavaEdit("tagname:=Text","value:=.*-.*-.*")'
LIQ_FundHistory_Cancel_NewRate_Btn = 'JavaWindow("title:=Please Enter New Rate.*").JavaButton("label:=Cancel")'
LIQ_FundHistory_Cancel_Btn  = 'JavaWindow("title:=Funding Rate.*History.*").JavaButton("label:=Cancel")'

LIQ_SpreadHistory_Btn = 'JavaWindow("title:=Funding Rate Details.*").JavaButton("attached text:=Spread.*History.*","label:=Spread.*History.*")'
LIQ_SpreadHistory_Window = 'JavaWindow("title:=Funding Rate.*Spread.*History.*")'
LIQ_SpreadHistory_Tree_Field = 'JavaWindow("title:=Funding Rate.*Spread.*History.*").JavaTree("attached text:=Drill down to update.*")'
LIQ_SpreadHistory_Cancel_Btn ='JavaWindow("title:=Funding Rate.*Spread.*History.*").JavaButton("label:=Cancel.*")'
LIQ_SpreadHistory_NewRate_Spread_Textfield ='JavaWindow("title:=Please Enter New.*Value.*").JavaEdit("attached text:=Spread:.*")'
LIQ_SpreadHistory_NewRate_Cancel_Btn = 'JavaWindow("title:=Please Enter New.*Value.*").JavaButton("label:=Cancel.*")'


LIQ_FundEvents_Btn = 'JavaWindow("title:=Funding Rate Details").JavaButton("label:=Events")'
LIQ_FundingEvents_Window = 'JavaWindow("title:=Funding Rate Events List.*")'
LIQ_FundingEventsList_Tree_Field = 'JavaWindow("title:=Funding Rate Events List").JavaTree("attached text:=Currency:")'
LIQ_FundingEvents_Exit_Btn = 'JavaWindow("title:=Funding Rate Events List").JavaButton("label:=Exit")'

