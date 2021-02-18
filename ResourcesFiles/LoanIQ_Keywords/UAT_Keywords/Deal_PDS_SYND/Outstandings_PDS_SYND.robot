*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Create Loan Drawdown for PDS Syndicate Deal - Outstanding A
    [Documentation]    This high-level keyword is used to setup the loan drawdown for PDS Syndicated Deal Outsanding A - 09/18/19
    ...    @author:    shirhong    10FEB2021    - Initial Create
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup_A    Facility_Name    1
    ${Borrower_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    1
    ${Customer_Name}    Read Data From Excel    CRED01_DealSetup    Deal_AdminAgent    1

    ### Login using Inputter ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    ${Deal_Name}

    ### Create Loan Drawdown ###
    Navigate to Outstanding Select Window from Deal
    ${Loan_Alias}    New Outstanding Select    ${Deal_Name}    ${FacilityName}    ${Borrower_Name}    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Outstanding_Currency]
    Write Data To Excel    SERV01_LoanDrawdown    Loan_Alias    &{ExcelPath}[rowid]    ${Loan_Alias}

    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_MaturityDate]    &{ExcelPath}[Loan_RepricingFrequency]    
    ...    &{ExcelPath}[Loan_IntCycleFrequency]    &{ExcelPath}[Loan_Accrue]    &{ExcelPath}[Loan_RepricingDate]

    ### Cashflow Notebook - Create Cashflows ###
    Navigate to Drawdown Cashflow Window
    Verify if Method has Remittance Instruction    ${Customer_Name}    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    ${Customer_Name}
    Navigate to GL Entries
    Close GL Entries and Cashflow Window

    ### Send to Approval ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction   ${SEND_TO_APPROVAL_STATUS}

    ### Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}     ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${APPROVAL_STATUS}

    ## Rate Setting ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_SETTING}    ${LOAN_INITIAL_DRAWDOWN_TYPE}     ${Loan_Alias}
    Set Notebook to Update Mode    ${LIQ_InitialDrawdown_Window}    ${LIQ_LoanInquiry_InitialDrawdown_Button}
    Navigate to Loan Drawdown Workflow and Proceed with Rate Setting    ${RATE_SETTING_TRANSACTION}
    Set Base Rate Details    &{ExcelPath}[Borrower_BaseRate]    &{ExcelPath}[AcceptRate_FromPricing]
    Navigate to Loan Drawdown Workflow and Proceed With Transaction        ${SEND_TO_RATE_APPROVAL_STATUS}

    ### Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}     ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction        ${RATE_APPROVAL_STATUS}

    ### Release Loan ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}     ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RELEASE_STATUS}

    ### Validate Drawdown Released Event ###
    Validate Initial Drawdown Events Tab    ${RELEASED_STATUS}

    ### Validate Drawdown Values ###
    Close All Windows on LIQ
    Open Existing Deal    ${Deal_Name}
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]   ${FacilityName}    ${Loan_Alias}
    Validate Loan Drawdown Amounts in General Tab    &{ExcelPath}[Expctd_LoanGlobalOriginal]    &{ExcelPath}[Expctd_LoanGlobalCurrent]    &{ExcelPath}[Expctd_LoanHostBankGross]    &{ExcelPath}[Expctd_LoanHostBankNet]
    Validate Loan Drawdown General Details in General Tab    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_RepricingDate]    &{ExcelPath}[Loan_PaymentMode]    &{ExcelPath}[Expctd_Loan_IntCycleFrequency]
    Validate Loan Drawdown Rates in Rates Tab    &{ExcelPath}[Expctd_LoanCurrentBaseRate]    &{ExcelPath}[Expctd_LoanSpread]    &{ExcelPath}[Expctd_LoanAllInRate]

    Close All Windows on LIQ

