###Deal Primaries List Window###
LIQ_PrimariesList_Window = 'JavaWindow("title:=Primaries List -.*")'
LIQ_PrimariesList_AddButton = 'JavaWindow("title:=Primaries List.*").JavaButton("attached text:=Add")'
LIQ_PrimariesList_JavaTree = 'JavaWindow("title:=Primaries List.*").JavaTree("tagname:=Drill down to see details")'
LIQ_PrimariesList_Exit_Button = 'JavaWindow("title:=Primaries List.*").JavaButton("label:=Exit")'

###Deal Primaries List Window###
LIQ_PrimariesList_Window = 'JavaWindow("title:=Primaries List -.*")'
LIQ_PrimariesList_AddButton = 'JavaWindow("title:=Primaries List.*").JavaButton("attached text:=Add")'
LIQ_PrimariesList_JavaTree = 'JavaWindow("title:=Primaries List.*").JavaTree("tagname:=Drill down to see details")'

###Deal Primaries List - Create Primary Window###
LIQ_CreatePrimary_Lender_TextField = 'JavaWindow("title:=Create Primary").JavaObject("text:=Buyer:").JavaEdit("attached text:=Amendment Number:")'
LIQ_CreatePrimary_Location_ComboBox = 'JavaWindow("title:=Create Primary").Javalist("attached text:=Location:")'
LIQ_CreatePrimary_RiskBook_Combobox = 'JavaWindow("title:=Create Primary").JavaList("tagname:=Combo","Index:=3")'
LIQ_CreatePrimary_OK_Button = 'JavaWindow("title:=Create Primary.*").JavaButton("attached text:=OK")'
LIQ_CreatePrimary_Lender_Button = 'JavaWindow("title:=Create Primary.*").JavaButton("attached text:=Lender:")'
LIQ_CreatePrimary_Riskbook_Button = 'JavaWindow("title:=Create Primary.*").JavaButton("attached text:=Risk Book:")'
LIQ_CreatePrimary_Sell_Checkbox = 'JavaWindow("title:=Create Primary.*").JavaCheckBox("attached text:=Sell")'
LIQ_CreatePrimary_Riskbook_JavaTree = 'JavaWindow("title:=Expense Codes By Risk Book").JavaTree("tagname:=Drill down to select a risk book")'
LIQ_CreatePrimary_Riskbook_OK_Button = 'JavaWindow("title:=Expense Codes By Risk Book").JavaButton("attached text:=OK")'
LIQ_RiskBook_ComboBox = 'JavaWindow("title:=Circle Selection").JavaList("items count:=9")'
LIQ_CreatePrimary_Deal_TextField = 'JavaWindow("title:=Create Primary").JavaEdit("attached text:=Amendment Number:","text:=${Deal_Name}")'
LIQ_CreatePrimary_TransactionType_SelectBox = 'JavaWindow("title:=Create Primary").JavaList("attached text:=Transaction.*")'
LIQ_CreatePrimary_Window = 'JavaWindow("title:=Create Primary")'
LIQ_CreatePrimary_TicketModeOnly_Checkbox = 'JavaWindow("title:=Create Primary.*").JavaCheckBox("attached text:=Ticket Mode Only")'

### Deal Orig Primaries - Search###
LIQ_LenderSelect_Textfield = 'JavaWindow("title:=Lender Select.*").JavaEdit("tagname:=Text")'
LIQ_LenderSelect_Search_Button = 'JavaWindow("title:=Lender Select.*").JavaButton("label:=Search")'
LIQ_LenderList_OK_Button = 'JavaWindow("title:=Lender Select.*").JavaWindow("title:=Lender List By Short.*").JavaButton("label:=OK")'

###Pending Orig Primaries###
LIQ_OrigPrimaries_PctOfDeal_Textfield = 'JavaWindow("title:=.*Orig Primary.*").JavaEdit("index:=3")'
LIQ_OrigPrimaries_SellAmount_Textfield = 'JavaWindow("title:=.*Orig Primary.*").JavaEdit("index:=2")'
LIQ_OrigPrimaries_ProRate_Button = 'JavaWindow("title:=Pending Orig Primary.*").JavaButton("attached text:=Pro Rate")'
LIQ_OrigPrimaries_PricingComment_Button = 'JavaWindow("title:=.*Orig Primary.*").JavaButton("attached text:=Pricing Comment")'
LIQ_OrigPrimaries_Tab = 'JavaWindow("title:=.*Orig Primary:.*").JavaTab("Tagname:=TabFolder")'
LIQ_OrigPrimaries_Window = 'JavaWindow("title:=.*Orig Primary:.*")'
LIQ_OrigPrimaries_CurrentDealAmount_Textfield = 'JavaWindow("title:=.*Orig Primary.*").JavaEdit("index:=4")'
LIQ_OrigPrimariesy_Facilities_JavaTree = 'JavaWindow("title:=.*Orig Primary.*").JavaTree("attached text:=.*Drill down to change details.*","Index:=1")'

