###Pending Participation Sell - Facilities Tab###
LIQ_PendingParticipationSell_Window = 'JavaWindow("title:=Pending Participation Sell.*")'
LIQ_PendingParticipationSell_PctofDeal_InputField = 'JavaWindow("title:=Pending Participation Sell.*").JavaEdit("attached text:=Pct of Deal:")'
LIQ_PendingParticipationSell_IntFeeDropdownList = 'JavaWindow("title:=Pending Participation Sell.*").JavaList("attached text:=Int/Fee.*")'
LIQ_PendingParticipationSell_SellAmount_Textfield = 'JavaWindow("title:=Pending Participation Sell.*").JavaEdit("attached text:=Seller.*","index:=0")'
LIQ_PendingParticipationSell_DealAmount_Textfield = 'JavaWindow("title:=Pending Participation Sell.*").JavaEdit("labeled_containers_path:=.*Aggregate Amounts.*","Index:=2")'
LIQ_PendingParticipationSell_ProRate_Button = 'JavaWindow("title:=Pending Participation Sell.*").JavaButton("attached text:=Pro Rate")'
LIQ_PendingParticipationSell_FacilityList = 'JavaWindow("title:=Pending Participation Sell.*").JavaTree("attached text:=Drill down to change details.*")'

### Pending Participation Sell Amts/Dates tab ###
LIQ_PendingParticipationSell_Tab = 'JavaWindow("title:=Pending Participation Sell.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_PendingParticipationSell_AmtsTab_CurrentAmount = 'JavaWindow("title:=Pending Participation Sell.*").JavaEdit("attached text:=Current:")'
LIQ_PendingParticipationSell_AmtsTab_ExpectedClose = 'JavaWindow("title:=Pending Participation Sell.*").JavaEdit("attached text:=Expected Close:")'
LIQ_PendingParticipationSell_AmtsDates_CircledAmount = 'JavaWindow("title:=Pending Participation Sell.*").JavaEdit("attached text:=Circled:")'

### Pending Participation Sell Contacts tab ###
LIQ_PendingParticipationSell_AddContacts_Button = 'JavaWindow("title:=Pending Participation Sell.*").JavaButton("attached text:=Add Contacts")'

### Pending Participation Sell Menu ###
LIQ_PendingParticipationSell_Maintenance_FeeDecisions = 'JavaWindow("title:=Pending Participation Sell.*").JavaMenu("label:=Maintenance").JavaMenu("label:=.*Fee Decisions.*")'
LIQ_PendingParticipation_File_OpenContraCircle = 'JavaWindow("title:=Pending Participation.*").JavaMenu("label:=File").JavaMenu("label:=Open Contra Circle.*")'

### Pending Participation Sell Workflow tab ###
LIQ_PendingParticipationSell_Workflow_JavaTree = 'JavaWindow("title:=Pending Participation Sell.*").JavaTree("attached text:=Drill down to perform.*")'

###Circle Fee Decisions###
LIQ_CircleFeeDecisions_Discount_Textfield = 'JavaWindow("title:=Circle Fee Decisions:.*").JavaEdit("index:=2")'
LIQ_CircleFeeDecisions_BuySellCalculated_Textfield = 'JavaWindow("title:=Circle Fee Decisions:.*").JavaEdit("index:=1")'
LIQ_CircleFeeDecisions_BuySell_Textfield = 'JavaWindow("title:=Circle Fee Decisions:.*").JavaEdit("index:=3")'
LIQ_CircleFeeDecisions_Facilities_JavaTreeIndex = 'JavaWindow("title:=Circle Fee Decisions:.*").JavaTree("tagname:=Facilities.*","Index:=1")'

###Pending Participation Buy###
LIQ_PendingParticipationBuy_Window = 'JavaWindow("title:=Pending Participation Buy.*")'
LIQ_PendingParticipationBuy_BuyAmount_Textfield = 'JavaWindow("title:=Pending Participation Buy.*").JavaEdit("attached text:=Buyer.*","index:=0")'
LIQ_PendingParticipationBuy_Tab = 'JavaWindow("title:=Pending Participation Buy.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_PendingParticipation_Maintenance_FeeDecisions = 'JavaWindow("title:=Pending Participation Buy.*").JavaMenu("label:=Maintenance").JavaMenu("label:=.*Fee Decisions.*")'
LIQ_PendingParticipationBuyWorkflow_JavaTree = 'JavaWindow("title:=Pending Participation Buy.*").JavaTree("attached text:=Drill down to perform.*")'
LIQ_PendingParticipation_OKButton = 'JavaWindow("title:=Approving.*").JavaButton("label:=OK")'

