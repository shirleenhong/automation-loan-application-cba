*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Collect Early Prepayment via Paper Clip For PIM Future BILAT
    [Documentation]    This is a high-level keyword to collect early prepayment via paperclip
    ...    @author: mcastro    16DEC2020    - Initial Create
    ...    @update: mcastro    05JAN2021    - Updated with correct column name, added selecting of breakfunding reason  
    [Arguments]    ${ExcelPath}

    ### Read data from Loan Drawdown and Comprehensive repricing sheets ###
    ${Deal_Name}    Read Data From Excel    SERV01_LoanDrawdown    Deal_Name    ${rowid}
    ${Facility_Name}    Read Data From Excel    SERV01_LoanDrawdown    Facility_Name    ${rowid}
    ${OutstandingSelect_Type}    Read Data From Excel    SERV01_LoanDrawdown    Outstanding_Type    ${rowid}
    ${Borrower_Name}    Read Data From Excel    SERV01_LoanDrawdown    Borrower_Name    ${rowid}
    ${NewLoan_Alias}    Read Data From Excel    SERV08_ComprehensiveRepricing    NewLoan_Alias    ${rowid}

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Open Loan Notebook ###
    Search for Deal    ${Deal_Name}
    Search for Existing Outstanding    ${OutstandingSelect_Type}    ${Facility_Name}
    Open Existing Loan    ${NewLoan_Alias}

    ### Loan Capitalization Editor ###
    Navigate to Capitalize Interest Payment from Loan Notebook
    Set Activate Interest Capitalization    &{ExcelPath}[InterestCapitalization_Status]
    
    ### Payment Window ###
    Navigate to Choose a Payment Window
    Select Payment in Choose a Payment Window    &{ExcelPath}[Payment_Type]

    ### Paper Clip Window - Add principal ###
    Add Transaction to Pending Paperclip    &{ExcelPath}[Paperclip_EffectiveDate]    &{ExcelPath}[Paperclip_TransactionDescription]
    Select Outstanding Item    ${NewLoan_Alias}
    Add Transaction Type    &{ExcelPath}[Loan_Transaction_Type]    &{ExcelPath}[Loan_RequestedAmount]
    Add Transaction Type    &{ExcelPath}[Loan_Transaction_Type2]

    ### Cycles for Loan Window ###
    Select Cycles Item     &{ExcelPath}[Cycles_ForLoan]    &{ExcelPath}[Loan_CycleNumber]
    Validate Payment Amount and Interest Due on Cycles for Loan    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Interest_Due]
    Close Cycles for Loan Window
    Verify Added Paperclip Payments    &{ExcelPath}[Pricing_Option]${SPACE}(${NewLoan_Alias})Principal|&{ExcelPath}[Pricing_Option]${SPACE}(${NewLoan_Alias})Interest

    ### Create and Split Cashflows ###
    Navigate to Split Cashflows from Paper Clip
    Populate Split Cashflow Split Interest Amount    &{ExcelPath}[Interest_Due]
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

Collect Interest for Prepaid Portion
    [Documentation]    This is a high-level keyword to collect Interest for prepaid portion from paperclip and breakfunding notebooks
    ...    @author: mcastro    11JAN2021    - Initial Create
    [Arguments]    ${ExcelPath}

    ### Read data from other sheets ###
    ${Deal_Name}    Read Data From Excel    SERV01_LoanDrawdown    Deal_Name    ${rowid}
    ${WIP_Amount}    Read Data From Excel    SERV01_LoanDrawdown    Loan_RequestedAmount    2
    ${Expense_Code}    Read Data From Excel    CRED01_DealSetup    Deal_ExpenseCode    ${rowid}
    ${Borrower_Name}    Read Data From Excel    SERV01_LoanDrawdown    Borrower_Name    ${rowid}
    ${Legal_Entity_Amount}    Read Data From Excel    SERV40_BreakFunding    Legal_Entity_Amount    ${rowid}
    ${Facility_Name}    Read Data From Excel    SERV01_LoanDrawdown    Facility_Name    ${rowid}
    ${OutstandingSelect_Type}    Read Data From Excel    SERV01_LoanDrawdown    Outstanding_Type    ${rowid}
    ${NewLoan_Alias}    Read Data From Excel    SERV08_ComprehensiveRepricing    NewLoan_Alias    ${rowid}
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Complete Cashflow in Paper Clip Payment ###
    Select Item in Work in Process    ${PAYMENTS_TRANSACTION}    ${AWAITING_COMPLETE_CASHFLOW_TRANSACTION}    ${PAPER_CLIP}    ${Deal_Name}
    Navigate to Paper Clip Complete Cashflow Window
    Match and Verify WIP Items    ${Borrower_Name}    &{ExcelPath}[GLShortName]    &{ExcelPath}[Effective_Date]    ${WIP_Amount}    ${Expense_Code}    &{ExcelPath}[Payment_Type]
	Verify Customer Status in Cashflow Window    ${Borrower_Name}    &{ExcelPath}[CashFlow_AfterStatus]
    Click OK In Cashflows
    Verify if Cashflow is Completed for Paper Clip Payment
    Close All Windows on LIQ

    ### Complete Cashflow in Breakfunding ###
    Select Item in Work in Process    ${PAYMENTS_TRANSACTION}    ${AWAITING_COMPLETE_CASHFLOW_TRANSACTION}    ${BREAK_COST_FEE}    ${Deal_Name}
    Navigate to Breakfunding Complete Cashflow Window
    Match and Verify WIP Items    ${Borrower_Name}    &{ExcelPath}[GLShortName]    &{ExcelPath}[Effective_Date]    ${Legal_Entity_Amount}    ${Expense_Code}
    Verify Customer Status in Cashflow Window    ${Borrower_Name}    &{ExcelPath}[CashFlow_AfterStatus]
    Click OK In Cashflows
    Verify if Cashflow is Completed for Breakfunding
    Close All Windows on LIQ

    ### Open Loan Notebook ###
    Search for Deal    ${Deal_Name}
    Search for Existing Outstanding    ${OutstandingSelect_Type}    ${Facility_Name}
    Open Existing Loan    ${NewLoan_Alias}

    ### Loan Capitalization Editor ###
    Navigate to Capitalize Interest Payment from Loan Notebook
    Set Activate Interest Capitalization    &{ExcelPath}[InterestCapitalization_Status2]
    Close All Windows on LIQ