###Pending Orig Primaries - Pro Rate###
LIQ_ProRate_BuySellPrice_Textfield = 'JavaWindow("title:=Pro-Rate Transaction Amount.*").JavaEdit("attached text:=Buy/Sell Price:")'
LIQ_ProRate_BuySellPrice_Ok_Button = 'JavaWindow("title:=Pro-Rate Transaction Amount.*").JavaButton("label:=OK")'

###Pending Orig Primaries - Comment Edit###
LIQ_PricingComment_CommentEdit_Window = 'JavaWindow("title:=Comment Edit.*")'
LIQ_PricingComment_CommentEdit_Comment_Textfield = 'JavaWindow("title:=Comment Edit.*").JavaEdit("attached text:=Comment:")'
LIQ_PricingComment_CommentEdit_Ok_Button = 'JavaWindow("title:=Comment Edit.*").JavaButton("label:=OK")'
LIQ_PricingComment_CommentEdit_Subject_Textfield = 'JavaWindow("title:=Comment Edit.*").JavaEdit("attached text:=Subject:")'

###Pending Orig Primaries - Contacts###
LIQ_Contact_AddContacts_Button = 'JavaWindow("title:=.*Orig Primary.*").JavaButton("attached text:=Add Contacts")'
LIQ_Contact_DeleteContact_Button = 'JavaWindow("title:=.*Orig Primary.*").JavaButton("attached text:=Delete Contact")'
LIQ_Contact_JavaTree = 'JavaWindow("title:=.*Orig Primary.*").JavaTree("tagname:=Tree")'
LIQ_Contact_ServicingGroups_Button = 'JavaWindow("title:=.*Orig Primary.*").JavaButton("attached text:=Servicing Groups")'
LIQ_Contact_DeleteServicingGroup_Button = 'JavaWindow("title:=.*Orig Primary.*").JavaButton("attached text:=Delete Servicing Group")'
LIQ_Contact_ServicingGroup_JavaTree = 'JavaWindow("title:=.*Orig Primary.*").JavaTree("tagname:=Drill down for details")'

###Pending Orig Primaries - Circle Contacts###
LIQ_CircleContacts_SelectAll_Button = 'JavaWindow("title:=Circle Contacts For.*").JavaButton("attached text:=Select All")'
LIQ_CircleContacts_Available_JavaTree = 'JavaWindow("title:=Circle Contacts For.*").JavaTree("attached text:=Available")'
LIQ_CircleContacts_OK_Button = 'JavaWindow("title:=Circle Contacts For.*").JavaButton("attached text:=OK")'
LIQ_CircleContacts_Available_List = 'JavaWindow("title:=Circle Contacts For.*").JavaTree("attached text:=Available")'

###Pending Orig Primaries - Contact Selection###
LIQ_ContactSelection_Contacts_Button = 'JavaWindow("title:=Contact Selection.*").JavaButton("attached text:=Contacts")'
LIQ_ContactSelection_Exit_Button = 'JavaWindow("title:=Contact Selection.*").JavaButton("attached text:=Exit")'

###Pending Orig Primaries - Servicing Group Selection###
LIQ_ServicingGroupSelection_ServicingGroups_Button = 'JavaWindow("title:=Servicing Group Selection.*").JavaButton("attached text:=Servicing Groups")'
LIQ_ServicingGroupSelection_Exit_Button = 'JavaWindow("title:=Servicing Group Selection.*").JavaButton("attached text:=Exit")'

###Pending Orig Primaries - Servicing Group For###
LIQ_ServicingGroupFor_OK_Button = 'JavaWindow("title:=Servicing Groups For.*").JavaButton("attached text:=OK")'
LIQ_ServicingGroupsFor_ServiceGroup_JavaTree = 'JavaWindow("title:=Servicing Groups For.*").JavaObject("tagname:=Group","text:=Servicing Groups").JavaTree("tagname:=Drill Down To Change Group Members")'

###Pending Orig Primaries - Workflow###
LIQ_PrimaryCircle_Workflow_JavaTree = 'JavaWindow("title:=.*Orig Primary.*").JavaTree("attached text:=Drill down to perform.*")'
LIQ_PrimaryCircles_TradeDate_TextField = 'JavaWindow("title:=Set Circled/Legal Trade.*").JavaEdit("attached text:=Circled/Legal Trade Date:")'
LIQ_PrimaryCircles_TradeDate_OK_Button = 'JavaWindow("title:=Set Circled/Legal Trade.*").JavaButton("attached text:=OK")'
LIQ_PrimaryCircle_Workflow_JavaTree_NoItems= 'JavaWindow("title:=.*Approved Orig Primary.*").JavaTree("items count:= 0")'
LIQ_PrimaryCircles_TradeDate_OK_Button = 'JavaWindow("title:=Set Circled/Legal Trade.*").JavaButton("attached text:=OK")'
LIQ_PrimaryCircle_OrigPrimary_Window = 'JavaWindow("title:=.*Settlement Approved.*Orig Primary.*")'

