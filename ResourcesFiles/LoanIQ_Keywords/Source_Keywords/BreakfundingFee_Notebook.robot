*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Navigate Breakfunding Fee Notebook
    [Documentation]    This keyword navigates the user to Breakfunding Fee Notebook
    ...    @author: jcdelacruz
    ...    @update: sahalder    08JUL2020    Added keyword pre-processing steps
    [Arguments]    ${sLoan_Alias}    ${sDeal_Name}    ${sFacility_Name}    ${sBorrower}    ${sPricing_Option_From_Breakfunding}    ${sCurrency}
    
    ### GetRuntime Keyword Pre-processing ###
	${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}
	${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
	${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
	${Borrower}    Acquire Argument Value    ${sBorrower}
	${Pricing_Option_From_Breakfunding}    Acquire Argument Value    ${sPricing_Option_From_Breakfunding}
	${Currency}    Acquire Argument Value    ${sCurrency}

    mx LoanIQ activate window    ${LIQ_ExistingLoansForFacility_Window}
    Sleep    3
    Mx LoanIQ Select String    ${LIQ_ExistingLoansForFacility_Loan_List}    ${Loan_Alias}
    Mx Native Type    {ENTER}
    mx LoanIQ activate window    ${LIQ_LoanNotebook_BbsyBidLoan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanNotebook_BbsyBidLoan_Tab}    Pending
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_LoanNotebook_PendingItems_List}    Break Cost Fee%yes
    Mx LoanIQ Select String    ${LIQ_LoanNotebook_PendingItems_List}    Break Cost Fee        
    Mx Native Type    {ENTER}
    Run Keyword And Continue On Failure    mx LoanIQ activate    ${LIQ_Breakfunding_Pending_Window}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Breakfunding_Pending_Window}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${Deal_Name}    ${LIQ_Breakfunding_Deal_Label}
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${Facility_Name}    ${LIQ_Breakfunding_Facility_Label}
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${Borrower}    ${LIQ_Breakfunding_Borrower_Label}
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${Loan_Alias}    ${LIQ_Breakfunding_LoanAlias_Label}
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${Pricing_Option_From_Breakfunding}    ${LIQ_Breakfunding_PricingOption_Label}
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${Currency}    ${LIQ_Breakfunding_Currency_Label} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakfundingFee_Notebook   
      
