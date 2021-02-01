*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Break Cost for Full Prepayment for LBT Bilateral Deal - Outstanding Z
    [Documentation]    This is a high-level keyword to charge break cost for full prepayment and Generate 
    ...    Intent Notice for LBT Bilateral Deal - Outstanding Z
    ...    @author: javinzon    14JAN2021    - Initial Create
    ...    @update: javinzon    29JAN2021    - Added validation if Loan is Inactive
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    Read Data From Excel    SERV01_LoanDrawdown    Deal_Name    ${rowid}
    ${Facility_Name}    Read Data From Excel    SERV01_LoanDrawdown    Facility_Name    ${rowid}
    ${OutstandingSelect_Type}    Read Data From Excel    SERV01_LoanDrawdown    Outstanding_Type    ${rowid}
    ${Borrower_Name}    Read Data From Excel    SERV01_LoanDrawdown    Borrower_Name    ${rowid}
    ${Loan_Alias}    Read Data From Excel    SERV01_LoanDrawdown    Loan_Alias    ${rowid}
    
    ### Write data to Correspondence sheet ###
    Write Data To Excel    Correspondence    Loan_Alias    2    ${Loan_Alias}
    Write Data To Excel    SERV40_BreakFunding    Loan_Alias    ${rowid}    ${Loan_Alias}
      
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Open Loan Notebook ###
    Search for Deal    ${Deal_Name}
    Search for Existing Outstanding    ${OutstandingSelect_Type}    ${Facility_Name}    &{ExcelPath}[Inactive]
    Open Existing Loan    ${Loan_Alias}

    ### Breakfunding Notebook ###
    Navigate to Breakfunding Window from Inactive Loan Notebook
    Generate Lender Shares for Bilateral Deal    &{ExcelPath}[Legal_Entity]    &{ExcelPath}[Legal_Entity_Amount]
    Add Portfolio and Expense Code    &{ExcelPath}[Legal_Entity]    &{ExcelPath}[Legal_Entity_Amount]    &{ExcelPath}[Expense_Code]

    ### Cashflow Window ###
    Create Cashflow for Break Funding
    Verify if Method has Remittance Instruction    ${Borrower_Name}    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]    
    Verify if Status is set to Do It    ${Borrower_Name}  
    Navigate to GL Entries
    Close GL Entries and Cashflow Window
    
    ### Request Lender Fees ###
    Request Lender Fees
    
    ### Intent Notice ###
    Generate Intent Notices - Break Funding

    ### Send to approval ###
	Send Breakfunding to Approval

    ### Approve Breakfunding ###
	Logout from Loan IQ
	Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
	Approve Breakfunding via WIP LIQ Icon    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingApprovalStatus]    &{ExcelPath}[WIP_OutstandingType]

    ### Release Breakfunding ###
	Release Breakfunding via WIP LIQ Icon    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingReleaseStatus]    &{ExcelPath}[WIP_OutstandingType]

    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Check Global Amount in Loan Notebook ###
    Search for Deal    ${Deal_Name}
    Search for Existing Outstanding    ${OutstandingSelect_Type}    ${Facility_Name}    &{ExcelPath}[Inactive]
    Open Existing Loan    ${Loan_Alias}
    Validate Loan Drawdown Amounts in General Tab    &{ExcelPath}[Expctd_LoanGlobalOriginal]    &{ExcelPath}[Expctd_LoanGlobalCurrent]    &{ExcelPath}[Expctd_LoanHostBankGross]    &{ExcelPath}[Expctd_LoanHostBankNet]
    Validate if Loan is Inactive
    Close All Windows on LIQ
    