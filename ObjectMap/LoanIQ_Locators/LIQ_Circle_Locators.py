### Circle Notebook ###
LIQ_CircleNotebook_Options_Verify = 'JavaWindow("title:=.*Orig Primary.*").JavaMenu("label:=Options").JavaMenu("label:=Verify Buy/Sell Price")'
LIQ_CircleNotebook_File_Save = 'JavaWindow("title:=.*Orig Primary.*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_CircleNotebook_File_Exit = 'JavaWindow("title:=.*Orig Primary.*").JavaMenu("label:=File").JavaMenu("label:=Exit")'
LIQ_CircleNotebook_Tab = 'JavaWindow("title:=Closed Orig Primary.*").JavaTab("tagname:=TabFolder")'
LIQ_CircleNotebook_Window = 'JavaWindow("title:=Closed Orig Primary.*")'
LIQ_CircleNotebook_InquiryMode_Button = 'JavaWindow("title:=.*Orig Primary.*").JavaButton("attached text:=Notebook in Inquiry Mode - F7")'

### Circle Notebook - Summary Tab ###
LIQ_Circle_PortfolioAllocations_Button = 'JavaWindow("title:=.*Orig Primary.*").JavaObject("tagname:=Group","text:=Other Amendments").JavaButton("label:=Portfolio Allocations")'
LIQ_Circle_Amounts_JavaTree = 'JavaWindow("title:=.*Orig Primary.*").JavaTree("labeled_containers_path:=Tab:Summary;Group:Amounts;")'
LIQ_Circle_CounterParty_Button = 'JavaWindow("title:=.*Orig Primary.*").JavaButton("attached text:=Counterparty")'

### Circle Notebook - Facilities Tab ###
LIQ_Circle_Facilities_Tree = 'JavaWindow("title:=.*Orig Primary.*").JavaTree("labeled_containers_path:=Tab:Facilities;Group:Facilities;")'

### Circle Selection ###
LIQ_CircleSelection_Window= 'JavaWindow("title:=Circle Selection")'
LIQ_CircleSelection_NewExternaloption = 'JavaWindow("title:=Circle Selection").JavaRadioButton("attached text:=New External")'
LIQ_CircleSelection_Selloption = 'JavaWindow("title:=Circle Selection").JavaCheckBox("attached text:=Sell")'
LIQ_CircleSelection_LenderShareType = 'JavaWindow("title:=Circle Selection").JavaList("attached text:=Lender Share Type:")'
LIQ_CircleSelection_LenderButton = 'JavaWindow("title:=Circle Selection").JavaButton("label:=Lender:")'
LIQ_CircleSelection_BuyerLocation = 'JavaWindow("title:=Circle Selection").JavaList("labeled_containers_path:=Group:Buyer:;","attached text:=Location:")'
LIQ_CircleSelection_SellerLegalEntity = 'JavaWindow("title:=Circle Selection").JavaList("attached text:=Legal Entity:")'
LIQ_CircleSelection_SellerLocation = 'JavaWindow("title:=Circle Selection").JavaList("labeled_containers_path:=Group:Seller:;","attached text:=Location:")'
LIQ_CircleSelection_RiskBook_Button = 'JavaWindow("title:=Circle Selection").JavaButton("attached text:=Risk Book:")'
LIQ_CircleSelection_RiskBookDropdownList = 'JavaWindow("title:=Circle Selection").JavaList("tagname:=Combo","items count:=9")'
LIQ_CircleSelection_TransactionTypeDropdownList = 'JavaWindow("title:=Circle Selection").JavaList("attached text:=Transaction Type:")'
LIQ_CircleSelection_AssignFeeDecisionDropdownList = 'JavaWindow("title:=Circle Selection").JavaList("attached text:=Assignment Fee Decision:")'
LIQ_CircleSelection_OKButton = 'JavaWindow("title:=Circle Selection").JavaButton("label:=OK")'

LIQ_CircleSelection_NewInternalOption = 'JavaWindow("title:=Circle Selection").JavaRadioButton("attached text:=New Internal")'
LIQ_CircleSelection_NewExternalOption = 'JavaWindow("title:=Circle Selection").JavaRadioButton("attached text:=New External")'
LIQ_CircleSelection_BuyerLegalEntity='JavaWindow("title:=Circle Selection").JavaObject("text:=Buyer:").JavaList("attached text:=Legal Entity:")'
LIQ_CircleSelection_BuyerRiskBook='JavaWindow("title:=Circle Selection").JavaObject("text:=Buyer:").JavaButton("attached text:=Risk Book:")'
LIQ_CircleSelection_BuyerRiskBookDropdownList='JavaWindow("title:=Circle Selection").JavaObject("text:=Buyer:").JavaList("tagname:=Combo","index:=2")'

LIQ_CircleSelection_SellerLegalEntity='JavaWindow("title:=Circle Selection").JavaObject("text:=Seller:").JavaList("attached text:=Legal Entity:")'
LIQ_CircleSelection_SellerRiskBook='JavaWindow("title:=Circle Selection").JavaObject("text:=Seller:").JavaButton("attached text:=Risk Book:")'
LIQ_CircleSelection_SellerRiskBookDropdownList='JavaWindow("title:=Circle Selection").JavaObject("text:=Seller:").JavaList("tagname:=Combo","index:=2")'

LIQ_CircleSelection_Lender_Button = 'JavaWindow("title:=Circle Selection").JavaButton("attached text:=Lender:")'