Request Lender Fees
    [Documentation]    This keyword is use to request lender fees in breakfunding
    ...    @author: jcdelacruz
    ...    @update: mcastro    17DEC2020    - Added Take screenshot
    mx LoanIQ activate window    ${LIQ_Breakfunding_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Breakfunding_Workflow_Tab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakfundingWorkflowTab
    ${InquiryButtonStatus}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Breakfunding_InquiryMode_Button}    VerificationData="Yes"
    Run Keyword If    ${InquiryButtonStatus}==True    mx LoanIQ click    ${LIQ_Breakfunding_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Breakfunding_WorkflowItems_List}    Request Lender Fees%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakfundingWorkflowTab    
    mx LoanIQ activate window    ${LIQ_Notices_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakfundingWorkflowTab
    Run Keyword And Continue On Failure    Validate if Element is Checked    ${LIQ_Notices_Lenders_Checkbox}    Lenders
    mx LoanIQ click    ${LIQ_Notices_Ok_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakfundingWorkflowTab
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    mx LoanIQ activate window    ${LIQ_BreakfundingEventFeePayment_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakfundingWindow
    # Mx Click    ${LIQ_BreakfundingEventFeePayment_MarkAll_Button}
    # Mx Click    ${LIQ_BreakfundingEventFeePayment_Send_Button}
    # Mx Click Element If Present    ${LIQ_Information_OK_Button}

    mx LoanIQ click element if present    ${LIQ_BreakfundingEventFeePayment_Exit_Button}

Generate Lender Shares
    [Documentation]    This keyword is use to generate lender shares in breakfunding
    ...    @author:
    ...    @update: sahalder    08JUL2020    Added keyword pre-processing steps
    [Arguments]     ${sLegal_Entity}    ${sLender2}    ${sLender3}    ${sLegal_Entity_Amount}    ${sLender2_Amount}    ${sLender3_Amount}
    
    ### GetRuntime Keyword Pre-processing ###
	${Legal_Entity}    Acquire Argument Value    ${sLegal_Entity}
	${Lender2}    Acquire Argument Value    ${sLender2}
	${Lender3}    Acquire Argument Value    ${sLender3}
	${Legal_Entity_Amount}    Acquire Argument Value    ${sLegal_Entity_Amount}
	${Lender2_Amount}    Acquire Argument Value    ${sLender2_Amount}
	${Lender3_Amount}    Acquire Argument Value    ${sLender3_Amount}

    mx LoanIQ activate window    ${LIQ_Breakfunding_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Breakfunding_Workflow_Tab}    Workflow 
    ${InquiryButtonStatus}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Breakfunding_InquiryMode_Button}    VerificationData="Yes"
    Run Keyword If    ${InquiryButtonStatus}==True    mx LoanIQ click    ${LIQ_Breakfunding_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Breakfunding_WorkflowItems_List}    Generate Lender Shares%d
    
    mx LoanIQ activate window    ${LIQ_SharesForBreakCostFee_Window}
    Mx LoanIQ Select String    ${LIQ_SharesForBreakCostFee_PrimaryAssignee_List}    ${Legal_Entity}
    Mx Native Type    {ENTER}
    mx LoanIQ activate window    ${LIQ_ServicingGroupShare_Window}
    mx LoanIQ enter    ${LIQ_ServicingGroupShare_Amount_Textfield}    ${Legal_Entity_Amount}
    mx LoanIQ click    ${LIQ_ServicingGroupShare_Ok_Button}
    
    mx LoanIQ activate window    ${LIQ_SharesForBreakCostFee_Window}
    Mx LoanIQ Select String    ${LIQ_SharesForBreakCostFee_PrimaryAssignee_List}    ${Lender2}
    Mx Native Type    {ENTER}
    mx LoanIQ activate window    ${LIQ_ServicingGroupShare_Window}
    mx LoanIQ enter    ${LIQ_ServicingGroupShare_Amount_Textfield}    ${Lender2_Amount}
    mx LoanIQ click    ${LIQ_ServicingGroupShare_Ok_Button}
    
    mx LoanIQ activate window    ${LIQ_SharesForBreakCostFee_Window}
    Mx LoanIQ Select String    ${LIQ_SharesForBreakCostFee_PrimaryAssignee_List}    ${Lender3}
    Mx Native Type    {ENTER}
    mx LoanIQ activate window    ${LIQ_ServicingGroupShare_Window}
    mx LoanIQ enter    ${LIQ_ServicingGroupShare_Amount_Textfield}    ${Lender3_Amount}
    mx LoanIQ click    ${LIQ_ServicingGroupShare_Ok_Button}
 
Generate Lender Shares for Bilateral Deal
    [Documentation]    This keyword is use to generate lender shares in breakfunding
    ...    @author: ritragel
    ...    @update: mcastro    17DEC2020    - Added take screenshot
    ...    @update: mcastro    07JAN2021    - Updated Mx Native Type to Mx Press Combination
    [Arguments]     ${Legal_Entity}    ${Legal_Entity_Amount}
    mx LoanIQ activate window    ${LIQ_Breakfunding_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Breakfunding_Workflow_Tab}    Workflow 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakfundingWindow_WorkflowTab
    ${InquiryButtonStatus}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Breakfunding_InquiryMode_Button}    VerificationData="Yes"
    Run Keyword If    ${InquiryButtonStatus}==True    mx LoanIQ click    ${LIQ_Breakfunding_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Breakfunding_WorkflowItems_List}    Generate Lender Shares%d
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakfundingWindow_WorkflowTab

    mx LoanIQ activate window    ${LIQ_SharesForBreakCostFee_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakCostFeeWindow
    Mx LoanIQ Select String    ${LIQ_SharesForBreakCostFee_PrimaryAssignee_List}    ${Legal_Entity}
    Mx Press Combination    Key.ENTER
    mx LoanIQ activate window    ${LIQ_ServicingGroupShare_Window}
    mx LoanIQ enter    ${LIQ_ServicingGroupShare_Amount_Textfield}    ${Legal_Entity_Amount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ServicingGroupShareWindow
    mx LoanIQ click    ${LIQ_ServicingGroupShare_Ok_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakCostFeeWindow
    
Add Portfolio and Expense Code
    [Documentation]    This keyword is use to add portfolio and expense code to the legal entity from lender window
    ...    @author: jcdelacruz
    ...    @update: ritragel    9SEP11    Passing expense code instead of rowid
    ...    @update: sahalder    08JUL2020    Added keyword pre-processing steps
    ...    @update: mcastro    17DEC2020    Fixed incorrect variable name for ExpenseCode
    ...    @update: mcastro    07JAN2021    - Updated Mx Native Type to Mx Press Combination
    ...    @update: mcastro    15JAN2021    - Added taking of screenshots
    ...    @update: mcastro    22JAN2021    - Added additional taking of screenshots
    [Arguments]    ${sLegal_Entity}    ${sLegal_Entity_Amount}    ${sExpenseCode}
    
    ### GetRuntime Keyword Pre-processing ###
	${Legal_Entity}    Acquire Argument Value    ${sLegal_Entity}
	${Legal_Entity_Amount}    Acquire Argument Value    ${sLegal_Entity_Amount}
	${ExpenseCode}    Acquire Argument Value    ${sExpenseCode}

    mx LoanIQ activate window    ${LIQ_SharesForBreakCostFee_Window}
    Mx LoanIQ Select String    ${LIQ_SharesForBreakCostFee_LegalEntity_List}    ${Legal_Entity}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakCostFee_PortfolioSelection
    Mx Press Combination    Key.ENTER
    mx LoanIQ activate window    ${LIQ_HostBankShares_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_HostBankShares_Window}              VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakCostFee_PortfolioSelection
    mx LoanIQ click    ${LIQ_HostBankShares_AddPortfolioExpenseCode_Button}
    mx LoanIQ activate window    ${LIQ_HostBankShares_PortfolioSelection_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakCostFee_PortfolioSelection
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_HostBankShares_PortfolioSelection_Window}    VerificationData="Yes"
    Mx LoanIQ Select String    ${LIQ_HostBankShares_PortfolioSelection_List}    ${ExpenseCode}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakCostFee_PortfolioSelection
    mx LoanIQ click    ${LIQ_HostBankShares_PortfolioSelection_Ok_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakCostFee_PortfolioShareEdit
    mx LoanIQ activate window    ${LIQ_PortfolioShareEdit_Window}
    mx LoanIQ enter    ${LIQ_PortfolioShareEdit_ActualAmount_Field}    ${Legal_Entity_Amount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakCostFee_PortfolioShareEdit
    mx LoanIQ click    ${LIQ_PortfolioShareEdit_Ok_Button}
    mx LoanIQ activate window    ${LIQ_HostBankShares_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakCostFee_PortfolioShare
    # Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_HostBankShares_BranchPortfolioExpenseCode_List}    .*${Expense_Code}.*%yes
    # Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_HostBankShares_BranchPortfolioExpenseCode_List}    .*${Lender1_Amount}.*%yes
    mx LoanIQ click    ${LIQ_HostBankShares_Ok_Button}
    mx LoanIQ activate window    ${LIQ_SharesForBreakCostFee_Window}
    mx LoanIQ click    ${LIQ_SharesForBreakCostFee_Ok_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakfundingFee_Notebook1
    
Create Cashflow for Break Funding
    [Documentation]    This keyword creates cashflow for the breakfunding
    ...    @author: jcdelacruz
    mx LoanIQ activate    ${LIQ_Breakfunding_Pending_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakfundingFee_Cashflows
    Mx LoanIQ Select Window Tab    ${LIQ_Breakfunding_Workflow_Tab}    Workflow
    Mx LoanIQ DoubleClick    ${LIQ_Breakfunding_WorkflowItems_List}    Create Cashflows
    mx LoanIQ activate window    ${LIQ_BreakFundingCashflow_Window}                 
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_BreakFundingCashflow_Window}    VerificationData="Yes"
    
Verify if Method has Remittance Instruction - Breakfunding
    [Documentation]    This keyword is used to validate the Drawdown Cashflow Information.
    ...    @author: ritragel
    [Arguments]    ${LIQCustomer_ShortName}    ${Remittance_Description}
    ${CashflowMethod}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_BreakFunding_Cashflows_List}    ${LIQCustomer_ShortName}%Method%Method_Variable
    Log To Console    ${CashflowMethod}     
    ${status}    Run Keyword And Return Status    Run Keyword And Ignore Error    Should Be Equal As Strings    ${CashflowMethod}    NONE
    Run Keyword If    ${status}==True    Add Remittance Instructions - Breakfunding    ${LIQCustomer_ShortName}    ${Remittance_Description}
    ...    ELSE    Log    Method already has remittance instructions
    ${status}    Run Keyword And Return Status    Run Keyword And Ignore Error    Should Be Equal As Strings    ${CashflowMethod}    DDA
    Run Keyword If    ${status}==True    Add Remittance Instructions - Breakfunding    ${LIQCustomer_ShortName}    ${Remittance_Description}
    ...    ELSE    Log    Method already has remittance instructions
    ${status}    Run Keyword And Return Status    Run Keyword And Ignore Error    Should Be Equal As Strings    ${CashflowMethod}    IMT
    Run Keyword If    ${status}==True    Add Remittance Instructions - Breakfunding    ${LIQCustomer_ShortName}    ${Remittance_Description}
    ...    ELSE    Log    Method already has remittance instructions
   
Verify if Status is set to Do It - Breakfunding
    [Documentation]    This keyword is used to validate the breakfunding Cashflow Status
    ...    @author: jcdelacruz
    [Arguments]    ${LIQCustomer_ShortName}
     ${CashflowStatus}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_BreakFunding_Cashflows_List}    ${LIQCustomer_ShortName}%Status%MStatus_Variable
    Log To Console    ${CashflowStatus} 
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${CashflowStatus}    PEND
    Run Keyword If    ${status}==True    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_BreakFunding_Cashflows_List}    ${LIQCustomer_ShortName}%s   
    Run Keyword If    ${status}==True    mx LoanIQ click    ${LIQ_BreakFunding_Cashflows_DoIt_Button}    
    ...    ELSE    Log    Status is already set to Do it
    Log    Verify Status is set to do it is complete
    
Add Remittance Instructions - Breakfunding
    [Documentation]    This keyword is used to select remittance instruction thru the Cashflow window for breakfunding.
    ...    @author: jcdelacruz
    [Arguments]    ${LIQCustomer_ShortName}    ${Remittance_Description}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_BreakFunding_Cashflows_List}    ${LIQCustomer_ShortName}%d
    # Mx Activate    ${LIQ_Drawdown_Cashflows_DetailsforCashflow_Window}    
    # Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Drawdown_Cashflows_DetailsforCashflow_Window}     VerificationData="Yes"
    # Mx Click    ${LIQ_Drawdown_Cashflows_DetailsforCashflow_SelectRI_Button}  
    # Mx Activate    ${LIQ_Drawdown_Cashflows_ChooseRemittance_Window}
    # Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Drawdown_Cashflows_ChooseRemittance_List}    ${Remittance_Description}%s 
    # Mx Click    ${LIQ_Drawdown_Cashflows_ChooseRemittance_OK_Button}
    # Mx Click    ${LIQ_Drawdown_Cashflows_DetailsforCashflow_OK_Button}


Generate Intent Notices - Break Funding
    [Documentation]    This keyword is use to generate intent notice for breakfunding
    ...    @author: jcdelacruz
    ...    @update: mcastro    14JAN2021    - Updated 'Generate Intent Notice' and 'Workflow' to global variable, Added logging of passed/failed validation
    ...                                     - Removed comment steps; Added Taking of screenshots

    mx LoanIQ click element if present    ${LIQ_BreakFundingCashflow_Ok_Button}
    mx LoanIQ activate window    ${LIQ_Breakfunding_AwaitingSend_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Breakfunding_AwaitingSend_Tab}    ${WORKFLOW_TAB}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/GenerateIntentNotice

    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_Breakfunding_WorkflowItems_AwaitingSend_List}    ${GENERATE_INTENT_NOTICES}%yes
    Run Keyword If    ${Status}==${True}    Log    ${GENERATE_INTENT_NOTICES} is displayed.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    ${GENERATE_INTENT_NOTICES} is not displayed.

    Mx LoanIQ DoubleClick    ${LIQ_Breakfunding_WorkflowItems_AwaitingSend_List}    ${GENERATE_INTENT_NOTICES}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/GenerateIntentNotice
    mx LoanIQ activate window    ${LIQ_Notices_Window}
    Run Keyword And Continue On Failure    Validate if Element is Checked    ${LIQ_Notices_Lenders_Checkbox}    Lenders
    Run Keyword And Continue On Failure    Validate if Element is Checked    ${LIQ_Notices_BorrowerDepositor_Checkbox}    Borrower / Depositor
    mx LoanIQ click    ${LIQ_Notices_Ok_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/GenerateIntentNotice
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_EventFeePaymentGroup_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/GenerateIntentNotice
    mx LoanIQ click    ${LIQ_EventFeePaymentGroup_Exit_Button}

Send Breakfunding to Approval
    [Documentation]    This keyword is use to send the breakfunding transaction for approval
    ...    @author: jcdelacruz
    mx LoanIQ click element if present    ${LIQ_BreakFundingCashflow_Ok_Button}
    mx LoanIQ activate window    ${LIQ_Breakfunding_AwaitingSend_Window}
    mx LoanIQ activate window    ${LIQ_Breakfunding_AwaitingSend_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Breakfunding_AwaitingSend_Tab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakfundingFee_SendToApproval
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_Breakfunding_WorkflowItems_AwaitingSend_List}    Send to Approval
    Mx LoanIQ DoubleClick    ${LIQ_Breakfunding_WorkflowItems_AwaitingSend_List}    Send to Approval
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Approve Breakfunding via WIP LIQ Icon
    [Documentation]    This keyword navigates the breakfunding to be approved from Work in Process window
    ...     @author: jcdelacruz
    ...     @update: sahalder    08JUL2020    Added keyword pre-processing steps
    [Arguments]    ${sWIP_TransactionType}    ${sWIP_AwaitingApprovalStatus}    ${sWIP_OutstandingType}
    
    ### GetRuntime Keyword Pre-processing ###
	${WIP_TransactionType}    Acquire Argument Value    ${sWIP_TransactionType}
	${WIP_AwaitingApprovalStatus}    Acquire Argument Value    ${sWIP_AwaitingApprovalStatus}
	${WIP_OutstandingType}    Acquire Argument Value    ${sWIP_OutstandingType}

    ${Loan_Alias}    Read Data From Excel    SERV40_BreakFunding    Loan_Alias    ${rowid}
    Open Breakfunding Fee Notebook via WIP - Awaiting Approval    ${WIP_TransactionType}    ${WIP_AwaitingApprovalStatus}    ${WIP_OutstandingType}    ${Loan_Alias}
    Approve Breakfunding    

Open Breakfunding Fee Notebook via WIP - Awaiting Approval
    [Documentation]    This keyword is used to open the Breakfunding Fee Notebook with an Awaiting Approval Status thru the LIQ WIP Icon.
    ...     @author: jcdelacruz
    ...     @update: sahalder    10JUL2020    Added keyword pre-processing steps
    [Arguments]    ${sWIP_TransactionType}    ${sWIP_AwaitingApprovalStatus}    ${sWIP_OutstandingType}    ${sLoan_Alias}
    
    ### GetRuntime Keyword Pre-processing ###
    ${WIP_TransactionType}    Acquire Argument Value    ${sWIP_TransactionType}
    ${WIP_AwaitingApprovalStatus}    Acquire Argument Value    ${sWIP_AwaitingApprovalStatus}
    ${WIP_OutstandingType}    Acquire Argument Value    ${sWIP_OutstandingType}
    ${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}

    Select Actions    [Actions];Work In Process
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    Mx Native Type    {ENTER}
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingApprovalStatus}
    Mx Native Type    {ENTER}
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}
    Mx Native Type    {ENTER} 
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType} 
    Mx Native Type    {PGDN} 
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%d
    Sleep    3s  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    mx LoanIQ activate    ${LIQ_Breakfunding_AwaitingApproval_Window}
    
Approve Breakfunding
    [Documentation]    This keyword approves the Breakfunding.
    ...     @author: jcdelacruz
    ...     @update: sahalder    10JUL2020    Added steps for taking screenshots    
    Mx LoanIQ Select Window Tab    ${LIQ_Breakfunding_AwaitingApproval_Tab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakfundingFee_Approval
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Breakfunding_WorkflowItems_AwaitingApproval_List}    Approval%yes 
    Mx LoanIQ DoubleClick    ${LIQ_Breakfunding_WorkflowItems_AwaitingApproval_List}    Approval  
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    :FOR    ${i}    IN RANGE    2
    \    ${Warning_Status}    Run Keyword And Return Status    Run Keyword And Ignore Error    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}    VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==False
    \    Run Keyword And Ignore Error    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    Run Keyword And Ignore Error    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Breakfunding_AwaitingRelease_Window}            VerificationData="Yes"
    
