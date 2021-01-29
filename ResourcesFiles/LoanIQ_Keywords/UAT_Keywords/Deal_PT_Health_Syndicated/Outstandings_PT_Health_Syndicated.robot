*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Initial Loan Drawdown for PT Health
    [Documentation]    This high-level keyword is used to setup the outstanding for PIM Future BILAT facility
    ...    @author: songchan    27JAN2021    - initial create
    [Arguments]    ${ExcelPath}

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    Navigate to Outstanding Select Window from Deal
    ${Loan_Alias}    New Outstanding Select    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Outstanding_Currency]
    
    Write Data To Excel    SERV01_LoanDrawdown    Loan_Alias    ${rowid}    ${Loan_Alias}


    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_MaturityDate]    &{ExcelPath}[Loan_RepricingFrequency]    
    ...    &{ExcelPath}[Loan_IntCycleFrequency]    &{ExcelPath}[Loan_Accrue]    &{ExcelPath}[Loan_RepricingDate]

    ### Cashflow Notebook - Create Cashflows ###
    Navigate to Drawdown Cashflow Window
    Verify if Method has Remittance Instruction    &{ExcelPath}[Customer_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Customer_ShortName]  
    Navigate to GL Entries
    Close GL Entries and Cashflow Window

    ### Send to Approval and Approved ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction   ${SEND_TO_APPROVAL_STATUS}
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}     ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${APPROVAL_STATUS}


    ### Rate Setting ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_SETTING}    ${LOAN_INITIAL_DRAWDOWN_TYPE}     ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RATE_SETTING_TRANSACTION}
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

    Close All Windows on LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]   &{ExcelPath}[Facility_Name]    ${Loan_Alias}
    Validate Loan Drawdown Amounts in General Tab    &{ExcelPath}[Expctd_LoanGlobalOriginal]    &{ExcelPath}[Expctd_LoanGlobalCurrent]    &{ExcelPath}[Expctd_LoanHostBankGross]    &{ExcelPath}[Expctd_LoanHostBankNet]
    Validate Loan Drawdown General Details in General Tab    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_RepricingDate]    &{ExcelPath}[Loan_PaymentMode]    &{ExcelPath}[Expctd_Loan_IntCycleFrequency]
    Validate Loan Drawdown Rates in Rates Tab    &{ExcelPath}[Expctd_LoanCurrentBaseRate]    &{ExcelPath}[Expctd_LoanSpread]    &{ExcelPath}[Expctd_LoanAllInRate]

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}