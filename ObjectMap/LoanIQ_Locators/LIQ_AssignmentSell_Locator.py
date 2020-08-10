##Pending Assignment Sell
LIQ_PendingAssignmentSell_Window = 'JavaWindow("title:=Pending Assignment Sell.*")'
LIQ_PendingAssignmentSell_Tab = 'JavaWindow("title:=Pending.*").JavaTab("Tagname:=TabFolder")'
LIQ_AssignmentSell_MaintenanceEventFees_Menu = 'JavaWindow("title:=.*Assignment .*").JavaMenu("label:=Maintenance").JavaMenu("label:=Event Fees")'
  
###Pending Assignment Sell - Facilities Tab###
LIQ_AssignmentSell_Window = 'JavaWindow("title:=.* Assignment Sell.*")'
LIQ_AssignmentSell_Tab = 'JavaWindow("title:=.*Assignment.*").JavaTab("tagname:=TabFolder")'
LIQ_PendingAssignmentSell_PctofDeal_InputField = 'JavaWindow("title:=Pending Assignment Sell.*").JavaEdit("attached text:=Pct of Deal:")'
LIQ_PendingAssignmentSell_CurrentDealAmount = 'JavaWindow("title:=Pending Assignment Sell.*").JavaEdit("x:=230","y:=17")'
LIQ_PendingAssignmentSell_SellAmount = 'JavaWindow("title:=Pending Assignment Sell.*").JavaEdit("x:=230","y:=47")'
LIQ_PendingAssignmentSell_IntFeeDropdownList = 'JavaWindow("title:=Pending Assignment Sell.*").JavaList("attached text:=Int/Fee.*")'
LIQ_PendingAssignmentSell_PaidByDropdownList = 'JavaWindow("title:=Pending Assignment Sell.*").JavaList("attached text:=Paid By:.*")'
LIQ_PendingAssignmentSell_ProRate_Button = 'JavaWindow("title:=Pending Assignment Sell.*").JavaButton("attached text:=Pro Rate")'
LIQ_PendingAssignmentSell_FacilityList = 'JavaWindow("title:=Pending Assignment Sell.*").JavaTree("attached text:=Drill down to change details.*")'
  
###Pending Assignment Sell - Facility Window### 
LIQ_PendingAssignmentSell_Facility_Pricing_BuyandSellPrice_Percentage ='JavaWindow("title:=Facility:.*").JavaEdit("x:=289","y:=194")'
LIQ_PendingAssignmentSell_Facility_PercentofGlobal_Percentage = 'JavaWindow("title:=Facility:.*").JavaEdit("attached text:=Accrual")'
LIQ_PendingAssignmentSell_Facility_Amount = 'JavaWindow("title:=Facility:.*").JavaEdit("attached text:=Amount:")'
LIQ_PendingAssignmentSell_OKButton = 'JavaWindow("title:=Facility:.*").JavaButton("label:=OK")'
  
###Pending Assignment Sell -  Amts/Dates Tab###
LIQ_PendingAssignmentSell_AmtsDates_CurrentAmount = 'JavaWindow("title:=Pending Assignment Sell.*").JavaEdit("attached text:=Current:")'
LIQ_PendingAssignmentSell_AmtsDates_ExpectedCloseDate = 'JavaWindow("title:=Pending Assignment Sell.*").JavaEdit("attached text:=Expected Close:")'
   