Release Breakfunding via WIP LIQ Icon
    [Documentation]    This keyword navigates the breakfunding to be approved from Work in Process window
    ...     @author: jcdelacruz
    ...     @update: sahalder    08JUL2020    Added keyword pre-processing steps
    [Arguments]    ${sWIP_TransactionType}    ${sWIP_AwaitingReleaseStatus}    ${sWIP_OutstandingType}
    
    ### GetRuntime Keyword Pre-processing ###
	${WIP_TransactionType}    Acquire Argument Value    ${sWIP_TransactionType}
	${WIP_AwaitingReleaseStatus}    Acquire Argument Value    ${sWIP_AwaitingReleaseStatus}
	${WIP_OutstandingType}    Acquire Argument Value    ${sWIP_OutstandingType}

    ${Loan_Alias}    Read Data From Excel    SERV40_BreakFunding    Loan_Alias    ${rowid}
    Open Breakfunding Fee Notebook via WIP - Awaiting Release    ${WIP_TransactionType}    ${WIP_AwaitingReleaseStatus}    ${WIP_OutstandingType}    ${Loan_Alias}
    Release Breakfunding
    
Open Breakfunding Fee Notebook via WIP - Awaiting Release
    [Documentation]    This keyword is used to open the Breakfunding Fee Notebook with an Awaiting Approval Status thru the LIQ WIP Icon.
    ...     @author: jcdelacruz
    ...     @update: sahalder    10JUL2020    Added keyword pre-processing steps
    [Arguments]    ${sWIP_TransactionType}    ${sWIP_AwaitingReleaseStatus}    ${sWIP_OutstandingType}    ${sLoan_Alias}
    
    ### GetRuntime Keyword Pre-processing ###
    ${sIP_TransactionType}    Acquire Argument Value    ${sWIP_TransactionType}
    ${WIP_AwaitingReleaseStatus}    Acquire Argument Value    ${sWIP_AwaitingReleaseStatus}
    ${WIP_OutstandingType}    Acquire Argument Value    ${sWIP_OutstandingType}
    ${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}
  
    Select Actions    [Actions];Work In Process
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}   
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionList}    Payments
    Mx Native Type    {ENTER}    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingReleaseStatus}        
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingReleaseStatus} 
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}  
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType} 
    Mx Native Type    {PGDN} 
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%d
    Sleep    3s  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    mx LoanIQ activate    ${LIQ_Breakfunding_AwaitingRelease_Window}
    
