*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Collect Full Prepayment via Paper Clip for LBT Bilateral Deal - Outstanding Z
    [Documentation]    This is a high-level keyword to collect full prepayment via paperclip and Generate 
    ...    Intent Notice for LBT Bilateral Deal - Outstanding Z
    ...    @author: javinzon    08JAN2020    - Initial Create    
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    Read Data From Excel    SERV01_LoanDrawdown    Deal_Name    ${rowid}
    ${Facility_Name}    Read Data From Excel    SERV01_LoanDrawdown    Facility_Name    ${rowid}
    ${Outstanding_Type}    Read Data From Excel    SERV01_LoanDrawdown    Outstanding_Type    ${rowid}
    ${Borrower_Name}    Read Data From Excel    SERV01_LoanDrawdown    Borrower_Name    ${rowid}
    ${Loan_Alias}    Read Data From Excel    SERV01_LoanDrawdown    Loan_Alias    ${rowid}

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Open Loan Notebook ###
    Search for Deal    ${Deal_Name}
    Search for Existing Outstanding    ${Outstanding_Type}    ${Facility_Name}
    Open Existing Loan    ${Loan_Alias}
    
    ### Payment Window ###
    Navigate to Choose a Payment Window
    Select Payment in Choose a Payment Window    &{ExcelPath}[Payment_Type]

    ### Paper Clip Window - Add principal and Interest ###
    Add Transaction to Pending Paperclip    &{ExcelPath}[Paperclip_EffectiveDate]    &{ExcelPath}[Paperclip_TransactionDescription]
    Select Outstanding Item    ${Loan_Alias}
    Add Transaction Type    &{ExcelPath}[Loan_Transaction_Type]    &{ExcelPath}[Loan_RequestedAmount]
    Add Transaction Type    &{ExcelPath}[Loan_Transaction_Type2]
    
    ### Cycles for Loan Window ###
    Select Cycles Item     &{ExcelPath}[Cycles_ForLoan]    &{ExcelPath}[Loan_CycleNumber]
    Close Cycles for Loan Window
    Verify Added Paperclip Payments    &{ExcelPath}[Pricing_Option]${SPACE}(${Loan_Alias})Principal|&{ExcelPath}[Pricing_Option]${SPACE}(${Loan_Alias})Interest
    Validate Interest and Pricipal Amount for Pending Paper Clip Payment    &{ExcelPath}[Loan_InterestAmount]    &{ExcelPath}[Interest_OptionType]    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Principal_OptionType] 
    
    ### Create Cashflows ###
    Navigate to Create Cashflow for Paperclip
    Verify if Method has Remittance Instruction    ${Borrower_Name}    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]    
    Verify if Status is set to Do It    ${Borrower_Name}  
    Navigate to GL Entries
    Close GL Entries and Cashflow Window
    
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
    Release Paperclip Transaction
    
    ### Breakfunding Window ###
    Select Breakfunding Reason    &{ExcelPath}[Breakfunding_Reason] 

    Close All Windows on LIQ