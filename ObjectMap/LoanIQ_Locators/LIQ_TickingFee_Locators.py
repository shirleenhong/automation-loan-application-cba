### Ticking Fee Definition Window ###
LIQ_TickingFeeDefinition_Window = 'JavaWindow("title:=Ticking Fee Definition")'
LIQ_TickingFeeDefinition_DealProposedCmtAmt_Textfield = 'JavaWindow("title:=Ticking Fee Definition").JavaEdit("index:=0")'
LIQ_TickingFeeDefinition_EffectiveDate_Field = 'JavaWindow("title:=Ticking Fee Definition").JavaEdit("attached text:=Effective Date:")'
LIQ_TickingFeeDefinition_CurrentBalance_StaticText = 'JavaWindow("title:=Ticking Fee Definition").JavaStaticText("index:=6")'
LIQ_TickingFeeDefinition_RateBasis_Combobox = 'JavaWindow("title:=Ticking Fee Definition").JavaList("index:=0")'
LIQ_TickingFeeDefinition_ExpiryDate_Field = 'JavaWindow("title:=Ticking Fee Definition").JavaEdit("attached text:=Expiry Date:")'
LIQ_TickingFeeDefinition_Currency_StaticText = 'JavaWindow("title:=Ticking Fee Definition").JavaStaticText("index:=7")'
LIQ_TickingFeeDefinition_ProjectedAmtToToday_Text = 'JavaWindow("title:=Ticking Fee Definition").JavaObject("tagname:=Group","text:=Projected Amount").JavaEdit("index:=0")'
LIQ_TickingFeeDefinition_ProjectedAmtToClose_Text = 'JavaWindow("title:=Ticking Fee Definition").JavaObject("tagname:=Group","text:=Projected Amount").JavaEdit("index:=1")'
LIQ_TickingFeeDefinition_FeePaidBy_StaticText = 'JavaWindow("title:=Ticking Fee Definition").JavaStaticText("index:=8")'
LIQ_TickingFeeDefinition_ServicingGroup_StaticText = 'JavaWindow("title:=Ticking Fee Definition").JavaStaticText("index:=9")' 
LIQ_TickingFeeDefinition_Ok_Button = 'JavaWindow("title:=Ticking Fee Definition").JavaButton("label:=Ok")'
LIQ_TickingFeeDefinition_Cancel_Button = 'JavaWindow("title:=Ticking Fee Definition").JavaButton("label:=Cancel")' 
LIQ_TickingFeeDefinition_TickingFeeAmount_Text = 'JavaWindow("title:=Ticking Fee Definition").JavaObject("tagname:=Group","text:=Amounts").JavaEdit("index:=0")'

### Ticking Fee Notebook - General Tab ###
LIQ_TickingFeeNotebook_Window = 'JavaWindow("title:=Ticking Fee.*")'
LIQ_TickingFeeNotebook_Tab = 'JavaWindow("title:=Ticking Fee.*").JavaTab("index:=0")'
LIQ_TickingFeeNotebook_DealName_Text = 'JavaWindow("title:=Ticking Fee.*").JavaStaticText("index:=5")'
LIQ_TickingFeeNotebook_DealProposedCmt_Text = 'JavaWindow("title:=Ticking Fee.*").JavaEdit("attached text:=Deal Proposed Commitment:")'
LIQ_TickingFeeNotebook_TickingFeeAmount_Text = 'JavaWindow("title:=Ticking Fee.*").JavaEdit("attached text:=Ticking Fee Amount:")'
LIQ_TickingFeeNotebook_DealBorrowerName_Text = 'JavaWindow("title:=Ticking Fee.*").JavaStaticText("index:=6")'
LIQ_TickingFeeNotebook_RequestedAmount_Textfield = 'JavaWindow("title:=Ticking Fee.*").JavaEdit("attached text:=Requested Amount:")'
LIQ_TickingFeeNotebook_EffectiveDate_Field = 'JavaWindow("title:=Ticking Fee.*").JavaEdit("attached text:=Effective Date:")'
LIQ_TickingFeeNotebook_Comment_Textfield = 'JavaWindow("title:=Ticking Fee.*").JavaObject("tagname:=Group","text:=Comment").JavaEdit("tagname:=Text")'