Release Breakfunding
    [Documentation]    This keyword approves the Breakfunding.
    ...    @author: jcdelacruz
    ...    @update: sahalder    10JUL2020    Added steps for taking screenshots  
    ...    @update: mcastro    11JAN2021    - Added additional Closing of Cashflow window if present 
    Mx LoanIQ Select Window Tab    ${LIQ_Breakfunding_AwaitingRelease_Tab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakfundingFee_Release
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Breakfunding_WorkflowItems_AwaitingRelease_List}    Release%yes 
    Mx LoanIQ DoubleClick    ${LIQ_Breakfunding_WorkflowItems_AwaitingRelease_List}    Release  
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    :FOR    ${i}    IN RANGE    2
    \    ${Warning_Status}    Run Keyword And Return Status    Run Keyword And Ignore Error    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}    VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==False
    \    Run Keyword And Ignore Error    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    Run Keyword And Ignore Error    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Breakfunding_Released_Window}    VerificationData="Yes"
    Mx LoanIQ click element if present    ${LIQ_Cashflows_OK_Button}
    mx LoanIQ select    ${LIQ_Breakfunding_FileExit_Menu}    
   
Get Expense Code from Deal
    [Documentation]    This keyword saves the expense code located in Personnel tab from Deal Notebook.
    ...     @author: jcdelacruz
    ...     @update: sahalder    08JUL2020    Added keyword pre-processing steps
    [Arguments]    ${srowid}
    
    ### GetRuntime Keyword Pre-processing ###
	${rowid}    Acquire Argument Value    ${srowid}

    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Personnel    
    ${ExpenseCode}    Mx LoanIQ Get Data    ${LIQ_DealPersonnelExpenseCode_Textfield}    ExpenseCode
    Write Data To Excel    SERV40_BreakFunding    Expense_Code    ${rowid}    ${ExpenseCode}     


