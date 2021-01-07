*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Break Cost for Early Prepayment for PIM Future BILAT
    [Documentation]    This Keyword initiates Interest Payment of the specified Loan
    ...    @update: mcastro    17DEC2020    - Initial Create
    [Arguments]    ${ExcelPath}

    ### Read data from Loan Drawdown and Comprehensive repricing sheets ###
    ${Deal_Name}    Read Data From Excel    SERV01_LoanDrawdown    Deal_Name    ${rowid}
    ${Facility_Name}    Read Data From Excel    SERV01_LoanDrawdown    Facility_Name    ${rowid}
    ${OutstandingSelect_Type}    Read Data From Excel    SERV01_LoanDrawdown    Outstanding_Type    ${rowid}
    ${Borrower_Name}    Read Data From Excel    SERV01_LoanDrawdown    Borrower_Name    ${rowid}
    ${Loan_Alias}    Read Data From Excel    SERV08_ComprehensiveRepricing    NewLoan_Alias    ${rowid}

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Open Loan Notebook ###
    Search for Deal    ${Deal_Name}
    Search for Existing Outstanding    ${OutstandingSelect_Type}    ${Facility_Name}
    Open Existing Loan    ${Loan_Alias}

    ### Breakfunding Notebook ###
    Navigate to Breakfunding Window from Loan Notebook
    Generate Lender Shares for Bilateral Deal    &{ExcelPath}[Legal_Entity]    &{ExcelPath}[Legal_Entity_Amount]
    Add Portfolio and Expense Code    &{ExcelPath}[Legal_Entity]    &{ExcelPath}[Legal_Entity_Amount]    &{ExcelPath}[Expense_Code]

    ### Cashflow Window ###
    Create Cashflow for Break Funding
    Set All Items to None
    
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