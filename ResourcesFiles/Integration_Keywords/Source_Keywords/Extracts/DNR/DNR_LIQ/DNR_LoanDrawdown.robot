*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Create Revolver Facility Drawdown for DNR
    [Documentation]    This high-level keyword for creating an initial Loan Drawdown from a Revolver Facility with Different Currency, and API validation.
    ...    @author: fluberio    26NOV2020    - initial Create    
    [Arguments]    ${ExcelPath}
    
    ${Current_Date}    Get System Date
    ${BaseRatePercentage}    Get Base Rate from Funding Rate Details    BBSY    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_Currency]
    ${ExchangeRate}    Get Currency Exchange Rate from Treasury Navigation    &{ExcelPath}[CurrencyExchange]
    
    ### Get data from Secondary Sale test case ###
    ${Borrower_ShortName}    Read Data From Excel    SC2_DealSetup    Borrower_ShortName    &{ExcelPath}[rowid]    ${DNR_DATASET}
    ${Lender1_ShortName}    Read Data From Excel    SC2_SecondarySale    Buyer_Lender    &{ExcelPath}[rowid]    ${DNR_DATASET}
    ${Lender2_ShortName}    Read Data From Excel    SC2_SecondarySale    Buyer_Lender_2    &{ExcelPath}[rowid]    ${DNR_DATASET}
    ${Lender1_Share}    Read Data From Excel    SC2_SecondarySale    PctofDeal    &{ExcelPath}[rowid]    ${DNR_DATASET}
    ${Lender2_Share}    Read Data From Excel    SC2_SecondarySale    PctofDeal2    &{ExcelPath}[rowid]    ${DNR_DATASET}
    ${HostBankLender_Share}    Evaluate    100-(${Lender1_Share}+${Lender2_Share})    
    ${Portfolio_Name}    Read Data From Excel    SC2_LoanDrawdown    Portfolio    &{ExcelPath}[rowid]    ${DNR_DATASET}
    ${Portfolio_ExpenseCode}    Read Data From Excel    SC2_LoanDrawdown    Expense_Code    &{ExcelPath}[rowid]    ${DNR_DATASET}
    ${Portfolio_ExpenseCode}    Fetch From Left    ${Portfolio_ExpenseCode}    -
    ${HostBank_CustomerPortfolio}    Set Variable    CB001/${Portfolio_Name}/${Portfolio_ExpenseCode}
    
    ### Open existing Deal and go to Facility Notebook ###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
	### GET CUSTOMER LENDER LEGAL NAME TO BE USED IN INTENT NOTICE VALIDATION ###
    ${Lender1_LegalName}    Get Customer Lender Legal Name Via Lender Shares In Deal Notebook    ${Lender1_ShortName}
    ${Lender2_LegalName}    Get Customer Lender Legal Name Via Lender Shares In Deal Notebook    ${Lender2_ShortName}
    
    Open Facility From Deal Notebook    &{ExcelPath}[Facility_Name]
    ${Facility_Expiry}            Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_ExpiryDate_Datefield}
    ${Facililty_Currency}         Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_Currency_StaticText}
    ${PreOutstandingAmt_GFA}      Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_GlobalFacilityAmount_Outstandings}
    ${PreOutstandingAmt_HBG}      Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_HostBankOutstanding}
    ${PreOutstandingAmt_HBN}      Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_HostBankNet_Outstandings}
    ${PreAvailToDraw_GFA}         Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_HostBankAvailToDraw}
    ${PreAvailToDraw_HBG}         Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_GlobalFacAmt_AvailToDraw_Amount}
    ${PreAvailToDraw_HBN}         Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_HostBankNet_AvailToDrawNet}
    
    ### Go to Outstanding Select and create new Loan Drawdown ###
    Navigate to Outstanding Select Window
    ${Loan_Alias}    New Outstanding Select    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    ${Borrower_ShortName}    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_Currency]
    Write Data To Excel    SC2_LoanDrawdown    Loan_Alias    &{ExcelPath}[rowid]    ${Loan_Alias}    ${DNR_DATASET}
    Write Data To Excel    SC2_LoanSplit    Loan_Alias    &{ExcelPath}[rowid]    ${Loan_Alias}    ${DNR_DATASET}
    
    ### Set General tab details in the Initial Loan Drawdown Notebook ###
    #${API_NBD_Date}    Read Data From Excel    SC2_LoanDrawdown    NonBusinessDay_Date    &{ExcelPath}[rowid]    ${DNR_DATASET}
    
    Enter Initial Loan Drawdown General Details    &{ExcelPath}[Loan_RequestedAmount]    ${Current_Date}    ${EMPTY}    &{ExcelPath}[Loan_Accrue]    &{ExcelPath}[Loan_Currency]    &{ExcelPath}[Loan_RepricingFrequency]
    
    ### Set Rates in Initial Drawdown notebook ###
    Set Base Rate In Drawdown Notebook With API Validations    ${BaseRatePercentage}
    
    ### Cashflow Notebook - Create Cashflows ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Verify if Method has Remittance Instruction    ${Borrower_ShortName}    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    ${Lender1_ShortName}    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Verify if Method has Remittance Instruction    ${Lender2_ShortName}    &{ExcelPath}[Remittance3_Description]    &{ExcelPath}[Remittance3_Instruction]
    Verify if Status is set to Do It    ${Borrower_ShortName}
    Verify if Status is set to Do It    ${Lender1_ShortName}
    Verify if Status is set to Do It    ${Lender2_ShortName}
    
    ### Get Transaction Amount for Cashflow ###
    ${HostBankShare}    Get Host Bank Cash in Cashflow    &{ExcelPath}[Loan_Currency]
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    ${Borrower_ShortName}
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    ${Lender1_ShortName}
    ${Lend2TranAmount}    Get Transaction Amount in Cashflow    ${Lender2_ShortName}
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    ${HostBankLender_Share}
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    ${Lender1_Share}
    ${ComputedLend2TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    ${Lender2_Share}
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}|${ComputedLend2TranAmount}
    
    mx LoanIQ click    ${LIQ_Cashflows_OK_Button}
    ### Send to Approval ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    Validate Window Title Status    ${INITIAL_DRAWDOWN_TITLE}    ${AWAITING_APPROVAL_STATUS}
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${APPROVAL_STATUS}
    Validate Window Title Status    ${INITIAL_DRAWDOWN_TITLE}    ${AWAITING_SEND_TO_RATE_APPROVAL_STATUS}
    
    ### Go back to original user ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Set FX Rates ###
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${SEND_TO_RATE_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}    ### commented out in IEE testing
    
    
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${SEND_TO_RATE_APPROVAL_STATUS}
    Validate Window Title Status    ${INITIAL_DRAWDOWN_TITLE}    ${AWAITING_RATE_APPROVAL_STATUS}
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RATE_APPROVAL_TRANSACTION}
    Validate Window Title Status    ${INITIAL_DRAWDOWN_TITLE}    ${AWAITING_RELEASE_STATUS}
       
    ### Release Cashflows ###
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Borrower_ShortName]
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance2_Instruction]    &{ExcelPath}[Lender1_ShortName]
    #Navigate to Loan Drawdown Workflow and Proceed With Transaction    Release Cashflows
    
    ### Release ###
    Close All Windows on LIQ
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Sleep    5s
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    Validate Window Title Status    ${INITIAL_DRAWDOWN_TITLE}    ${RELEASED_STATUS}
    
    ### Validate details in Currency tab ###
    ${Computed_Current}    ${Computed_HostBankGross}    ${Computed_HostBanknet}    Validate Initial Drawdown Currency Tab Details    &{ExcelPath}[Loan_Currency]    ${Facililty_Currency}    &{ExcelPath}[CurrencyExchange]
    ...    ${ExchangeRate}    &{ExcelPath}[Loan_RequestedAmount]    ${HostBankLender_Share}  
    
   
    
    ### Post Validations in Facility Notebook ###
    Go To Facility From Initial Drawdown Notebook
    Post Validation Of Computed Amounts In Facility After Drawdown    ${HostBankLender_Share}    ${Computed_Current}    ${Computed_HostBankGross}    ${Computed_HostBanknet}
    ...    ${PreOutstandingAmt_GFA}    ${PreOutstandingAmt_HBG}    ${PreOutstandingAmt_HBN}
    Post Validation Of Facility Summary Amounts After Drawdown    ${PreOutstandingAmt_GFA}    ${PreOutstandingAmt_HBG}    ${PreOutstandingAmt_HBN}
    ...    ${PreAvailToDraw_GFA}    ${PreAvailToDraw_HBG}    ${PreAvailToDraw_HBN}
    
    ### Close all windows and go back to original user ###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}