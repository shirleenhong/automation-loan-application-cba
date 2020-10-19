###Pending Participation Sell - Facilities Tab###
LIQ_PendingParticipationSell_Window = 'JavaWindow("title:=Pending Participation Sell.*")'
LIQ_PendingParticipationSell_PctofDeal_InputField = 'JavaWindow("title:=Pending Participation Sell.*").JavaEdit("attached text:=Pct of Deal:")'
LIQ_PendingParticipationSell_IntFeeDropdownList = 'JavaWindow("title:=Pending Participation Sell.*").JavaList("attached text:=Int/Fee.*")'
LIQ_PendingParticipationSell_SellAmount = 'JavaWindow("title:=Pending Participation Sell.*").JavaObject("text:=Aggregate Amounts").JavaEdit("index:=0")'
LIQ_PendingParticipationSell_DealAmount = 'JavaWindow("title:=Pending Participation Sell.*").JavaEdit("labeled_containers_path:=.*Aggregate Amounts.*","Index:=2")'
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
LIQ_PendingParticipation_File_OpenContraCircle = 'JavaWindow("title:=Pending Participation.*").JavaMenu("label:=File").JavaMenu("label:=Open Contra Circle")'

### Pending Participation Sell Workflow tab ###
LIQ_PendingParticipationSell_Workflow_JavaTree = 'JavaWindow("title:=Pending Participation Sell.*").JavaTree("attached text:=Drill down to perform.*")'

###Circle Fee Decisions###
LIQ_CircleFeeDecisions_Discount_Textfield = 'JavaWindow("title:=Circle Fee Decisions:.*").JavaEdit("index:=2")'
LIQ_CircleFeeDecisions_BuySellCalculated_Textfield = 'JavaWindow("title:=Circle Fee Decisions:.*").JavaEdit("index:=1")'
LIQ_CircleFeeDecisions_BuySell_Textfield = 'JavaWindow("title:=Circle Fee Decisions:.*").JavaEdit("index:=3")'
LIQ_CircleFeeDecisions_Facilities_JavaTreeIndex = 'JavaWindow("title:=Circle Fee Decisions:.*").JavaTree("tagname:=Facilities.*","Index:=1")'

###Pending Participation Buy###
LIQ_PendingParticipationBuy_Window = 'JavaWindow("title:=Pending Participation Buy.*")'
LIQ_PendingParticipationSell_BuyAmount = 'JavaWindow("title:=Pending Participation Buy.*").JavaObject("text:=Aggregate Amounts").JavaEdit("index:=0")'

### Pending Participation Buy Amts/Dates tab ###
LIQ_PendingParticipationBuy_Tab = 'JavaWindow("title:=Pending Participation Buy.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_PendingParticipationBuy_AmtsTab_CurrentAmount = 'JavaWindow("title:=Pending Participation Buy.*").JavaEdit("attached text:=Current:")'
LIQ_PendingParticipationBuy_AmtsTab_ExpectedClose = 'JavaWindow("title:=Pending Participation Buy.*").JavaEdit("attached text:=Expected Close:")'
LIQ_PendingParticipationBuy_AmtsDates_CircledAmount = 'JavaWindow("title:=Pending Participation Buy.*").JavaEdit("attached text:=Circled:")'

### Pending Participation Buy Workflow tab ###
LIQ_PendingParticipationBuyWorkflow_JavaTree = 'JavaWindow("title:=Pending Participation Buy.*").JavaTree("attached text:=Drill down to perform.*")'

###Awaiting Approval Assignment Sell - Workflow###
LIQ_AwatingApprovalParticipation_Workflow_JavaTree = 'JavaWindow("title:=Pending Participation.*").JavaTree("attached text:=Drill down to perform.*")'
LIQ_AwatingApprovalParticipation_OKButton = 'JavaWindow("title:=Approving.*").JavaButton("label:=OK")'

### Open Participation ###
LIQ_OpenPartipication_JavaWindow = 'JavaWindow("title:=Open.*")'