### Lender Selection ###
LIQ_LenderSelect_SearchWindow = 'JavaWindow("title:=Lender Select.*")'
LIQ_LenderSelect_Search_Filter = 'JavaWindow("title:=Lender Select.*").JavaList("attached text:=Identify By:","Index:=0")'
LIQ_LenderSelect_Search_Inputfield = 'JavaWindow("title:=Lender Select.*").JavaEdit("tagname:=Text")'
LIQ_LenderSelect_OK_Button = 'JavaWindow("title:=Lender Select.*").JavaButton("attached text:=OK")'

###Outstanding Window###
LIQ_FundingMemo_Outstanding_Window = 'JavaWindow("title:=Outstandings, .*")'
LIQ_FundingMemo_FreezeAll_Button = 'JavaWindow("title:=Outstandings, .*").JavaButton("attached text:=Freeze All")'
LIQ_FundingMemo_JavaTree = 'JavaWindow("title:=Outstandings, .*").JavaTree("attached text:=Drill down to change frozen amount")'
LIQ_FundingMemo_Create = 'JavaWindow("title:=Outstandings, .*").JavaMenu("label:=Funding Memo").JavaMenu("label:=Create")'
LIQ_FundingMemo_Outstanding_OK_Button = 'JavaWindow("title:=Outstandings, .*").JavaButton("attached text:=OK")'
LIQ_FundingMemo_Window = 'JavaWindow("title:=Funding Memo for:.*")'
LIQ_FundingMemo_OK_Button = 'JavaWindow("title:=Funding Memo for:.*").JavaButton("attached text:=OK")'

###Outstanding Window - New Amount Window###
LIQ_FundingMemo_NewAmount_Window = 'JavaWindow("title:=Enter New Amount:")'
LIQ_FundingMemo_NewAmount_Window_AmountField = 'JavaWindow("title:=Enter New Amount:","displayed:=1").JavaEdit("tagname:=Text")'
LIQ_FundingMemo_NewAmount_Window_OKButton = 'JavaWindow("title:=Enter New Amount:").JavaButton("attached text:=OK")'

###Primaries List###
LIQ_PrimariesList_Window = 'JavaWindow("title:=Primaries List .*")'
LIQ_PrimariesList_JavaTree = 'JavaWindow("title:=Primaries List .*").JavaTree("attached text:=Drill down to see details")'

###Portfolio Allocations Window###
LIQ_Cirlce_PortfolioAllocation_Window = 'JavaWindow("text:=Portfolio allocations for .*")'
LIQ_PortfolioAllocation_Facilities_JavaTree = 'JavaWindow("text:=Portfolio allocations for .*").JavaTree("labeled_containers_path:=Group:Facilities;")'
LIQ_PortfolioAllocation_Exit_Button = 'JavaWindow("text:=Portfolio allocations for .*").JavaButton("attached text:=Exit")'
LIQ_PortfolioAllocation_PortfolioExpense_JavaTree = 'JavaWindow("text:=Portfolio allocations for .*").JavaTree("labeled_containers_path:=Group:Portfolio Allocations;")'

### Circle Notebook - Amts/Dates Tab ###
LIQ_Circle_Amounts_CurrentAmount = 'JavaWindow("title:=.*Orig Primary.*").JavaEdit("attached text:=Current:", "labeled_containers_path:=Tab:Amts/Dates;Group:Amounts;")'
LIQ_Circle_Amounts_Net_RadioButton = 'JavaWindow("title:=.*Orig Primary.*").JavaRadioButton("attached text:=Net")'

### Change Lender/Location ###
LIQ_Circle_ChangeLenderLocation_Window = 'JavaWindow("title:=.*Change Lender/Location*")'
LIQ_Circle_ChangeLenderLocation_Change_DropdownList = 'JavaWindow("title:=.*Change Lender/Location*").JavaList("attached text:=Change:")'
LIQ_Circle_ChangeLenderLocation_Lender_Button = 'JavaWindow("title:=.*Change Lender/Location*").JavaButton("attached text:=Lender:")'
LIQ_Circle_ChangeLenderLocation_OK_Button = 'JavaWindow("title:=.*Change Lender/Location*").JavaButton("attached text:=OK")'

### Circle Notebook - Events Tab ###
LIQ_Circle_EventsQueue_Button = 'JavaWindow("title:=.*Orig Primary.*").JavaButton("attached text:=Event Queue")'
LIQ_Circle_Events_Tree = 'JavaWindow("title:=.*Orig Primary.*").JavaTree("tagname:=Tree")'

###Circle Fee Decisions###
LIQ_CircleFeeDecisions_Window = 'JavaWindow("title:=Circle Fee Decisions:.*")'
LIQ_CircleFeeDecisions_Facilities_JavaTree = 'JavaWindow("title:=Circle Fee Decisions:.*").JavaTree("tagname:=Facilities.*")'
LIQ_CircleFeeDecisions_UpfrontFees_JavaTree = 'JavaWindow("title:=Circle Fee Decisions:.*").JavaTree("attached text:=Upfront Fees.*")'
LIQ_CircleFeeDecisions_OK_Button = 'JavaWindow("title:=Circle Fee Decisions:.*").JavaButton("attached text:=OK")'

###Fee Decision For Window###
LIQ_FeeDecisionFor_Window = 'JavaWindow("title:=Fee Decision for:.*")'
LIQ_FeeDecisionFor_Distribute_RadioButton = 'JavaWindow("title:=Fee Decision for:.*").JavaRadioButton("label:=Distribute")'
LIQ_FeeDecisionFor_Retain_Inputfield = 'JavaWindow("title:=Fee Decision for:.*").JavaEdit("x:=263","y:=154")'
LIQ_FeeDecisionFor_OK_Button = 'JavaWindow("title:=Fee Decision for:.*").JavaButton("attached text:=OK")'