Add Remittance Instruction in Cashflow - Breakfunding
    [Arguments]    ${Borrower}    ${Lender2}    ${Lender3}    ${Remittance_Description}
    Verify if Method has Remittance Instruction - Breakfunding    ${Borrower}    ${Remittance_Description}
	Verify if Method has Remittance Instruction - Breakfunding    ${Lender2}    ${Remittance_Description}
	Verify if Method has Remittance Instruction - Breakfunding    ${Lender3}    ${Remittance_Description}

	Verify if Status is set to Do It - Breakfunding    ${Borrower}
	Verify if Status is set to Do It - Breakfunding    ${Lender2}
	Verify if Status is set to Do It - Breakfunding    ${Lender3}
    

Get Transaction Amount
    [Documentation]    This keyword is used to get transaction amount from Cashflow
    ...    @author: ritragel
    [Arguments]    ${LIQCustomer_ShortName}
    ${BrwTransactionAmount}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_BreakFunding_Cashflows_List}    ${LIQCustomer_ShortName}%Tran Amount%Tran
    ${CashflowTranAmount}    Remove String    ${BrwTransactionAmount}    ,
    ${UiTranAmount}    Convert To Number    ${CashflowTranAmount}    2
    Log To Console    ${UiTranAmount} 
    [Return]    ${UiTranAmount}
 