###Pending Assignment Sell - Contacts Tab### 
LIQ_PendingAssignmentSell_ContactTab_AddContacts_Button = 'JavaWindow("title:=Pending.*").JavaButton("attached text:=Add Contacts")'
LIQ_AssignmentSell_ContactSelection = 'JavaWindow("title:=Contact Selection")'
LIQ_AssignmentSell_ContactSelection_LenderList = 'JavaWindow("title:=Contact Selection").JavaList("attached text:=Lenders:")'
LIQ_AssignmentSell_ContactSelection_LocationList = 'JavaWindow("title:=Contact Selection").JavaList("attached text:=Locations:")'
LIQ_AssignmentSell_Contacts_Button = 'JavaWindow("title:=Contact Selection").JavaButton("attached text:=Contacts")'
LIQ_AssignmentSell_ServicingGroups_JavaTree = 'JavaWindow("title:=.*Assignment .*").JavaTree("attached text:=Drill down for details")'
LIQ_AssignmentSell_ServicingGroups_Button = 'JavaWindow("title:=.*Assignment .*").JavaButton("attached text:=Servicing Groups")'
LIQ_AssignmentSell_ServicingGroupsSelection_Window = 'JavaWindow("title:=Servicing Group Selection")'
LIQ_AssignmentSell_ServicingGroupsSelection_LenderList = 'JavaWindow("title:=Servicing Group Selection").JavaList("attached text:=Lenders:")'
LIQ_AssignmentSell_ServicingGroupsSelection_LocationList = 'JavaWindow("title:=Servicing Group Selection").JavaList("attached text:=Locations:")'
LIQ_AssignmentSell_ServicingGroupsSelection_SG_Button = 'JavaWindow("title:=Servicing Group Selection").JavaButton("attached text:=Servicing Groups")'
LIQ_AssignmentSell_ServicingGroupsSelection_Exit_Button = 'JavaWindow("title:=Servicing Group Selection").JavaButton("attached text:=Exit")'
LIQ_AssignmentSell_ServicingGroupsSelectionFor_Window = 'JavaWindow("title:=Servicing Groups For.*")'
LIQ_AssignmentSell_ServicingGroupsSelectionFor_Ok_Button = 'JavaWindow("title:=Servicing Groups For.*").JavaButton("attached text:=OK.*")'
LIQ_AssignmentSell_FileSave = 'JavaWindow("title:=.*Assignment .*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_PendingAssignmentSell_Facilities_JavaTree = 'JavaWindow("title:=Portfolio allocations for.*").JavaTree("labeled_containers_path:=Group:Facilities;.*")'
LIQ_PendingAssignmentSell_ContactTab_ContactName_JavaTree = 'JavaWindow("title:=Pending.*").JavaTree("developer name:=.*${ContactName}.*","labeled_containers_path:=Tab:Contacts.*")'

###Awaiting Approval Assignment Sell###
LIQ_AwaitingApprovalAssignmentSell_Tab = 'JavaWindow("title:=Awaiting.*").JavaTab("Tagname:=TabFolder")'
LIQ_AwaitingApprovalAssignmentSell_OKButton = 'JavaWindow("title:=Approving.*").JavaButton("label:=OK")'
LIQ_ApprovingAssignment_Window = 'JavaWindow("title:=Approving Assignment Sell.*")'
LIQ_ApprovingAssignment_CircledTradeDate = 'JavaWindow("title:=Approving Assignment Sell.*").JavaEdit("tagname:=Text")'
LIQ_ApprovingAssignment_QualifiedBuyerforCircle_Checkbox = 'JavaWindow("title:=Approving Assignment Sell.*").JavaCheckbox("attached text:=Qualified Buyer For Circle")'
LIQ_ApprovingAssignment_OK_Button = 'JavaWindow("title:=Approving Assignment Sell.*").JavaButton("attached text:=OK")'
LIQ_AssignmentSell_Funding_Window = 'JavaWindow("title:=Funding Memo for.*")'
LIQ_AssignmentSell_Funding_Ok_Button = 'JavaWindow("title:=Funding Memo for.*").JavaButton("attached text:=OK.*")'
LIQ_AssignmentSell_Outstandings_Window = 'JavaWindow("title:=Outstandings.*")' 
LIQ_AssignmentSell_Outstandings_OkButton = 'JavaWindow("title:=Outstandings.*", "displayed:=1").JavaButton("attached text:=OK.*")' 
LIQ_AssignmentSell_Outstanding_Window = 'JavaWindow("title:=Outstandings.*", "displayed:=1")'
LIQ_AssignmentSell_Outstanding_Create = 'JavaWindow("title:=Outstandings.*", "displayed:=1").JavaMenu("label:=Funding Memo").JavaMenu("label:=Create")' 
###Open Assignment Sell###
LIQ_OpenAssignmentSell_Tab = 'JavaWindow("title:=Open.*").JavaTab("Tagname:=TabFolder")'
LIQ_OpenAssignmentSell_Workflow_JavaTree = 'JavaWindow("title:=Open.*").JavaTree("attached text:=Drill down to perform.*")'
LIQ_OpenAssignmentSell_JavaWindow = 'JavaWindow("title:=Open.*")'

###Open/Awaiting Settlement Approval Assignment Sell###
LIQ_OpenAwaitingSettlementApprovalAssignmentSell_Tab = 'JavaWindow("title:=Open/Awaiting Settlement Approval.*").JavaTab("Tagname:=TabFolder")'
LIQ_OpenAwatingAssignmentSell_Workflow_JavaTree = 'JavaWindow("title:=Open/Awaiting Settlement Approval.*").JavaTree("attached text:=Drill down to perform.*")'

