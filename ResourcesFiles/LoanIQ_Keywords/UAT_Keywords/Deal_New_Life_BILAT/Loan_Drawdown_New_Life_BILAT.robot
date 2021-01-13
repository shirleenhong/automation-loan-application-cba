*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Create Initial Loan Drawdown for New Life BILAT
    [Documentation]    This high-level keyword is used to setup the outstanding for New Life BILAT facility
    ...    @author: kmagday    15DEC2020    - Initial Create
    ...    @update: kmagday    12JAN2021    - added writing of Loan_Alias in SERV08_ComprehensiveRepricing sheet
    [Arguments]    ${ExcelPath}

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    Navigate to Outstanding Select Window from Deal
    ${Loan_Alias}    New Outstanding Select    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Outstanding_Currency]
    Write Data To Excel    SERV01_LoanDrawdown    Loan_Alias    ${rowid}    ${Loan_Alias}
    Write Data To Excel    Correspondence    Loan_Alias    ${rowid}    ${Loan_Alias}
    Write Data To Excel    Correspondence    Loan_Alias    2    ${Loan_Alias}
    Write Data To Excel    Correspondence    Loan_Alias    3    ${Loan_Alias}
    Write Data To Excel    SERV08_ComprehensiveRepricing    Loan_Alias    ${rowid}    ${Loan_Alias}

    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_MaturityDate]    &{ExcelPath}[Loan_RepricingFrequency]    
    ...    &{ExcelPath}[Loan_IntCycleFrequency]    &{ExcelPath}[Loan_Accrue]    &{ExcelPath}[Loan_RepricingDate]

    ### Cashflow Notebook - Create Cashflows ###
    Navigate to Drawdown Cashflow Window
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_Name]  
    Navigate to GL Entries
    Close GL Entries and Cashflow Window

    ### Approval of Loan ###
    Send Initial Drawdown to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}     ${Loan_Alias}
    Approve Initial Drawdown

    ### Generate Intent Notice ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${GENERATE_INTENT_NOTICES}    ${LOAN_INITIAL_DRAWDOWN_TYPE}     ${Loan_Alias}
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    ${GENERATE_INTENT_NOTICES} 
    Generate Intent Notices    &{ExcelPath}[Borrower_Name]
    Close Generate Notice Window

    ### Rate Setting ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RATE_SETTING_TRANSACTION}
    Set Base Rate Details    &{ExcelPath}[Loan_BorrowerBaseRate]    &{ExcelPath}[AcceptRate_FromPricing]
    Send Initial Drawdown to Rate Approval
     
    ### Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}     ${Loan_Alias}
    Approve Initial Drawdown Rate

    ### Generate Rate Setting Notice and Release Loan ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_RATE_SETTING_NOTICES_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}     ${Loan_Alias}
    Generate Rate Setting Notices for Drawdown    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[RateSetting_NoticeStatus]

    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RELEASE_STATUS}

    ### Validate Drawdown Released Event ###
    Validate Initial Drawdown Events Tab    ${RELEASED_STATUS}

    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