### Ticking Fee Notebook - Menu ###
LIQ_TickingFeeNotebook_Menu_Save = 'JavaWindow("title:=Ticking Fee.*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_TickingFeeNotebook_Menu_Exit = 'JavaWindow("title:=Ticking Fee.*").JavaMenu("label:=File").JavaMenu("label:=Exit")'
LIQ_TickingFeeNotebook_Menu_Cashflow = 'JavaWindow("title:=Ticking Fee.*")JavaMenu("label:=Options").JavaMenu("label:=Cashflow")'
LIQ_TickingFeeNotebook_Menu_GLEntries = 'JavaWindow("title:=Ticking Fee.*").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
LIQ_TickingFeeNotebook_Menu_DealNotebook = 'JavaWindow("title:=Ticking Fee.*").JavaMenu("label:=Options").JavaMenu("label:=Deal Notebook")'

### Ticking Fee Notebook - Workflow Tab ###
LIQ_TickingFeeNotebook_Tree = 'JavaWindow("title:=Ticking Fee.*").JavaTree("attached text:=Drill down to perform Workflow item")'

### Ticking Fee Notebook - Events Tab ###
LIQ_TickingFeeNotebook_Events_Tree = 'JavaWindow("title:=Ticking Fee.*").JavaTree("attached text:=Select event to view details")'
LIQ_TickingFeeNotebook_Events_Comment = 'JavaWindow("title:=Ticking Fee.*").JavaObject("tagname:=Group","text:=Event Details").JavaEdit("attached text:=Comment:")'

### Ticking Fee Notebook - Pending Tab ###
LIQ_TickingFeeNotebook_PendingTransactions_Tree = 'JavaWindow("title:=Ticking Fee.*").JavaTree("attached text:=Pending Transactions")'
LIQ_TickingFeeNotebook_PendingTransactions_EmptyTree = 'JavaWindow("title:=Ticking Fee.*").JavaTree("attached text:=Pending Transactions","items count:=0")'

### Ticking Fee Notebook - Intent Notices ###
LIQ_PaymentGroupCreatedBy_Window = 'JavaWindow("title:=.*Payment Group created by.*","displayed:=1")'
LIQ_PaymentGroupCreatedBy_Tree = 'JavaWindow("title:=.*Payment Group created by.*","displayed:=1").JavaTree("attached text:=Drill down to mark notices")'
LIQ_PaymentGroupCreatedBy_EditHighlightedNotices_Button = 'JavaWindow("title:=.*Payment Group created by.*","displayed:=1").JavaButton("label:=Edit Highlighted Notices")'
LIQ_PaymentGroupCreatedBy_Exit_Button = 'JavaWindow("title:=.*Payment Group created by.*","displayed:=1").JavaButton("label:=Exit")'
LIQ_PaymentGroupCreatedBy_File_Preview = 'JavaWindow("title:=.*Payment Group created by.*","displayed:=1").JavaMenu("label:=File").JavaMenu("label:=Preview")'

LIQ_PaymentCreatedBy_Window = 'JavaWindow("title:=.*Payment created by.*")'
LIQ_PaymentCreatedBy_NoticeMethod_Combobox = 'JavaWindow("title:=.*Payment created by.*").JavaList("attached text:=Notice Method:")'
LIQ_PaymentCreatedBy_File_Preview = 'JavaWindow("title:=.*Payment created by.*").JavaMenu("label:=File").JavaMenu("label:=Preview")'
LIQ_PaymentCreatedBy_File_Exit = 'JavaWindow("title:=.*Payment created by.*").JavaMenu("label:=File").JavaMenu("label:=Exit")'