###Open/Settlement Approved Assignment Sell###
LIQ_OpenSettlementApprovedAssignmentSell_Tab = 'JavaWindow("title:=Open/Settlement Approved.*").JavaTab("Tagname:=TabFolder")'      
LIQ_OpenSettlementApprovedAssignmentSell_Workflow_JavaTree = 'JavaWindow("title:=Open/Settlement Approved.*").JavaTree("attached text:=Drill down to perform.*")'
LIQ_OpenSettlementApprovedAssignmentSell_JavaWindow = 'JavaWindow("title:=Open/Settlement Approved.*")'

###Closed Assignment Sell###
LIQ_Closing_Window = 'JavaWindow("title:=Closing .*","displayed:=1")'
LIQ_ClosedApprovedAssignmentSell_Window = 'JavaWindow("title:=Closed.*")'
LIQ_ClosingAssignment_CircledTradeDate = 'JavaWindow("title:=Closing .*").JavaEdit("index:=1")'
LIQ_ClosingAssignment_EffectiveDate = 'JavaWindow("title:=Closing .*").JavaEdit("index:=0")'
LIQ_ClosedApprovedAssignmentSell_OKButton = 'JavaWindow("title:=Closing.*").JavaButton("label:=OK")'
LIQ_ClosedAssignmentSell_Workflow_JavaTree = 'JavaWindow("title:=Closed Assignment Sell.*").JavaTree("attached text:=Drill down to perform.*")'
  
###Assignment Sell - Workflow###
AssignmentSell_Workflow_JavaTree = 'JavaWindow("title:=Pending Assignment Sell.*").JavaTree("attached text:=Drill down to perform.*")'
AssignmentSell_Workflow_NoItems = 'JavaWindow("title:=.* Assignment Sell.*").JavaTree("attached text:=Drill down to perform.*","items count:=0")'
OpenAssignmentSell_Workflow_JavaTree = 'JavaWindow("title:=Open Assignment Sell.*").JavaTree("attached text:=Drill down to perform Workflow item.*")'
LIQ_AssignmentSell_AwaitingApproval = 'JavaWindow("title:=Awaiting Approval Assignment Sell.*")'
LIQ_AssignmentSell_Approval = 'JavaWindow("title:=Open Assignment Sell.*")'
LIQ_AssignmentSell_SendToSettlementApproval = 'JavaWindow("title:=Open/Awaiting Settlement Approval.*")'
LIQ_AssignmentSell_SettlementApproval = 'JavaWindow("title:=Open/Settlement Approved Assignment.*")'
LIQ_AssignmentSell_Close = 'JavaWindow("title:=Closed Assignment Sell.*")' 
  
###Awaiting Approval Assignment Sell - Workflow###
AwatingApprovalAssignmentSell_Workflow_JavaTree = 'JavaWindow("title:=Awaiting Approval Assignment Sell.*").JavaTree("attached text:=Drill down to perform.*")'
LIQ_PrimaryCircles_TradeDate_OK_Button = 'JavaWindow("title:=Set Circled/Legal Trade.*").JavaButton("attached text:=OK")'
  
###Assignment Sell - Portfolio allocations###
AssignmentSell_PortfolioAllocations_List = 'JavaWindow("title:=Portfolio allocations for.*").JavaTree("attached text:=Drill down to change allocations for.*")'
AssignmentSell_PortfolioAllocations_OKButton = 'JavaWindow("title:=Portfolio allocations for.*").JavaButton("attached text:=OK")'
AssignmentSell_PortfolioAllocations_AllocatedAmount = 'JavaWindow("title:=Allocation").JavaEdit("attached text:=Allocate:")'
AssignmentSell_Allocations_OKButton = 'JavaWindow("title:=Allocation").JavaButton("attached text:=OK")'
AssignmentSell_PortfolioAllocations_Facilities_List = 'JavaWindow("title:=Portfolio allocations for.*").JavaTree("labeled_containers_path:=Group:Facilities;")'

###Deal Notebook###
ContrGross_Value = 'JavaWindow("title:=Deal Notebook - Closed Deal .*").JavaStaticText("x:=162","y:=81")'

###Assignment Sell - Event Fees###
LIQ_AssignmentSell_EventFees_Window = 'JavaWindow("title:=Event Fees For.*","displayed:=1")'
LIQ_AssignmentSell_EventFees_FlowDownFeeFromDeal_Button = 'JavaWindow("title:=Event Fees For.*","displayed:=1").JavaButton("attached text:=Flow Down Fee From Deal")'
LIQ_AssignmentSell_EventFees_OK_Button = 'JavaWindow("title:=Event Fees For.*","displayed:=1").JavaButton("attached text:=OK")'