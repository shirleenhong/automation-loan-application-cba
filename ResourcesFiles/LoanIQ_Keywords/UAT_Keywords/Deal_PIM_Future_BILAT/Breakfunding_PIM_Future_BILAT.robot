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
    ...    @update: mcastro    22JAN2021    - Updated ${EMPTY} to None
    ...    @update: mcastro    02FEB2021    - Removed comment for Break Cost validation since the change request for the label is confirmed
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
    Run Keyword If    '${Notice_Comment}'=='None'   Generate Intent Notices - Break Funding
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

Collect Interest for Prepaid Portion after Increase
    [Documentation]    This is a high-level keyword to collect Interest for prepaid portion breakfunding notebook after Loan increase
    ...    @author: mcastro    19JAN2021    - Initial Create
    [Arguments]    ${ExcelPath}

    ### Read data from other sheets ###
    ${Deal_Name}    Read Data From Excel    SERV01_LoanDrawdown    Deal_Name    1
    ${Borrower_Name}    Read Data From Excel    SERV01_LoanDrawdown    Borrower_Name    1
    ${Facility_Name}    Read Data From Excel    SERV01_LoanDrawdown    Facility_Name    1
    ${Expense_Code}    Read Data From Excel    CRED01_DealSetup    Deal_ExpenseCode    1
    ${Expctd_LoanGlobalOriginal}    Read Data From Excel    SERV08_ComprehensiveRepricing    New_LoanAmount    1
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Open Loan Notebook ###
    Search for Deal    ${Deal_Name}
    Search for Existing Outstanding    &{ExcelPath}[Type]    ${Facility_Name}
    Open Existing Loan    &{ExcelPath}[Loan_Alias]
    
    ### Loan Increase Notebook ###
    Navigate to Loan Increase from Loan Notebook
    Input General Loan Increase Details    &{ExcelPath}[Legal_Entity_Amount]    &{ExcelPath}[Increase_EffectiveDate]    &{ExcelPath}[Increase_Reason]

    ### Cashflow Window ###
    Navigate to Create Cashflow for Loan Increase
    Verify if Status is set to Do It    ${Borrower_Name}
    Set the Status to Send all to SPAP
    Navigate to GL Entries
    Close GL Entries and Cashflow Window

    ### Send to Approval and Approve ###
    Navigate to Loan Increase Workflow and Proceed with Transaction    ${SEND_TO_APPROVAL_STATUS}
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_INCREASE}    ${Deal_Name}
    Navigate to Loan Increase Workflow and Proceed with Transaction    ${APPROVAL_STATUS}

    ### Release Loan Increase Transaction ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${LOAN_INCREASE}    ${Deal_Name}
    Navigate to Loan Increase Workflow and Proceed with Transaction    ${RELEASE_STATUS}

    ### Validation of Loan Increase ###
    Validate Release of Loan Increase
    Validate Loan Increase Details in General Tab    &{ExcelPath}[Expected_Outstanding]     &{ExcelPath}[Legal_Entity_Amount]    &{ExcelPath}[Increase_Actual_Amount]
    Close All Windows on LIQ

    ### Complete Cashflow from Breakfunding Notebook ###
    Select Item in Work in Process    ${PAYMENTS_TRANSACTION}    ${AWAITING_COMPLETE_CASHFLOW_TRANSACTION}    ${BREAK_COST_FEE}    ${Deal_Name}
    Navigate to Breakfunding Complete Cashflow Window
    Match and Verify WIP Items    ${Borrower_Name}    &{ExcelPath}[GLShortName]    &{ExcelPath}[Effective_Date]    &{ExcelPath}[Legal_Entity_Amount]    ${Expense_Code}
    Verify Customer Status in Cashflow Window    ${Borrower_Name}    &{ExcelPath}[CashFlow_AfterStatus]
    Click OK In Cashflows
    Verify if Cashflow is Completed for Breakfunding

    ### Validate Amounts in Loan Notebook ###
    Close All Windows on LIQ
    Search for Deal    ${Deal_Name}
    Search for Existing Outstanding    &{ExcelPath}[Type]    ${Facility_Name}
    Open Existing Loan    &{ExcelPath}[Loan_Alias]
    Validate Loan Drawdown Amounts in General Tab    ${Expctd_LoanGlobalOriginal}    &{ExcelPath}[Expctd_LoanGlobalCurrent]    &{ExcelPath}[Expctd_LoanHostBankGross]    &{ExcelPath}[Expctd_LoanHostBankNet]

    Close All Windows on LIQ