### Pending Participation Buy Amts/Dates tab ###
LIQ_PendingParticipationBuy_AmtsTab_ExpectedClose = 'JavaWindow("title:=Pending Participation Buy.*").JavaEdit("attached text:=Expected Close:")'
LIQ_PendingParticipationBuy_AmtsDates_CircledAmount_Textfield = 'JavaWindow("title:=Pending Participation Buy.*").JavaEdit(tagname:=Text","Index:=0")'
LIQ_PendingParticipationBuy_AmtsTab_CurrentAmount_Textfield = 'JavaWindow("title:=Pending Participation Buy.*").JavaEdit("attached text:=Current:")'
LIQ_PendingParticipationBuy_AmtsTab_CircledAmount_Textfield = 'JavaWindow("title:=Pending Participation Buy.*").JavaEdit("tagname:=Text","Index:=0")'

###Awaiting Approval Participation - Workflow###
LIQ_AwaitingApprovalParticipation_Window = 'JavaWindow("title:=Awaiting Approval Participation.*")'
LIQ_AwaitingApprovalParticipation_Workflow_JavaTree = 'JavaWindow("title:=Awaiting Approval Participation.*").JavaTree("attached text:=Drill down to perform.*")'
LIQ_AwaitingApprovalParticipation_OKButton = 'JavaWindow("title:=Approving.*").JavaButton("label:=OK")'
LIQ_AwaitingApprovalParticipation_File_OpenContraCircle = 'JavaWindow("title:=Awaiting Approval Participation.*").JavaMenu("label:=File").JavaMenu("label:=Open Contra Circle.*")'
LIQ_AwaitingApprovalParticipation_BuyAmount_Textfield = 'JavaWindow("title:=Awaiting Approval Participation.*").JavaEdit("attached text:=Buyer.*","index:=0")'
LIQ_AwaitingApprovalParticipation_Tab = 'JavaWindow("title:=Awaiting Approval Participation.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_AwaitingApprovalParticipation_AmtsTab_CurrentAmount_Textfield = 'JavaWindow("title:=Awaiting Approval Participation.*").JavaEdit("attached text:=Current:")'
LIQ_AwaitingApprovalParticipation_AmtsTab_CircledAmount_Textfield = 'JavaWindow("title:=Awaiting Approval Participation.*").JavaEdit("tagname:=Text","Index:=0")'
LIQ_AwaitingApprovalParticipation_Maintenance_FeeDecisions = 'JavaWindow("title:=Awaiting Approval Participation.*").JavaMenu("label:=Maintenance").JavaMenu("label:=.*Fee Decisions.*")'
LIQ_AwaitingApprovalParticipationWorkflow_JavaTree = 'JavaWindow("title:=Awaiting Approval Participation.*").JavaTree("attached text:=Drill down to perform.*")'

### Open Participation Window ###
LIQ_OpenParticipation_JavaWindow = 'JavaWindow("title:=Open Participation.*")'
LIQ_OpenParticipation_JavaWindow_Tab = 'JavaWindow("title:=Open Participation.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_OpenParticipation_Workflow_Javatree = 'JavaWindow("title:=Open Participation.*").JavaTree("attached text:=Drill down to perform.*")'
LIQ_OpenParticipation_File_OpenContraCircle = 'JavaWindow("title:=Open Participation.*").JavaMenu("label:=File").JavaMenu("label:=Open Contra Circle.*")'

### Portfolio Allocations Window ###
LIQ_Participation_PortfolioAllocations_Facilities_List = 'JavaWindow("title:=Portfolio allocations for.*").JavaTree("labeled_containers_path:=Group:Facilities;")'
LIQ_Participation_PortfolioAllocations_AddPortfolioExpenseCode_Button = 'JavaWindow("title:=Portfolio allocations.*").JavaButton("attached text:=Add Portfolio/Expense Code")'
LIQ_Participation_PortfolioAllocations_Window = 'JavaWindow("title:=Portfolio Allocation.*")'
LIQ_Participation_PortfolioAllocations_PortfolioExpenseCodes_JavaTree = 'JavaWindow("title:=Portfolio Allocation.*").JavaTree("tagname:=Portfolio/Expense Codes.*")'
LIQ_Participation_PortfolioAllocations_Branch_List = 'JavaWindow("title:=Portfolio Allocation.*").JavaList("attached text:=Branch.*")'
LIQ_Participation_PortfolioAllocations_OK_Button = 'JavaWindow("title:=Portfolio Allocation.*").JavaButton("attached text:=OK.*")'
LIQ_Participation_PortfolioAllocationsFor_OK_Button = 'JavaWindow("title:=Portfolio allocations for.*").JavaButton("attached text:=OK.*")'

