### Cashflows ###
LIQ_Cashflows_Window = 'JavaWindow("title:=Cashflows For.*","displayed:=1")'
LIQ_Cashflows_Tree = 'JavaWindow("title:=Cashflows For.*","displayed:=1").JavaTree("attached text:=Drill down to view/change details")'
LIQ_Cashflows_SetSelectedItemTo_Button = 'JavaWindow("title:=Cashflows For.*","displayed:=1").JavaButton("label:=Set Selected Item To.*")'
LIQ_Cashflows_OK_Button = 'JavaWindow("title:=Cashflows For.*","displayed:=1").JavaButton("label:=OK")'
LIQ_Cashflows_Queries_GLEntries = 'JavaWindow("title:=Cashflows For.*","displayed:=1").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
LIQ_Cashflows_Options_SendAllToSPAP = 'JavaWindow("title:=Cashflows For.*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=Send All To SPAP")'
LIQ_Cashflows_Options_SetAllToDoIt = 'JavaWindow("title:=Cashflows For.*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=Set All To .*Do It.*")'
LIQ_Cashflows_HostBankCashNet_Text = 'JavaWindow("title:=Cashflows .*").JavaStaticText("to_class:=JavaStaticText","x:=245","y:=58")'
LIQ_Cashflows_MarkSelectedItemForRelease_Button = 'JavaWindow("title:=Cashflows.*","displayed:=1").JavaButton("attached text:=Mark Selected Item For Release")'
LIQ_Cashflow_Options_MarkAllRelease = 'JavaWindow("title:=Cashflows .*").JavaMenu("label:=Options").JavaMenu("label:=Mark All To Release")'
LIQ_Cashflows_DetailsForCashflow_Window = 'JavaWindow("title:=Details for Cashflow.*")'
LIQ_Cashflows_DetailsForCashflow_SelectRI_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("label:=Select Remittance Instructions")'
LIQ_Cashflows_DetailsForCashflow_ViewRI_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("label:=View Remittance Instructions")'
LIQ_Cashflows_DetailsForCashflow_OK_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("label:=OK")'
LIQ_Cashflows_DetailsForCashflow_Cancel_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("label:=Cancel")'
LIQ_Cashflows_DetailsForCashflow_PaymentMethod_StaticText = 'JavaWindow("title:=Details for Cashflow.*").JavaObject("tagname:=Group","text:=Remittance Instruction Detail").JavaStaticText("index:=1")'
LIQ_Cashflows_DetailsforCashflow_IMTDetail_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("attached text:=IMT Detail")'
LIQ_Cashflows_DetailsforCashflow_Exit_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("attached text:=Exit")'
 
LIQ_Cashflows_ChooseRemittanceInstructions_Window = 'JavaWindow("title:=Choose Remittance Instructions")'
LIQ_Cashflows_ChooseRemittanceInstructions_Tree = 'JavaWindow("title:=Choose Remittance Instructions").JavaTree("attached text:=Drill down to view details")'
LIQ_Cashflows_ChooseRemittanceInstructions_OK_Button = 'JavaWindow("title:=Choose Remittance Instructions").JavaButton("label:=OK")'
LIQ_Cashflows_ChooseRemittanceInstructions_Cancel_Button = 'JavaWindow("title:=Choose Remittance Instructions").JavaButton("label:=Cancel")'
LIQ_Cashflows_ChooseRemittanceInstructions_CustomInstructions_Checkbox = 'JavaWindow("title:=Choose Remittance Instructions").JavaCheckBox("text:=&Custom Instructions")'
LIQ_Cashflows_ChooseRemittanceInstructions_Details_Button = 'JavaWindow("title:=Choose Remittance Instructions").JavaButton("text:=&Details")'

LIQ_Cashflows_RemittanceInstructionsDetail_Window = 'JavaWindow("title:=Remittance Instructions Detail.*")'

LIQ_Cashflows_UpdateInformation_CopyRID_Button = 'JavaWindow("title:=Update Information.*").JavaButton("attached text:=Copy RID To Clipboard")'

