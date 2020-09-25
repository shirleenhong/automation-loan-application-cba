*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup Repayment Schedule for Loans in Deal D00001053
    [Documentation]    This high-level keyword is used to create the Repayment Schedule for the Outstandings in UAT Scenario 2.
    ...                @author: bernchua    29JUL2019    Initial create
    ...                @author: bernchua    21AUG2019    Added taking of screenshots
    ...                @update: gerhabal    30AUG2019    rearrange from Tick Flexible Schedule Add Item Pay Thru Maturity keyword before
    ...    Tick Flexible Schedule Add Item PI Amount     
    ...                @update: aramos      22SEP2019    Update Screenshot
    [Arguments]    ${ExcelPath}
    
    Refresh Tables in LIQ
    
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    Set Notebook to Update Mode    ${LIQ_Loan_Window}    ${LIQ_Loan_InquiryMode_Button}
    
    Navigate from Loan to Repayment Schedule
    Select Type of Schedule    &{ExcelPath}[RepaymentSchedule_Type]
    Add Item in Flexible Schedule Window
    Tick Flexible Schedule Add Item Pay Thru Maturity
    Tick Flexible Schedule Add Item PI Amount    P&&I Amount
    Enter Flexible Schedule Add Item PI Amount    &{ExcelPath}[FlexSchedule_P&IAmount]
    Click OK in Add Items for Flexible Schedule
    Click OK in Flexible Schedule Window
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanNotebook-RepaymentSchedule
    Save and Exit Repayment Schedule For Loan
    
    Close All Windows on LIQ
    
Create Scheduled Repayment for Loans in Deal D00001053
    [Documentation]    This high-level keyword is used to create the Scheduled Repayment of Principal & Interest for the Loans in UAT Scenario 2.
    ...                @author: bernchua    09AUG2019    Initial create
    ...                @update: bernchua    21AUG2019    Rmeoved commented line
    ...                @update: gerhabal    19OCT2019    Commented scripts based on the total amount adjustment    
    ...                @update: aramos      21SEP2020    Update Validate PaperClip Notebook Details for Interest and Principal Payment for Repayment
    [Arguments]    ${ExcelPath}
    
    Refresh Tables in LIQ
    
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    Set Notebook to Update Mode    ${LIQ_Loan_Window}    ${LIQ_Loan_InquiryMode_Button}
    
    Navigate from Loan to Repayment Schedule
    # ${Interest_Amount}    ${Principal_Amount}    ${Effective_Date}    Create Pending Transaction in Repayment Schedule    &{ExcelPath}[RepaymentSched_ItemNo]
    ${Interest_Amount}    ${Principal_Amount}    ${Effective_Date}    ${Total_Amount}    Create Pending Transaction in Repayment Schedule    &{ExcelPath}[RepaymentSched_ItemNo]
    Validate PaperClip Notebook Details for Interest and Principal Payment for Repayment    ${Interest_Amount}    ${Principal_Amount}    ${Effective_Date}    &{ExcelPath}[Pricing_Option]    Scheduledzz
       
    # ${Total_Amount}    Set Variable    40,080.14
    
    Navigate Notebook Workflow    ${LIQ_Repayment_Window}    ${LIQ_Repayment_Tab}    ${LIQ_Repayment_WorkflowItems}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]    ${Total_Amount}    AUD
    # # Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]    ${Interest_Amount}    AUD
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Remittance_Instruction]    ${Total_Amount}
    # # Verify if Status is set to Do It    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Remittance_Instruction]    ${Interest_Amount}
    Click OK In Cashflows
    
    Navigate Notebook Workflow    ${LIQ_Repayment_Window}    ${LIQ_Repayment_Tab}    ${LIQ_Repayment_WorkflowItems}    Send to Approval        
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Payments    Awaiting Approval    Repayment Paper Clip    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_Repayment_Window}    ${LIQ_Repayment_Tab}    ${LIQ_Repayment_WorkflowItems}    Approval
    
    Navigate Notebook Workflow    ${LIQ_Repayment_Window}    ${LIQ_Repayment_Tab}    ${LIQ_Repayment_WorkflowItems}    Release Cashflows 
    Cashflows Mark All To Release
    Click OK In Cashflows
    
    Navigate Notebook Workflow    ${LIQ_Repayment_Window}    ${LIQ_Repayment_Tab}    ${LIQ_Repayment_WorkflowItems}    Release
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