Compute Lender Share Transaction Amount - Breakfunding
    [Documentation]    This keyword is used to compute for the Lender Share Transaction Amount.
    ...    @author: rtarayao  
    [Arguments]    ${LenderSharePct}
    
    ${Loan_CalculatedFixedPayment}    Read Data From Excel    SERV40_BreakFunding    Loan_RequestedAmount    ${rowid}
    Log    ${Loan_CalculatedFixedPayment} 
    
    ${status}    Run Keyword And Return Status    Should Contain    ${Loan_CalculatedFixedPayment}    ,           
    Run Keyword If    '${status}'=='True'    Remove String    ${Loan_CalculatedFixedPayment}    ,
    ${LenderSharePct}    Evaluate    ${LenderSharePct}/100
    ${LenderShareTranAmt}    Evaluate    ${Loan_CalculatedFixedPayment}*${LenderSharePct}   
    ${LenderShareTranAmt}    Convert To Number    ${LenderShareTranAmt}    2
    Log    ${LenderShareTranAmt}
    [Return]    ${LenderShareTranAmt}

Get Debit Amount
    [Documentation]    This keyword is used to get debit amount in GL Entries
    ...    @author: ritragel
    [Arguments]    ${LIQCustomer_ShortName}
    ${DebitAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${LIQCustomer_ShortName}%Debit Amt%Debit
    ${GLEntryAmt}    Remove String    ${DebitAmt}    ,
    ${UiGLEntryAmt}    Convert To Number    ${GLEntryAmt}    2
    Log To Console    ${UiGLEntryAmt} 
    [Return]    ${UiGLEntryAmt}    

Select Breakfunding Reason
    [Documentation]    This keyword is used to select breakfunding reason when releasing payment
    ...    @author: ritragel    09SEP2019
    ...    @update: mcastro    17DEC2020    - Updated screenshot path, added pre-processing keyword
    [Arguments]    ${sReason}

    ### Pre-processing Keyword ###
    ${Reason}    Acquire Argument Value    ${sReason}

    Mx LoanIQ activate window    ${LIQ_UnscheduledPrincipalPayment_Breakfunding_Window}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_UnscheduledPrincipalPayment_Breakfunding_ComboBox}     ${Reason}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/BreakfundingReason
    Mx LoanIQ click    ${LIQ_UnscheduledPrincipalPayment_Breakfunding_OK_Button}