### Participation Settlement Window ###
LIQ_Participation_SendToSettlementApproval_Window = 'JavaWindow("title:=Open/Awaiting Settlement Approval.*")'
LIQ_Participation_SendToSettlementApproval_Tab = 'JavaWindow("title:=Open/Awaiting Settlement Approval.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_Participation_SendToSettlementApproval_Workflow_JavaTree = 'JavaWindow("title:=Open/Awaiting Settlement Approval.*").JavaTree("attached text:=Drill down to perform.*")'
LIQ_Participation_SettlementApproved_Window = 'JavaWindow("title:=Open/Settlement Approved.*")'
LIQ_Participation_SettlementApproved_Tab = 'JavaWindow("title:=Open/Settlement Approved.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_Participation_SettlementApproved_Workflow_Javatree = 'JavaWindow("title:=Open/Settlement Approved.*").JavaTree("attached text:=Drill down to perform.*")'

### Participation Close Window ###
LIQ_Participation_Closing_Window = 'JavaWindow("title:=Closing.*")'
LIQ_Participation_Closing_OKButton = 'JavaWindow("title:=Closing.*").JavaButton("label:=OK")'
LIQ_Participation_Closing_CircledTradeDate = 'JavaWindow("title:=Closing .*").JavaEdit("index:=1")'
LIQ_Participation_Closing_EffectiveDate = 'JavaWindow("title:=Closing .*").JavaEdit("index:=0")'
LIQ_Participation_ClosedApproved_Window = 'JavaWindow("title:=Closed.*")'
LIQ_Participation_Closed_File_OpenContraCircle = 'JavaWindow("title:=Closed.*").JavaMenu("label:=File").JavaMenu("label:=Open Contra Circle.*")'
LIQ_Participation_Closed_Queries_GLEntries = 'JavaWindow("title:=Closed.*","displayed:=1").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'

### Participation Oustanding Window ###
LIQ_Participation_Outstanding_Window = 'JavaWindow("title:=Outstandings.*", "displayed:=1")'
LIQ_Participation_Outstanding_FreezeAll = 'JavaWindow("title:=Outstandings.*").JavaButton("attached text:=Freeze All")'    
LIQ_Participation_Outstanding_OKButton = 'JavaWindow("title:=Outstandings.*").JavaButton("attached text:=OK")'
LIQ_Participation_Outstanding_FundingMemo_Create = 'JavaWindow("title:=Outstandings, .*").JavaMenu("label:=Funding Memo").JavaMenu("label:=Create")'

### Participation FundingMemo Window ###
LIQ_Participation_Funding_Window = 'JavaWindow("title:=Funding Memo for.*")'
LIQ_Participation_Funding_Ok_Button = 'JavaWindow("title:=Funding Memo for.*").JavaButton("attached text:=OK.*")'

### Generic Participation Objects ###
LIQ_Participation_Window = 'JavaWindow("title:=.*Participation.*")'
LIQ_Participation_Tab = 'JavaWindow("title:=.*Participation.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_Participation_Workflow_JavaTree = 'JavaWindow("title:=.*Participation.*").JavaTree("attached text:=Drill down to perform.*")'
LIQ_Participation_PctofDeal_Textbox = 'JavaWindow("title:=.*Participation.*").JavaEdit("attached text:=Pct of Deal:")'
LIQ_Participation_IntFeeDropdownList = 'JavaWindow("title:=.*Participation.*").JavaList("attached text:=Int/Fee.*")'
LIQ_Participation_ProRate_Button = 'JavaWindow("title:=.*Participation.*").JavaButton("attached text:=Pro Rate")'
LIQ_Participation_AmtsTab_CurrentAmount = 'JavaWindow("title:=.*Participation.*").JavaEdit("attached text:=Current:")'
LIQ_Participation_AmtsTab_ExpectedClose = 'JavaWindow("title:=.*Participation.*").JavaEdit("attached text:=Expected Close:")'
LIQ_Participation_DealAmount_Textfield = 'JavaWindow("title:=.*Participation.*").JavaEdit("labeled_containers_path:=.*Aggregate Amounts.*","Index:=2")'
LIQ_Participation_PctofDeal_InputField = 'JavaWindow("title:=.*Participation.*").JavaEdit("attached text:=Pct of Deal:")'
LIQ_Participation_BuyAmount_Textfield = 'JavaWindow("title:=.*Participation.*").JavaEdit("attached text:=Buyer.*","index:=0")'
LIQ_Participation_FacilityList = 'JavaWindow("title:=.*Participation.*").JavaTree("attached text:=Drill down to change details.*")'