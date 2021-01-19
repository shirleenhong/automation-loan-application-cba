*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Break Cost for Early Prepayment for PIM Future BILAT
    [Documentation]    This Keyword initiates Interest Payment of the specified Loan
    ...    @update: mcastro    17DEC2020    - Initial Create
    ...    @update: mcastro    15JAN2021    - Added reading of ${Notice_Comment} from data set, Added writing of ${Loan_Alias}
    ...                                     - Added handling when adding of notice group comment is required
    ...                                     - Updated argument variable for approving releasing of breakfunding to use Global Variable
    ...                                     - Added validation of Release Status and Fees
    [Arguments]    ${ExcelPath}

    ### Read data from Loan Drawdown and Comprehensive repricing sheets ###
    ${Deal_Name}    Read Data From Excel    SERV01_LoanDrawdown    Deal_Name    1
    ${Facility_Name}    Read Data From Excel    SERV01_LoanDrawdown    Facility_Name    1
    ${OutstandingSelect_Type}    Read Data From Excel    SERV01_LoanDrawdown    Outstanding_Type    1
    ${Borrower_Name}    Read Data From Excel    SERV01_LoanDrawdown    Borrower_Name    1
    ${Loan_Alias}    Read Data From Excel    SERV08_ComprehensiveRepricing    NewLoan_Alias    1
    ${Notice_Comment}    Read Data From Excel    SERV40_BreakFunding    Notice_Comment    ${rowid}   

    ### Writing of Loan Alias ###
    Write Data To Excel    SERV40_BreakFunding    Loan_Alias    ${rowid}    ${Loan_Alias}

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
    Run Keyword If    '${Notice_Comment}'=='${EMPTY}'    Generate Intent Notices - Break Funding
    ...    ELSE    Generate and Add Intent Notice Comment on Breakfunding    &{Excelpath}[Notice_Subject]    &{Excelpath}[Notice_Comment] 

    ### Send to approval ###
	Send Breakfunding to Approval

    ### Approve Breakfunding ###
	Logout from Loan IQ
	Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
	Approve Breakfunding via WIP LIQ Icon    ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${BREAK_COST_FEE}

    ### Release Breakfunding ###
	Release Breakfunding via WIP LIQ Icon    ${PAYMENTS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${BREAK_COST_FEE}

    ### Validate Released Breakfunding ###
    Navigate to Breakfunding Window    ${Deal_Name}    ${OutstandingSelect_Type}    ${Facility_Name}    ${Loan_Alias}    &{ExcelPath}[Loan_Events]
    Validate Release of Breakfunding
    Validate Fees of Breakfunding on General Tab    &{ExcelPath}[Legal_Entity_Amount]

    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}