Navigate to Breakfunding Window from Loan Notebook
    [Documentation]    This keyword is used to Navigate to breakfunding window from Loan Notebook
    ...    @author: mcastro    17DEC2020    - Initial Create
    ...    @update: mcastro    14JAN2021    - Updated with global variable, added logging of passed/failed validation
    
    Mx LoanIQ Select Window Tab    ${LIQ_LoanNotebook_BbsyBidLoan_Tab}    ${PENDING_STATUS}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakfundingPendingTab

    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_LoanNotebook_PendingItems_List}    ${BREAK_COST_FEE}%yes
    Run Keyword If    ${Status}==${True}    Log    ${BREAK_COST_FEE} is displayed.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    ${BREAK_COST_FEE} is not displayed.

    Mx LoanIQ Select String    ${LIQ_LoanNotebook_PendingItems_List}    ${BREAK_COST_FEE}        
    Mx Press Combination    Key.ENTER
    Mx LoanIQ activate    ${LIQ_Breakfunding_Pending_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakfundingPendingTab   

Navigate to Breakfunding Complete Cashflow Window
    [Documentation]    This keyword is used to navigate to Breakfunding Complete Workflow Transaction window.
    ...    @author: mcastro    11JAN2021    - Initial Create
    
    Mx LoanIQ activate    ${LIQ_Breakfunding_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Breakfunding_Workflow_Tab}    ${WORKFLOW_TAB}

    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_Breakfunding_WorkflowItems_List}    ${COMPLETE_CASHFLOWS_WORKFLOW}%yes
    Run Keyword If    ${Status}==${True}    Log    Complete Cashflow is displayed.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Complete Cashflow is not displayed.
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CompleteCashflow
    Mx LoanIQ DoubleClick    ${LIQ_Breakfunding_WorkflowItems_List}    ${COMPLETE_CASHFLOWS_WORKFLOW}
    Mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CompleteCashflow
    Mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ activate window    ${LIQ_Cashflows_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CompleteCashflow

Verify if Cashflow is Completed for Breakfunding
    [Documentation]    This keyword validates that Complete Cashflow is not in the list of Break Cost Fee workflow tab.
    ...    @author: mcastro    11JAN2021    - Initial create

    Mx LoanIQ activate    ${LIQ_Breakfunding_Window}
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_Breakfunding_WorkflowItems_List}    ${COMPLETE_CASHFLOWS_WORKFLOW}%no
    Run Keyword If    ${Status}==${True}    Log    Complete Cashflow is no longer displayed.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Complete Cashflow is still displayed.
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakfundingWorkflowTab 