Unscheduled Full Prepayment for Loans in Deal D00001053
    [Documentation]    This keyword will create the Unscheudled Full Prepayment for SF & GF Facilities in Deal D00001053
    ...                @author: bernchua    15AUG2019
    ...                @update: bernchua    21AUG2019    Rmeoved commented line
    [Arguments]    ${ExcelPath}
    
    Refresh Tables in LIQ
    
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    Set Notebook to Update Mode    ${LIQ_Loan_Window}    ${LIQ_Loan_InquiryMode_Button}
    
    Navigate from Loan to Repayment Schedule
    ${Current_Amount}    Get Repayment Schedule Current Loan Amount
    Add Unscheduled Transaction In Repayment Schedule    &{ExcelPath}[RepaymentSched_ItemNo]
    Select Interest Accrual Cycle
    ${CycleDue_Amount}    Select Cycles for Loan Item    Cycle Due    &{ExcelPath}[CyclesForLoan_No]
    Set Unscheudled Transaction Details    Payment    ${Current_Amount}    ${CycleDue_Amount}    &{ExcelPath}[UnschedPrepay_EffectiveDate]    Last
    
    Go To Repayment Schedule Transaction NB    U*
    Validate PaperClip Notebook Details for Interest and Principal Payment    &{ExcelPath}[UnschedPrepay_CycleDueAmount]    &{ExcelPath}[UnschedPrepay_RequestedAmount]    &{ExcelPath}[UnschedPrepay_EffectiveDate]    &{ExcelPath}[Pricing_Option]    Unscheduled
    Validate Principal Payment Notebook Details    &{ExcelPath}[UnschedPrepay_RequestedAmount]    &{ExcelPath}[PrincipalPayment_PrepayStatus]    &{ExcelPath}[UnschedPrepay_EffectiveDate]    &{ExcelPath}[Pricing_Option]    Unscheduled
    
    ${Current_Amount}    Convert Number with comma to Integer    ${Current_Amount}    
    ${CycleDue_Amount}    Convert Number with comma to Integer    ${CycleDue_Amount}
    ${Total_Amount}    Evaluate    ${Current_Amount}+${CycleDue_Amount}
    ${Total_Amount}    Convert Number With Comma Separators    ${Total_Amount}
    Log    ${Total_Amount}
       
    Navigate Notebook Workflow    ${LIQ_Repayment_Window}    ${LIQ_Repayment_Tab}    ${LIQ_Repayment_WorkflowItems}    Create Cashflows

    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]    ${Total_Amount}    AUD
   
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Remittance_Instruction]    ${Total_Amount}

    Click OK In Cashflows
    
    Navigate Notebook Workflow    ${LIQ_Repayment_Window}    ${LIQ_Repayment_Tab}    ${LIQ_Repayment_WorkflowItems}    Send to Approval        
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Payments    Awaiting Approval    Repayment Paper Clip    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_Repayment_Window}    ${LIQ_Repayment_Tab}    ${LIQ_Repayment_WorkflowItems}    Approval
    
    Navigate Notebook Workflow    ${LIQ_Repayment_Window}    ${LIQ_Repayment_Tab}    ${LIQ_Repayment_WorkflowItems}    Release Cashflows 
    Cashflows Mark All To Release
    Click OK In Cashflows
    
    Navigate Notebook Workflow    ${LIQ_Repayment_Window}    ${LIQ_Repayment_Tab}    ${LIQ_Repayment_WorkflowItems}    Release

    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