###Pending Orig Primaries - Portfolio allocations###
LIQ_PortfolioAllocations_Facility_JavaTree = 'JavaWindow("title:=Portfolio allocations.*").JavaTree("tagname:=Tree","index:=1")'
LIQ_PortfolioAllocations_AddPortfolio_Button = 'JavaWindow("title:=Portfolio allocations for.*").JavaButton("label:=Add Portfolio/Expense Code")'
LIQ_Portfolio_OK_Button = 'JavaWindow("title:=Portfolio allocations.*").JavaButton("attached text:=OK")'
LIQ_PortfolioAllocations_OK_Button = 'JavaWindow("title:=Portfolio allocations.*").JavaButton("attached text:=OK")'
LIQ_PortfolioAllocations_Branch_List = 'JavaWindow("title:=Portfolio allocations.*").JavaList("attached text:=Branch:")'
LIQ_PortfolioAllocationsFor_Window = 'JavaWindow("title:=Portfolio allocations for.*")'
LIQ_PortfolioAllocations_PortfolioAllocations_JavaTree = 'JavaWindow("title:=Portfolio allocations.*").JavaObject("tagname:=Group","text:=Portfolio Allocations").JavaTree("attached text:=Drill down to.*")'

###Pending Orig Primaries - Portfolio allocation###
LIQ_Portfolio_BranchDropdown = 'JavaWindow("title:=Portfolio Allocation").JavaList("attached text:=Branch:")'
LIQ_Portfolio_JavaTree = 'JavaWindow("title:=Portfolio Allocation").JavaTree("attached text:=Portfolio/Expense Codes:")'
LIQ_PortfolioAllocation_OK_Button = 'JavaWindow("title:=Portfolio Allocation").JavaButton("attached text:=OK")'
LIQ_PortfolioAllocation_Window = 'JavaWindow("title:=Portfolio Allocation")'
LIQ_PortfolioAllocation_ExpirationDate_TextField = 'JavaWindow("title:=Portfolio Allocation").JavaEdit("attached text:=Expiration Date:")'

LIQ_PortfolioAllocation_Allocation_TextField = 'JavaWindow("title:=Portfolio Allocation").JavaEdit("attached text:=Allocation:")'

LIQ_SendToSettelement_No_Button = 'JavaWindow("title:=.*Orig Primary.*").JavaWindow("label:=Confirmation.*").JavaButton("attached text:=No")'
LIQ_PrimaryWorkflow_OpenAwaitingSettlement_Window = 'JavaWindow("title:=Open/Awaiting Settlement Approval Orig Primary:.*")'
LIQ_PrimaryWorkflow_Window = 'JavaWindow("title:=Open/Settlement Approved.*")'
LIQ_CircleNotebook_Options_Verify = 'JavaWindow("title:=.*Orig Primary.*").JavaMenu("label:=Options").JavaMenu("label:=Verify Buy/Sell Price")'
LIQ_CircleNotebook_File_Save = 'JavaWindow("title:=.*Orig Primary.*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_CircleNotebook_File_Exit = 'JavaWindow("title:=.*Orig Primary.*").JavaMenu("label:=File").JavaMenu("label:=Exit")'

LIQ_ServicingGroupsFor_ServiceGroup_JavaTree = 'JavaWindow("title:=Servicing Groups For.*").JavaObject("tagname:=Group","text:=Servicing Groups").JavaTree("tagname:=Drill Down To Change Group Members")'

###Orig Primaries Facility###
LIQ_PrimariesFacility_Window = 'JavaWindow("title:=Facility:.*")'
LIQ_PrimariesFacility_Amount_Textfield = 'JavaWindow("title:=Facility:.*").JavaEdit("attached text:=Amount:")'
LIQ_PrimariesFacility_OK_Button = 'JavaWindow("title:=Facility:.*").JavaButton("attached text:=OK")'
LIQ_PrimariesFacility_Price_Textfield = 'JavaWindow("title:=Facility:.*").JavaEdit("index:=1")'

LIQ_OrigPrimary_PortfolioAllocation = 'JavaWindow("title:=.*Orig Primary.*").JavaMenu("label:=Maintenance").JavaMenu("label:=Portfolio Allocations")'

###Orig Primaries Maintenance###
LIQ_OrigPrimary_Maintenance_FeeDecisions = 'JavaWindow("title:=.*Orig Primary.*").JavaMenu("label:=Maintenance").JavaMenu("label:=.*Fee Decisions.*")'