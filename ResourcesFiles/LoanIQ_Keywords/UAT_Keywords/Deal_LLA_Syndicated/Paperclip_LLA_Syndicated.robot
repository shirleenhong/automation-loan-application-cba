*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Collect Early Prepayment via Paper Clip For LLA Syndicated Deal
    [Documentation]    This is a high-level keyword to collect early prepayment via paperclip
    ...    @author: makcamps    15FEB2021    - Initial Create
    [Arguments]    ${ExcelPath}

    ### Read data from Loan Drawdown and Comprehensive repricing sheets ###
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${Facility_Name}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name    1
    ${OutstandingSelect_Type}    Read Data From Excel    SERV01_LoanDrawdown    Outstanding_Type    2
    ${Borrower_Name}    Read Data From Excel    SERV01_LoanDrawdown    Borrower_ShortName    2
    ${Loan_Alias}    Read Data From Excel    SERV01_LoanDrawdown    Loan_Alias    2

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Open Loan Notebook ###
    Search for Deal    ${Deal_Name}
    Search for Existing Outstanding    ${OutstandingSelect_Type}    ${Facility_Name}
    Open Existing Loan    ${Loan_Alias}

    ### Payment Window ###
    Navigate to Choose a Payment Window
    Select Payment in Choose a Payment Window    &{ExcelPath}[Payment_Type]

    ### Paper Clip Window - Add principal ###
    Add Transaction to Pending Paperclip    &{ExcelPath}[Paperclip_EffectiveDate]    &{ExcelPath}[Paperclip_TransactionDescription]
    Select Outstanding Item    ${Loan_Alias}
    Add Transaction Type    &{ExcelPath}[Loan_Transaction_Type]    &{ExcelPath}[Loan_RequestedAmount]
    Add Transaction Type    &{ExcelPath}[Loan_Transaction_Type2]

    ### Cycles for Loan Window ###
    Select Cycles Item     &{ExcelPath}[Cycles_ForLoan]    &{ExcelPath}[Loan_CycleNumber]
    Validate Payment Amount and Interest Due on Cycles for Loan    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Interest_Due]
    Close Cycles for Loan Window
    Verify Added Paperclip Payments    &{ExcelPath}[Pricing_Option]${SPACE}(${Loan_Alias})Principal|&{ExcelPath}[Pricing_Option]${SPACE}(${Loan_Alias})Interest
    Validate Total Amount of Prepayment on Paper Clip    &{ExcelPath}[Total_Prepayment_Amount]

    ### Create and Split Cashflows ###
    Navigate to Create Cashflow for Paperclip
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance1_Description]    &{ExcelPath}[Remittance1_Instruction]
    Verify if Method has Remittance Instruction As None    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Set All Items to Do It

    ### Generate Intent Notice ###
    Navigate Notebook Workflow    ${LIQ_PendingPaperClip_Window}    ${LIQ_PaperClip_Tabs}    ${LIQ_PaperClip_Workflow_Tab}    ${GENERATE_INTENT_NOTICES} 
    Generate Intent Notices    ${Borrower_Name}
    Close Generate Notice Window

    ### Send for Approval and Approve ###
    Send Paperclip Payment for Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${PAPER_CLIP}    ${Deal_Name}
    Approve Paperclip

    ### Release Paperclip Transaction ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${PAYMENTS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${PAPER_CLIP}    ${Deal_Name}
    Release Paperclip Transaction    ${LIQ_BreakFunding_No_Button}
    ### Validate Release ###
    Validate Release of Paper Clip Payment
    Close All Windows on LIQ

    ### Validate Paper Clip Transaction on Deal Notebook ###
    Validate Release of Paper Clip Payment from Deal Notebook    ${Deal_Name}
    Close All Windows on LIQ