Generate and Add Intent Notice Comment on Breakfunding
    [Documentation]    This keyword is used to generate intent notice with adding of comments on breakfunding
    ...    @author: mcastro    14JAN2021    - Initial Create
    [Arguments]    ${sSubject}    ${sComment}

    ### Keyword Pre-processing ###
    ${Subject}    Acquire Argument Value    ${sSubject}
    ${Comment}    Acquire Argument Value    ${sComment}

    Mx LoanIQ click element if present    ${LIQ_BreakFundingCashflow_Ok_Button}
    Mx LoanIQ activate window    ${LIQ_Breakfunding_AwaitingSend_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Breakfunding_AwaitingSend_Tab}    ${WORKFLOW_TAB}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/GenerateIntentNotice

    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_Breakfunding_WorkflowItems_AwaitingSend_List}    ${GENERATE_INTENT_NOTICES}%yes
    Run Keyword If    ${Status}==${True}    Log    ${GENERATE_INTENT_NOTICES} is displayed.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    ${GENERATE_INTENT_NOTICES} is not displayed.

    Mx LoanIQ DoubleClick    ${LIQ_Breakfunding_WorkflowItems_AwaitingSend_List}    ${GENERATE_INTENT_NOTICES}
    Mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/GenerateIntentNotice
    mx LoanIQ activate window    ${LIQ_Notices_Window}

    ${Status}    Run Keyword And Return Status    Validate if Element is Checked    ${LIQ_Notices_Lenders_Checkbox}    Lenders
    Run Keyword If    ${Status}==${True}    Log    Lenders checkbox is checked.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Lenders checkbox is unchecked.

    ${Status}    Run Keyword And Return Status    Validate if Element is Checked    ${LIQ_Notices_BorrowerDepositor_Checkbox}    Borrower / Depositor
    Run Keyword If    ${Status}==${True}    Log    Borrower / Depositor checkbox is checked.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Borrower / Depositor checkbox is unchecked.

    mx LoanIQ click    ${LIQ_Notices_Ok_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/NoticeWindow
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

    Mx LoanIQ activate window    ${LIQ_EventFeePaymentGroup_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/NoticeWindow

    Add Notice Group Comment on Breakfunding    ${Subject}    ${Comment}
    
    Mx LoanIQ click    ${LIQ_EventFeePaymentGroup_Exit_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/GenerateIntentNotice
    
Add Notice Group Comment on Breakfunding
    [Documentation]    This keyword is used to add notice group comment on breakfunding
    ...    @author: mcastro    14JAN2021    - Initial Create
    [Arguments]    ${sSubject}    ${sComment}

    ### Keyword Pre-processing ###
    ${Subject}    Acquire Argument Value    ${sSubject}
    ${Comment}    Acquire Argument Value    ${sComment}

    Mx LoanIQ Click    ${LIQ_EventFeePaymentGroup_GroupComment_Button}
    Mx LoanIQ Click Element if Present    ${LIQ_Warning_Yes_Button}
 
    Mx LoanIQ activate window    ${LIQ_Notice_CommentEdit_Window}
    Mx LoanIQ Enter    ${LIQ_Notice_CommentEdit_Subject_Textbox}    ${Subject}
    Mx LoanIQ Enter    ${LIQ_Notice_CommentEdit_Comment_Textbox}    ${Comment}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/NoticeGroupComment
    Mx LoanIQ Click    ${LIQ_Notice_CommentEdit_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/GenerateIntentNotice

Navigate to Breakfunding Window
    [Documentation]    This keyword is used to navigate to Breakfunding Window from Loan Events tab
    ...    @author: mcastro    15JAN2021    - Initial Create
    [Arguments]    ${sDeal_Name}    ${sOutstandingSelect_Type}    ${sFacility_Name}    ${sLoan_Alias}   ${sEvents}

    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${OutstandingSelect_Type}    Acquire Argument Value    ${sOutstandingSelect_Type}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}
    ${Events}    Acquire Argument Value    ${sEvents}

    Search for Deal    ${Deal_Name}
    Search for Existing Outstanding    ${OutstandingSelect_Type}    ${Facility_Name}
    Open Existing Loan    ${Loan_Alias}

    Mx LoanIQ activate    ${LIQ_LoanNotebook_BbsyBidLoan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanNotebook_BbsyBidLoan_Tab}    ${EVENTS_TAB}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Loan_EventsTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Loan_Events_List}    ${Events}%d  
    Mx LoanIQ activate window    ${LIQ_Breakfunding_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakfundingWindow

Validate Release of Breakfunding
    [Documentation]    This keyword validates the Released status of breakfunding
    ...    @author: mcastro    15JAN2021    - Initial Create
    
    Mx LoanIQ activate window    ${LIQ_Breakfunding_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Breakfunding_Workflow_Tab}    ${EVENTS_TAB}
    ${Event_Selected}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_Breakfunding_Events_JavaTree}    ${RELEASED_STATUS}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Breakfunding_EventsTab
    Run Keyword If    ${Event_Selected}==${True}    Log    ${RELEASED_STATUS} is shown in the Events list of the Breakfunding notebook.
    ...    ELSE    Run Keyword and Continue on Failure    Fail    Breakfunding payment is not Released.

Validate Fees of Breakfunding on General Tab
    [Documentation]    This keyword is used to validate amounts on breakfunding general tab
    ...    @author: mcastro    15JAN2021    - Initial Create
    [Arguments]    ${sExpected_Fees}

    ### Keyword Pre-processing ###
    ${Expected_Fees}    Acquire Argument Value    ${sExpected_Fees}

    Mx LoanIQ activate window    ${LIQ_Breakfunding_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Breakfunding_Workflow_Tab}    ${GENERAL_TAB}

    ### Host Bank Fees Amount ###
    ${HostBankFees_Amount}    Mx LoanIQ Get Data    ${LIQ_Breakfunding_HostBankFees_Text}    value%Amount
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${HostBankFees_Amount}    ${Expected_Fees}
    Run Keyword If    ${Status}==${True}    Log    Total Host Bank Fees is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Total Host Bank Fees is incorrect. Expected: ${Expected_Fees} - Actual: ${HostBankFees_Amount}

    ### Total Borrower Fees Amount ###
    ${HostBankFees_Amount}    Mx LoanIQ Get Data    ${LIQ_Breakfunding_HostBankFees_Text}    value%Amount
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${HostBankFees_Amount}    ${Expected_Fees}
    Run Keyword If    ${Status}==${True}    Log    Total Host Bank Fees is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Total Host Bank Fees is incorrect. Expected: ${Expected_Fees} - Actual: ${HostBankFees_Amount}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Breakfunding_GeneralTab

Navigate to Breakfunding Window from Inactive Loan Notebook
    [Documentation]    This keyword is used to Navigate to breakfunding window from an Inactive Loan Notebook
    ...    @author: javinzon    14JAN2021    - Initial create

    Mx LoanIQ Select Window Tab    ${LIQ_InactiveLoan_Tab}    Pending
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakfundingPendingTab
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_InactiveLoanNotebook_PendingItems_List}    Break Cost Fee%yes
    Run Keyword If    ${Status}==${True}    Run Keywords    Mx LoanIQ Select String    ${LIQ_InactiveLoanNotebook_PendingItems_List}    Break Cost Fee 
    ...    AND    Mx Press Combination    Key.ENTER
    ...    AND    Mx LoanIQ activate    ${LIQ_Breakfunding_Pending_Window}
    ...    AND    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BreakfundingPendingTab 
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Break Cost Fee transaction is not existing in this deal
