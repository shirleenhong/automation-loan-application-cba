###Loan Notebook - BBSY - Bid Loan###
LIQ_LoanNotebook_BbsyBidLoan_Window = 'JavaWindow("title:=.* Loan.*.*Active.*")'
LIQ_LoanNotebook_BbsyBidLoan_Tab = 'JavaWindow("title:=.* Loan.*.*Active.*").JavaTab("tagname:=TabFolder")'

###Loan Notebook - BBSY - Bid Loan###
LIQ_LoanNotebook_PendingItems_List = 'JavaWindow("title:=.* Loan.*.*Active.*").JavaTree("attached text:=Pending Transactions")'
LIQ_InactiveLoanNotebook_PendingItems_List = 'JavaWindow("title:=.* Loan.*.*Inactive.*").JavaTree("attached text:=Pending Transactions")'

###Breakfunding Fee Notebook###
LIQ_Breakfunding_Window = 'JavaWindow("title:=Break Cost .*")'
LIQ_Breakfunding_InquiryMode_Button = 'JavaWindow("title:=Break Cost .*").JavaButton("attached text:=Notebook in Inquiry Mode - F7")'
LIQ_Breakfunding_Pending_Window = 'JavaWindow("title:=Break Cost .* / Pending.*")'
LIQ_Breakfunding_Workflow_Tab= 'JavaWindow("title:=Break Cost .*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_Breakfunding_AwaitingSend_Tab= 'JavaWindow("title:=Break Cost .* / Awaiting Send To Approval.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_Breakfunding_AwaitingSend_Window = 'JavaWindow("title:=Break Cost .* / Awaiting Send To Approval.*","displayed:=1")'
LIQ_Breakfunding_AwaitingApproval_Window = 'JavaWindow("title:=Break Cost .* / Awaiting Approval.*","displayed:=1")'
LIQ_Breakfunding_AwaitingApproval_Tab= 'JavaWindow("title:=Break Cost .* / Awaiting Approval.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_Breakfunding_AwaitingRelease_Window = 'JavaWindow("title:=Break Cost .* / Awaiting Release.*","displayed:=1")'
LIQ_Breakfunding_AwaitingRelease_Tab= 'JavaWindow("title:=Break Cost .* / Awaiting Release.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_Breakfunding_Released_Window = 'JavaWindow("title:=Break Cost .* / Released.*","displayed:=1")'
LIQ_Breakfunding_FileSave_Menu = 'JavaWindow("title:=Break Cost .* / Released.*","displayed:=1").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_Breakfunding_FileExit_Menu = 'JavaWindow("title:=Break Cost .* / Released.*","displayed:=1").JavaMenu("label:=File").JavaMenu("label:=Exit")'
LIQ_Breakfunding_Events_JavaTree = 'JavaWindow("title:=Break Cost .* .*").JavaTree("attached text:=Select event to view details")'

LIQ_Breakfunding_Deal_Label = 'JavaWindow("title:=Break Cost .* / Pending.*").JavaStaticText("x:=166","y:=19")'
LIQ_Breakfunding_Facility_Label = 'JavaWindow("title:=Break Cost .* / Pending.*").JavaStaticText("x:=167","y:=56")'
LIQ_Breakfunding_Borrower_Label = 'JavaWindow("title:=Break Cost .* / Pending.*").JavaStaticText("x:=164","y:=88")'
LIQ_Breakfunding_LoanAlias_Label = 'JavaWindow("title:=Break Cost .* / Pending.*").JavaStaticText("x:=509","y:=58")'
LIQ_Breakfunding_PricingOption_Label = 'JavaWindow("title:=Break Cost .* / Pending.*").JavaStaticText("x:=528","y:=89")'
LIQ_Breakfunding_Currency_Label = 'JavaWindow("title:=Break Cost .* / Pending.*").JavaStaticText("x:=477","y:=122")'

###Breakfunding General tab###
LIQ_Breakfunding_HostBankFees_Text = 'JavaWindow("title:=Break Cost .*").JavaEdit("attached text:=Total Host Bank Fees:")'
LIQ_Breakfunding_BorrowerFees_Text = 'JavaWindow("title:=Break Cost .*").JavaEdit("attached text:=Total Borrower Fees:")'

###Breakfunding Fee - Workflow Tab###
LIQ_Breakfunding_WorkflowItems_List = 'JavaWindow("title:=Break Cost .*").JavaTree("attached text:=Drill down to perform Workflow item")'
LIQ_Breakfunding_WorkflowItems_AwaitingSend_List = 'JavaWindow("title:=Break Cost .* / Awaiting Send To Approval.*","displayed:=1").JavaTree("attached text:=Drill down to perform Workflow item")'
LIQ_Breakfunding_WorkflowItems_AwaitingApproval_List = 'JavaWindow("title:=Break Cost .* / Awaiting Approval.*","displayed:=1").JavaTree("attached text:=Drill down to perform Workflow item")'
LIQ_Breakfunding_WorkflowItems_AwaitingRelease_List = 'JavaWindow("title:=Break Cost .* / Awaiting Release.*","displayed:=1").JavaTree("attached text:=Drill down to perform Workflow item")'

###Notices Window###
LIQ_Notices_Lenders_Checkbox = 'JavaWindow("title:=Notices").JavaCheckbox("attached text:=Lenders")'
LIQ_Notices_BorrowerDepositor_Checkbox = 'JavaWindow("title:=Notices").JavaCheckbox("attached text:=Borrower / Depositor")'

###Breakfunding Event Fee Payment Group Window###
LIQ_BreakfundingEventFeePayment_Window = 'JavaWindow("title:=Breakfunding Event Fee Payment Group.*")'
LIQ_BreakfundingEventFeePayment_MarkAll_Button = 'JavaWindow("title:=Breakfunding Event Fee Payment Group.*").JavaButton("attached text:=Mark all")'
LIQ_BreakfundingEventFeePayment_Send_Button = 'JavaWindow("title:=Breakfunding Event Fee Payment Group.*").JavaButton("attached text:=Send")'
LIQ_BreakfundingEventFeePayment_Exit_Button = 'JavaWindow("title:=Breakfunding Event Fee Payment Group.*").JavaButton("attached text:=Exit")'

###Breakfunding reason window###
LIQ_BreakfundingReason_Window = 'JavaWindow("title:=Breakfunding reason")'
LIQ_BreakfundingReason_Reason_List = 'JavaWindow("title:=Breakfunding reason").JavaList("attached text:=Select reason for breakfunding:")'

###Shares for Break Cost Fee Window###
LIQ_SharesForBreakCostFee_Window = 'JavaWindow("title:=Shares for .*(AUD.*) Break Cost .* in Deal.*")'
LIQ_SharesForBreakCostFee_PrimaryAssignee_List = 'JavaWindow("title:=Shares for .*(AUD.*) Break Cost .* in Deal.*").JavaTree("attached text:=Drill Down for Primary/Assignment Detail")'
LIQ_SharesForBreakCostFee_LegalEntity_List = 'JavaWindow("title:=Shares for .*(AUD.*) Break Cost .* in Deal.*").JavaTree("attached text:=Drill Down for Portfolio Shares")'
LIQ_SharesForBreakCostFee_Ok_Button = 'JavaWindow("title:=Shares for .*(AUD.*) Break Cost .* in Deal.*").JavaButton("attached text:=OK")'

###Shares for Break Cost Fee - Servicing Group Share Window###
LIQ_ServicingGroupShare_Window = 'JavaWindow("title:=Servicing Group Share for.*")'
LIQ_ServicingGroupShare_Adjustment_Textfield = 'JavaWindow("title:=Servicing Group Share for.*").JavaEdit("attached text:=\+/- Adjustment:")'
LIQ_ServicingGroupShare_Amount_Textfield = 'JavaWindow("title:=Servicing Group Share for.*").JavaEdit("attached text:=Actual Amount.*")'
LIQ_ServicingGroupShare_Ok_Button = 'JavaWindow("title:=Servicing Group Share for.*").JavaButton("attached text:=OK")'

###Shares for Break Cost Fee - Host Bank Share Window###
LIQ_HostBankShares_Window = 'JavaWindow("title:=Host Bank Share for.*")'
LIQ_HostBankShares_AddPortfolioExpenseCode_Button = 'JavaWindow("title:=Host Bank Share for.*").JavaButton("attached text:=Add Portfolio/Expense Code")'
LIQ_HostBankShares_BranchPortfolioExpenseCode_List = 'JavaWindow("title:=Host Bank Share for.*").JavaTree("attached text:=Drill down to view/edit")'
LIQ_HostBankShares_Ok_Button = 'JavaWindow("title:=Host Bank Share for.*").JavaButton("attached text:=OK")'

###Shares for Break Cost Fee - Host Bank Share - Portfolio Selection Window###
LIQ_HostBankShares_PortfolioSelection_Window = 'JavaWindow("title:=Portfolio Selection For.*")'
LIQ_HostBankShares_PortfolioSelection_List = 'JavaWindow("title:=Portfolio Selection For.*").JavaTree("attached text:=Portfolio/Expense:")'
LIQ_HostBankShares_PortfolioSelection_Ok_Button = 'JavaWindow("title:=Portfolio Selection For.*").JavaButton("attached text:=OK")'

###Portfolio Share Edit Window###
LIQ_PortfolioShareEdit_Window = 'JavaWindow("title:=Portfolio Share Edit")'
LIQ_PortfolioShareEdit_Ok_Button = 'JavaWindow("title:=Portfolio Share Edit").JavaButton("attached text:=OK")'

###Cashflows for Break Cost Fee Window###
LIQ_BreakFundingCashflow_Window = 'JavaWindow("title:=Cashflows For Break Cost .*")'
LIQ_BreakFundingCashflow_Ok_Button = 'JavaWindow("title:=Cashflows For Break Cost .*").JavaButton("attached text:=OK")'
LIQ_BreakFunding_Cashflows_List = 'JavaWindow("title:=Cashflows For Break Cost .*").JavaTree("attached text:=Drill down to view/change details")'
LIQ_BreakFunding_Cashflows_DoIt_Button = 'JavaWindow("title:=Cashflows For Break Cost .*").JavaButton("label:=Set Selected Item To .*")'
LIQ_Breakfunding_Queries_GLEntries_Cashflow = 'JavaWindow("title:=Cashflows For Break Cost .*").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
LIQ_Breakfunding_Cashflow_HostBankCash_JavaEdit = 'JavaWindow("title:=Cashflows .* Break Cost .*").JavaStaticText("to_class:=JavaStaticText","index:=28")'

###Event Fee Payment Group Window###
LIQ_EventFeePaymentGroup_Window = 'JavaWindow("title:=Event Fee Payment Group.*","displayed:=1")'
LIQ_EventFeePaymentGroup_MarkAll_Button = 'JavaWindow("title:=Event Fee Payment Group.*","displayed:=1").JavaButton("attached text:=Mark all")'
LIQ_EventFeePaymentGroup_Send_Button = 'JavaWindow("title:=Event Fee Payment Group.*","displayed:=1").JavaButton("attached text:=Send")'
LIQ_EventFeePaymentGroup_Exit_Button = 'JavaWindow("title:=Event Fee Payment Group.*","displayed:=1").JavaButton("attached text:=Exit")'
LIQ_EventFeePaymentGroup_OptionsSend_Menu = 'JavaWindow("title:=Event Fee Payment .*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=Send")'
LIQ_EventFeePaymentGroup_NoticeID_Field = 'JavaWindow("title:=Event Fee Payment created by.*","displayed:=1").JavaEdit("attached text:=Notice ID:")'
LIQ_EventFeePaymentGroup_Customer_Field = 'JavaWindow("title:=Event Fee Payment created by.*","displayed:=1").JavaEdit("tagname:=Text","index:=2")'
LIQ_EventFeePaymentGroup_StaticText = 'JavaWindow("title:=Event Fee Payment created by.*","displayed:=1").JavaStaticText("labeled_containers_path:=Group:Status;","index:=7")'
LIQ_EventFeePaymentGroup_Refresh_Button = 'JavaWindow("title:=Event Fee Payment Group.*","displayed:=1").JavaButton("attached text:=Refresh")'
LIQ_EventFeePaymentGroup_UnmarkAll_Button = 'JavaWindow("title:=Event Fee Payment Group.*","displayed:=1").JavaButton("attached text:=Unmark all")'
LIQ_EventFeePayment_Items_JavaTree = 'JavaWindow("title:=Event Fee Payment Group.*","displayed:=1").JavaTree("attached text:=Drill down to mark notices")'
LIQ_EventFeePaymentGroup_GroupComment_Button = 'JavaWindow("title:=Event Fee Payment .*","displayed:=1").JavaButton("attached text:=Group comment.*")'

### GL Entries ###
LIQ_GL_Entries_Window = 'JavaWindow("title:=GL Entries For.*")'
LIQ_GL_Entries_JavaTree = 'JavaWindow("title:=GL Entries For.*").JavaTree("attached text:=Drill down to.*")'
LIQ_GL_Entries_Exit_Button = 'JavaWindow("title:=GL Entries For.*").JavaButton("attached text:=Exit.*")'
LIQ_GL_Entries_Refresh_Button = 'JavaWindow("title:=GL Entries For.*").JavaButton("attached text:=Refresh.*")'