### GL Entries ###
LIQ_GL_Entries_Window = 'JavaWindow("title:=GL Entries For.*")'
LIQ_GL_Entries_JavaTree = 'JavaWindow("title:=GL Entries For.*").JavaTree("attached text:=Drill down to.*")'
LIQ_GL_Entries_Exit_Button = 'JavaWindow("title:=GL Entries For.*").JavaButton("attached text:=Exit.*")'
LIQ_GL_Entries_Refresh_Button = 'JavaWindow("title:=GL Entries For.*").JavaButton("attached text:=Refresh.*")'

# #Loan Repricing Cashflow Locators
# LIQ_LoanRepricing_Cashflow_Window = 'JavaWindow("title:=Cashflows For Loan Repricing.*")'
# LIQ_LoanRepricing_Cashflows_List  = 'JavaWindow("title:=Cashflows For Loan Repricing.*").JavaTree("attached text:=Drill down to view/change details")'
# LIQ_LoanRepricing_Cashflows_DoIt_Button = 'JavaWindow("title:=Cashflows For Loan Repricing.*").JavaButton("label:=Set Selected Item To .*")'
# LIQ_LoanRepricing_Cashflows_OK_Button = 'JavaWindow("title:=Cashflows For Loan Repricing.*").JavaButton("label:=OK")'
# LIQ_LoanRepricing_Cashflows_MarkSelectedItemForRelease_Button = 'JavaWindow("title:=Cashflows For Loan Repricing.*").JavaButton("attached text:=Mark Selected Item For Release")'
# LIQ_LoanRepricing_Cashflow_HostBankCash_JavaEdit = 'JavaWindow("title:=Cashflows For Loan Repricing.*").JavaStaticText("to_class:=JavaStaticText","x:=270","y:=58")'
# LIQ_LoanRepricing_Queries_GLEntries_Cashflow = 'JavaWindow("title:=Cashflows For Loan Repricing.*").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
# 
# 
# ###Create Cashflow Loan Repricing###
# LIQ_Cashflow_Loan_Window = 'JavaWindow("title:=Cashflow for Loan Repricing.*")'
# LIQ_Cashflow_Loan_Tab = 'JavaWindow("title:=Cashflow for Loan Repricing.*").JavaTab("tagname:=TabFolder")'
# 
# ###Issuance Payment Cashflow Window##
# LIQ_SBLCIssuancePayment_CashFlow_Window = 'JavaWindow("title:=Cashflows For Bank Guarantee/Letter of Credit.*Issuance Fee Payment.*")'
# LIQ_SBLCIssuancePayment_CashFlow_DrillDowntoView_CashflowList = 'JavaWindow("title:=Cashflows For Bank Guarantee/Letter of Credit.*Issuance Fee Payment.*").JavaTree("attached text:=Drill down to view/change details")'
# LIQ_SBLCIssuancePayment_Cashflow_OK_Button = 'JavaWindow("title:=Cashflows For Bank Guarantee/Letter of Credit.*Issuance Fee Payment.*").JavaButton("attached text:=OK")'
# LIQ_SBLCIssuancePayment_Cashflow_SettoDoIt_Button = 'JavaWindow("title:=Cashflows For Bank Guarantee/Letter of Credit.*Issuance Fee Payment.*").JavaButton("attached text:=Set Selected Item To.*Do It.*")'
# LIQ_SBLCIssuancePayment_Cashflow_RemittanceDesc_DDA_StaticText = 'JavaWindow("title:=Cashflows For Bank Guarantee/Letter of Credit.*Issuance Fee Payment.*").JavaStaticText("attached text:=.*DDA.*")'
# LIQ_SBLCIssuancePayment_Cashflow_RemittanceDesc_IMT_StaticText = 'JavaWindow("title:=Cashflows For Bank Guarantee/Letter of Credit.*Issuance Fee Payment.*").JavaStaticText("attached text:=.*IMT.*")'
# LIQ_SBLCIssuancePayment_Cashflow_RemittanceDesc_None_StaticText = 'JavaWindow("title:=Cashflows For Bank Guarantee/Letter of Credit.*Issuance Fee Payment.*").JavaStaticText("attached text:=None")'
# LIQ_SBLCIssuancePayment_ChooseRemittance_Window = 'JavaWindow("title:=Choose Remittance Instructions")'
# LIQ_SBLCIssuancePayment_ChooseRemittance_List = 'JavaWindow("title:=Choose Remittance Instructions").JavaTree("attached text:=Drill down to view details")'
# LIQ_SBLCIssuancePayment_ChooseRemittance_OK_Button = 'JavaWindow("title:=Choose Remittance Instructions").JavaButton("attached text:=OK")'
# LIQ_SBLCIssuancePayment_Cashflow_SettoDoIt_Undo_Button = 'JavaWindow("title:=Cashflows For Bank Guarantee/Letter of Credit.*Issuance Fee Payment.*").JavaButton("label:=.*Undo It.*")' 
# 
# ###SBLC Drawpayment###
# LIQ_SBLCDrawdown_Tab = 'JavaWindow("title:=Bank Guarantee/Letter of Credit.*Draw Payment.*").JavaTab("tagname:=TabFolder")'
# LIQ_SBLCDrawdown_WorkflowAction = 'JavaWindow("title:=Bank Guarantee/Letter of Credit.*Draw Payment.*").JavaTree("attached text:=Drill down to perform Workflow item")'
# 
# LIQ_SBLCDrawdown_CashFlow_Window = 'JavaWindow("title:=Cashflows For Bank Guarantee/Letter of Credit.*Draw Payment.*")'
# LIQ_SBLCDrawdown_CashFlow_DrillDowntoView_CashflowList = 'JavaWindow("title:=Cashflows For Bank Guarantee/Letter of Credit.*Draw Payment.*").JavaTree("attached text:=Drill down to view/change details")'
# LIQ_SBLCDrawdown_Cashflow_OK_Button = 'JavaWindow("title:=Cashflows For Bank Guarantee/Letter of Credit.*Draw Payment.*").JavaButton("attached text:=OK")'
# LIQ_SBLCDrawdown_Cashflow_RemittanceDesc_DDA_StaticText = 'JavaWindow("title:=Cashflows For Bank Guarantee/Letter of Credit.*Draw Payment.*").JavaStaticText("attached text:=DDA1")'
# LIQ_SBLCDrawdown_Cashflow_RemittanceDesc_IMT_StaticText = 'JavaWindow("title:=Cashflows For Bank Guarantee/Letter of Credit.*Draw Payment.*").JavaStaticText("attached text:=IMT1")'
# 
# ###Create Cashflow Drawdown##
# LIQ_Drawdown_Window = 'JavaWindow("title:=.* Drawdown .*")'
# LIQ_Drawdown_Tab = 'JavaWindow("title:=.* Drawdown .*").JavaTab("tagname:=TabFolder")'
# LIQ_Drawdown_Options_Cashflow = 'JavaWindow("title:=.* Drawdown .*").JavaMenu("label:=Options").JavaMenu("label:=Cashflow")'
#LIQ_Drawdown_WorkflowItems = 'JavaWindow("title:=.* Drawdown.*").JavaTree("attached text:=Drill down to perform Workflow item")'
# LIQ_Drawdown_Cashflows_Window = 'JavaWindow("title:=Cashflows .* Drawdown.*")'
# LIQ_Drawdown_Cashflows_List  = 'JavaWindow("title:=Cashflows .* Drawdown.*").JavaTree("attached text:=Drill down to view/change details")'
# LIQ_Drawdown_Cashflows_OK_Button = 'JavaWindow("title:=Cashflows .* Drawdown.*").JavaButton("attached text:=OK")'
# LIQ_Drawdown_Cashflows_Cancel_Button = 'JavaWindow("title:=Cashflows .* Drawdown.*").JavaButton("attached text:=Cancel")'
# LIQ_Drawdown_Cashflows_RemittanceDesc_None_StaticText = 'JavaWindow("title:=Cashflows .* Drawdown.*").JavaStaticText("attached text:=None")'
# LIQ_Drawdown_Cashflows_RemittanceDesc_RTGS_StaticText = 'JavaWindow("title:=Cashflows .* Drawdown.*").JavaStaticText("attached text:=.*RTGS.*")'
# LIQ_Drawdown_Cashflows_RemittanceDesc_IMT_StaticText = 'JavaWindow("title:=Cashflows .* Drawdown.*").JavaStaticText("attached text:=.*IMT.*")'
# LIQ_Drawdown_Cashflows_DetailsforCashflow_Window = 'JavaWindow("title:=Details for Cashflow.*")'
# LIQ_Drawdown_Cashflows_DetailsforCashflow_SelectRI_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("attached text:=Select Remittance Instructions")'
# LIQ_Drawdown_Cashflows_DetailsforCashflow_ViewRI_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("attached text:=View Remittance Instructions")'
# LIQ_Drawdown_Cashflows_DetailsforCashflow_IMTDetail_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("attached text:=IMT Detail")'
# LIQ_Drawdown_Cashflows_DetailsforCashflow_Exit_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("attached text:=Exit")'
# LIQ_Drawdown_Cashflows_DetailsforCashflow_OK_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("attached text:=OK")'
# LIQ_Drawdown_Cashflows_ViewOutgoingIMTMessages_Window = 'JavaWindow("title:=View Outgoing IMT Messages")'
# LIQ_Drawdown_Cashflows_ViewOutgoingIMTMessages_Cancel_Button = 'JavaWindow("title:=View Outgoing IMT Messages").JavaButton("attached text:=Cancel")'
# LIQ_Drawdown_Cashflows_ViewOutgoingIMTMessages_List = 'JavaWindow("title:=View Outgoing IMT Messages").JavaObject("text:=Outgoing IMT Remittance Instruction Messages").JavaTree("tagname:=Tree")'
# LIQ_Drawdown_Cashflows_ChooseRemittance_Window = 'JavaWindow("title:=Choose Remittance Instructions")'
# LIQ_Drawdown_Cashflows_ChooseRemittance_List = 'JavaWindow("title:=Choose Remittance Instructions").JavaTree("attached text:=Drill down to view details")'
# LIQ_Drawdown_Cashflows_ChooseRemittance_OK_Button = 'JavaWindow("title:=Choose Remittance Instructions").JavaButton("attached text:=OK")'
# LIQ_Drawdown_Cashflows_ChooseRemittance_Cancel_Button = 'JavaWindow("title:=Choose Remittance Instructions").JavaButton("attached text:=Cancel")'
# LIQ_Drawdown_Cashflows_SetToDoIt_Button = 'JavaWindow("title:=Cashflows .* Drawdown.*").JavaButton("attached text:=Set Selected Item To.*Do It.*")'
# LIQ_Drawdown_Cashflows_SetUndoIt_Button = 'JavaWindow("title:=Cashflows .* Drawdown.*").JavaButton("attached text:=Set Selected Item To.*Undo It.*")'
# LIQ_Drawdown_Queries_GLEntries_Cashflow = 'JavaWindow("title:=Cashflows .* Drawdown.*").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
# 
###Create Cashflow Payment##
LIQ_Payment_Window = 'JavaWindow("title:=.* Payment.*","displayed:=1")'
LIQ_InterestPayment_Window = 'JavaWindow("title:=.* Interest.*","displayed:=1")'
LIQ_Payment_Tab = 'JavaWindow("title:=.* Payment.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_InterestPayment_Tab = 'JavaWindow("title:=.* Interest.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_Payment_Options_Cashflow = 'JavaWindow("title:=.* Payment.*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=Cashflow")'
LIQ_Interest_Options_Cashflow = 'JavaWindow("title:=.* Interest.*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=Cashflow")'
LIQ_Interest_Options_LoanNotebook = 'JavaWindow("title:=.* Interest.*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=Loan Notebook")'
LIQ_Interest_Options_ViewUpdateLenderShares = 'JavaWindow("title:=.* Interest.*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=View/Update Lender Shares")'
LIQ_Payment_Options_ViewUpdateLenderShares = 'JavaWindow("title:=.* Payment.*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=View/Update Lender Shares")'
LIQ_Payment_WorkflowItems = 'JavaWindow("title:=.* Payment.*","displayed:=1").JavaTree("attached text:=.*Workflow .*")'
LIQ_Interest_WorkflowItems = 'JavaWindow("title:=.* Interest.*","displayed:=1").JavaTree("attached text:=.*Workflow .*")'
LIQ_Payment_Cashflows_Window = 'JavaWindow("title:=Cashflows .* Payment.*","displayed:=1")'
LIQ_Payment_Cashflows_Queries_GLEntries = 'JavaWindow("title:=Cashflows .* Payment.*","displayed:=1").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
LIQ_Payment_Cashflows_List  = 'JavaWindow("title:=Cashflows .* Payment.*","displayed:=1").JavaTree("attached text:=Drill down to view/change details")'
LIQ_Payment_Cashflows_OK_Button = 'JavaWindow("title:=Cashflows .* Payment.*","displayed:=1").JavaButton("attached text:=OK")'
LIQ_Payment_Cashflows_RemittanceDesc_None_StaticText = 'JavaWindow("title:=Cashflows .* Payment.*").JavaStaticText("attached text:=None")'
LIQ_Payment_Cashflows_RemittanceDesc_RTGS_StaticText = 'JavaWindow("title:=Cashflows .* Payment.*").JavaStaticText("attached text:=.*RTGS.*")'
LIQ_Payment_Cashflows_RemittanceDesc_IMT_StaticText = 'JavaWindow("title:=Cashflows .* Payment.*").JavaStaticText("attached text:=.*IMT.*")'
LIQ_Payment_Cashflows_DetailsforCashflow_Window = 'JavaWindow("title:=Details for Cashflow.*")'
LIQ_Payment_Cashflows_DetailsforCashflow_SelectRI_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("attached text:=Select Remittance Instructions")'
LIQ_Payment_Cashflows_DetailsforCashflow_IMTDetail_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("attached text:=IMT Detail")'
LIQ_Payment_Cashflows_DetailsforCashflow_Exit_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("attached text:=Exit")'
LIQ_Payment_Cashflows_DetailsforCashflow_OK_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("attached text:=OK")'
LIQ_Payment_Cashflows_ChooseRemittance_Window = 'JavaWindow("title:=Choose Remittance Instructions")'
LIQ_Payment_Cashflows_ChooseRemittance_List = 'JavaWindow("title:=Choose Remittance Instructions").JavaTree("attached text:=Drill down to view details")'
LIQ_Payment_Cashflows_ChooseRemittance_OK_Button = 'JavaWindow("title:=Choose Remittance Instructions").JavaButton("attached text:=OK")'
LIQ_Payment_Cashflows_SetToDoIt_Button = 'JavaWindow("title:=Cashflows .* Payment.*").JavaButton("attached text:=Set Selected Item To.*Do It.*")'
LIQ_Payment_Cashflows_SetUndoIt_Button = 'JavaWindow("title:=Cashflows .* Payment.*").JavaButton("attached text:=Set Selected Item To.*Undo It.*")'
LIQ_Payment_Cashflows_ViewOutgoingIMTMessages_Window = 'JavaWindow("title:=View Outgoing IMT Messages")'
LIQ_Payment_Cashflows_ViewOutgoingIMTMessages_Cancel_Button = 'JavaWindow("title:=View Outgoing IMT Messages").JavaButton("attached text:=Cancel")'
LIQ_Payment_Cashflows_Options_MarkAllToRelease = 'JavaWindow("title:=Cashflows .*").JavaMenu("label:=Options").JavaMenu("label:=Mark All To Release")'
LIQ_Payment_Cashflow_HostBankCash_JavaEdit = 'JavaWindow("title:=Cashflows .* Ongoing Fee Payment.*").JavaStaticText("to_class:=JavaStaticText","index:=28")'
LIQ_Payment_Queries_GLEntries_Cashflow = 'JavaWindow("title:=Cashflows .* Ongoing Fee Payment.*").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
LIQ_Payment_Cashflows_ChooseRemittance_CustomInstructions_CheckBox = 'JavaWindow("title:=Choose Remittance Instructions").JavaCheckBox("attached text:=Custom Instructions")'
LIQ_Payment_Cashflows_ChooseRemittance_Details_Button = 'JavaWindow("title:=Choose Remittance Instructions").JavaButton("attached text:=Details")'
LIQ_Payment_Cashflows_RemittanceInstructionsDetail_Window = 'JavaWindow("title:=Remittance Instructions Detail--Type:.*")'
LIQ_Payment_Cashflows_RemittanceInstructionsDetail_Tab = 'JavaWindow("title:=Remittance Instructions Detail--Type:.*").JavaTab("tagname:=TabFolder")'
LIQ_Payment_Cashflows_RemittanceInstructionsDetail_Method_List = 'JavaWindow("title:=Remittance Instructions Detail--Type:.*").JavaList("attached text:=Method:")'
LIQ_Payment_Cashflows_RemittanceInstructionsDetail_Description_Field = 'JavaWindow("title:=Remittance Instructions Detail--Type:.*").JavaEdit("attached text:=Description:")'
LIQ_Payment_Cashflows_RemittanceInstructionsDetail_FileSave_Menu = 'JavaWindow("title:=Remittance Instructions Detail--Type:.*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_Payment_Cashflows_RemittanceInstructionsDetail_FileExit_Menu = 'JavaWindow("title:=Remittance Instructions Detail--Type:.*").JavaMenu("label:=File").JavaMenu("label:=Exit")'
LIQ_Payment_Cashflow_HostBankCashNet_Amount = 'JavaWindow("title:=Cashflows .* Payment.*").JavaStaticText("to_class:=JavaStaticText","index:=28")'
LIQ_Payment_Cashflow_IncompleteCashfromBorrower_Amount = 'JavaWindow("title:=Cashflows .* Payment.*").JavaStaticText("to_class:=JavaStaticText","index:=26")'
LIQ_Payment_Cashflow_IncompleteCashtoLender_Amount = 'JavaWindow("title:=Cashflows .* Payment.*").JavaStaticText("to_class:=JavaStaticText","index:=27")'
LIQ_Payment_Queries_GLEntries_Cashflow = 'JavaWindow("title:=Cashflows .* Payment.*").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
LIQ_Payment_Queries_GLEntries_Menu = 'JavaWindow("title:=.* Payment.*").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
# 
# ####Drawdown Cashflow####
# LIQ_Drawdown_Cashflows_MarkSelectedItemForRelease_Button = 'JavaWindow("title:=Cashflows .*").JavaButton("attached text:=Mark Selected Item For Release")'
# LIQ_Payment_Cashflows_MarkSelectedItemForRelease_Button = 'JavaWindow("title:=Cashflows .* Payment.*").JavaButton("attached text:=Mark Selected Item For Release")'
# LIQ_Payment_Cashflows_ViewOutgoingIMTMessages_List = 'JavaWindow("title:=View Outgoing IMT Messages").JavaObject("text:=Outgoing IMT Remittance Instruction Messages").JavaTree("tagname:=Tree")'
# 
# LIQ_Drawdown_Cashflow_HostBankCash_JavaEdit = 'JavaWindow("title:=Cashflows .* Drawdown.*").JavaStaticText("to_class:=JavaStaticText","index:=28")'
# 
# ####Drawdown Cashflow####
# LIQ_Drawdown_Cashflow_HostBankCash_JavaEdit = 'JavaWindow("title:=Cashflows .* Drawdown.*").JavaStaticText("to_class:=JavaStaticText","x:=270","y:=58")'
# 
# ###Cashflow in Assignment Transaction###
# LIQ_Assignment_Cashflows_Window = 'JavaWindow("title:=Cashflows For .*","displayed:=1")'
# LIQ_Assignment_Cashflows_List  = 'JavaWindow("title:=Cashflows For .*","displayed:=1").JavaTree("attached text:=Drill down to view/change details")'
# LIQ_Assignment_Cashflows_SetToDoIt_Button = 'JavaWindow("title:=Cashflows For .*","displayed:=1").JavaButton("attached text:=Set Selected Item To.*Do It.*")'
# LIQ_Assignment_Cashflows_SetUndoIt_Button = 'JavaWindow("title:=Cashflows For .*","displayed:=1").JavaButton("attached text:=Set Selected Item To.*Undo It.*")'
# LIQ_Assignment_Cashflows_OK_Button = 'JavaWindow("title:=Cashflows For .*","displayed:=1").JavaButton("attached text:=OK")'
# 
# ###Create Cashflow Manual Share Adjustment##
# LIQ_ManualShareAdj_Cashflows_Window = 'JavaWindow("title:=Cashflows For .* Manual Share Adjustment .*")'
# LIQ_ManualShareAdj_Cashflows_List  = 'JavaWindow("title:=Cashflows For .* Manual Share Adjustment .*").JavaTree("attached text:=Drill down to view/change details")'
# LIQ_ManualShareAdj_Cashflows_DetailsforCashflow_Window = 'JavaWindow("title:=Details for Cashflow.*")'
# LIQ_ManualShareAdj_Cashflows_DetailsforCashflow_SelectRI_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("attached text:=Select Remittance Instructions")'
# LIQ_ManualShareAdj_Cashflows_DetailsforCashflow_OK_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("attached text:=OK")'
# LIQ_ManualShareAdj_Cashflows_ChooseRemittance_Window = 'JavaWindow("title:=Choose Remittance Instructions")'
# LIQ_ManualShareAdj_Cashflows_ChooseRemittance_List = 'JavaWindow("title:=Choose Remittance Instructions").JavaTree("attached text:=Drill down to view details")'
# LIQ_ManualShareAdj_Cashflows_ChooseRemittance_OK_Button = 'JavaWindow("title:=Choose Remittance Instructions").JavaButton("attached text:=OK")'
# LIQ_ManualShareAdj_Cashflows_SetToDoIt_Button = 'JavaWindow("title:=Cashflows For .* Manual Share Adjustment .*").JavaButton("attached text:=Set Selected Item To.*Do It.*")'
# LIQ_ManualShareAdj_Queries_GLEntries_Cashflow = 'JavaWindow("title:=Cashflows .* Manual Share Adjustment .*").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
# LIQ_ManualShareAdj_Cashflow_HostBankCash_JavaEdit = 'JavaWindow("title:=Cashflows .* Manual Share Adjustment .*").JavaStaticText("to_class:=JavaStaticText","index:=28")'
# LIQ_ManualShareAdj_Cashflows_OK_Button = 'JavaWindow("title:=Cashflows .* Manual Share Adjustment .*").JavaButton("attached text:=OK")'
# 
# LIQ_GLEntries_Window = 'JavaWindow("title:=GL Entries.*")'
# LIQ_GLEntries_DealFacility_StaticText = 'JavaWindow("title:=GL Entries.*").JavaStaticText("index:=1")'
# LIQ_GLEntries_Tree = 'JavaWindow("title:=GL Entries.*").JavaTree("attached text:=Drill down to view details")'
# LIQ_GLEntries_Exit_Button = 'JavaWindow("title:=GL Entries.*").JavaButton("label:=Exit")'
# 
##Payment Reversal##
 
LIQ_ReversePayment_WorkflowItems_Tree = 'JavaWindow("title:=Commitment Fee Reverse Fee.*").JavaTree("attached text:=.*Workflow .*")'
 
###Create Split Cashflow###
LIQ_Cashflow_Options_SplitCashflows = 'JavaWindow("title:=Cashflows .*").JavaMenu("label:=Options").JavaMenu("label:=Split Cashflows")'
LIQ_Cashflow_Options_SetAllDOIT = 'JavaWindow("title:=Cashflows .*").JavaMenu("label:=Options").JavaMenu("label:=Set All To .*Do It.*")'
LIQ_SplitCashflows_Window = 'JavaWindow("title:=Cashflows Eligible For Splitting")'
LIQ_SplitCashflows_Add_Button = 'JavaWindow("title:=Cashflows Eligible For Splitting").JavaButton("attached text:=Add")'
LIQ_SplitCashflows_Exit_Button = 'JavaWindow("title:=Cashflows Eligible For Splitting").JavaButton("attached text:=Exit")'
LIQ_SplitCashflows_JavaTree= 'JavaWindow("title:=Cashflows Eligible For Splitting").JavaTree("labeled_containers_path:=Group:Cashflows Split From Selected Cashflow;")'
LIQ_SplitCashflows_Delete_Button = 'JavaWindow("title:=Cashflows Eligible For Splitting").JavaButton("attached text:=Delete")'

###Split Cashflow Detail###
LIQ_SplitCashflowsDetail_Window = 'JavaWindow("title:=Split Cashflow Detail")'
LIQ_SplitCashflowsDetail_RemittanceInstruction_Button = 'JavaWindow("title:=Split Cashflow Detail").JavaButton("attached text:=Remittance Instructions:")'
LIQ_SplitCashflowsDetail_SplitPrincipal_Field = 'JavaWindow("title:=Split Cashflow Detail").JavaEdit("attached text:=Split Principal:")'
LIQ_SplitCashflowsDetail_TransactionAmount_Static = 'JavaWindow("title:=Split Cashflow Detail").JavaStaticText("labeled_containers_path:=.*Amount Available To Split.*","index:=1")'
LIQ_SplitCashflowsDetail_OK_Button = 'JavaWindow("title:=Split Cashflow Detail").JavaButton("attached text:=OK")'

###Select Remittance Instruction###
LIQ_SelectRemittanceInstruction_Window = 'JavaWindow("title:=Select a Remittance Instruction")'
LIQ_SelectRemittanceInstruction_JavaTree = 'JavaWindow("title:=Select a Remittance Instruction").JavaTree("attached text:=Drill down to select item")'
LIQ_SelectRemittanceInstruction_OK_Button = 'JavaWindow("title:=Select a Remittance Instruction").JavaButton("attached text:=OK")'
# 
# ###Principal Payment Cashflow Window###
# LIQ_Payment_Cashflows_IncompleteCashFromBorrower_StaticText = 'JavaWindow("title:=Cashflows .* Payment.*","displayed:=1").JavaStaticText("index:=26")'
# LIQ_Payment_Cashflows_IncompleteCashtoLenders_StaticText = 'JavaWindow("title:=Cashflows .* Payment.*","displayed:=1").JavaStaticText("index:=27")'
# LIQ_Payment_Cashflows_HostBankCashNet_StaticText = 'JavaWindow("title:=Cashflows .* Payment.*","displayed:=1").JavaStaticText("index:=28")'
# 
# ###Incoming Manual Cashflow Window###
# LIQ_IncomingManualCashflow_Cashflows_Window = 'JavaWindow("title:=Cashflows For Incoming Manual Cashflow","displayed:=1")'
# LIQ_IncomingManualCashflow_Cashflows_JavaTree = 'JavaWindow("title:=Cashflows For Incoming Manual Cashflow").JavaTree("attached text:=Drill down to view/change details")'
# LIQ_IncomingManualCashflow_Cashflows_DoIt_Button = 'JavaWindow("title:=Cashflows For Incoming Manual Cashflow").JavaButton("label:=Set Selected Item To .*")'
# 
# ###Cashflows###
LIQ_Cashflows_IncCashFromBorrower_Amount = 'JavaWindow("title:=Cashflows .*").JavaStaticText("to_class:=JavaStaticText","index:=26")'
LIQ_Cashflows_IncCashToLender_Amount = 'JavaWindow("title:=Cashflows .*").JavaStaticText("to_class:=JavaStaticText","index:=27")'
LIQ_Cashflows_HostBankCashNet_Amount = 'JavaWindow("title:=Cashflows .*").JavaStaticText("to_class:=JavaStaticText","index:=28")'
# LIQ_Cashflows_Javatree = 'JavaWindow("title:=Cashflows .* ").JavaTree("attached text:=Drill down to view/change details")'
# LIQ_Cashflows_CashflowDetails_Window = 'JavaWindow("title:=Details for Cashflow.*")'
# LIQ_Cashflows_CashflowDetails_SelectRI_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("attached text:=Select Remittance Instructions")'
# LIQ_Cashflows_ChooseRemittance_Window = 'JavaWindow("title:=Choose Remittance Instructions")'
# LIQ_Cashflows_ChooseRemittance_Javatree = 'JavaWindow("title:=Choose Remittance Instructions").JavaTree("attached text:=Drill down to view details")'
# LIQ_Cashflows_ChooseRemittance_OK_Button = 'JavaWindow("title:=Choose Remittance Instructions").JavaButton("attached text:=OK")'
# LIQ_Cashflows_CashflowDetails_OK_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("attached text:=OK")'
# LIQ_Cashflows_SetToDoIt_Button = 'JavaWindow("title:=Cashflows .*").JavaButton("attached text:=Set Selected Item To.*Do It.*")'
# LIQ_Cashflows_CashflowDetails_IMTDetail_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("attached text:=IMT Detail")'
# LIQ_Cashflows_CashflowDetails_Exit_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("attached text:=Exit")'
# LIQ_Cashflows_Options_MarkAllToRelease = 'JavaWindow("title:=Cashflows .*").JavaMenu("label:=Options").JavaMenu("label:=Mark All To Release")'
# 
# ###Cashflows Reversal Fee###
# LIQ_ReversePayment_Cashflows_MarkSelectedItemForRelease_Button = 'JavaWindow("title:=Cashflows .* Fee Reverse.*").JavaButton("attached text:=Mark Selected Item For Release")'
# LIQ_ReversePayment_Cashflows_OK_Button = 'JavaWindow("title:=Cashflows .* Fee Reverse.*").JavaButton("attached text:=OK")'
