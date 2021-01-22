*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Create Loan Drawdown for LLA Syndicated Deal - Outstanding A
    [Documentation]    This high-level keyword is used to setup the loan drawdown for LLA Syndicated Deal
    ...    @author: makcamps    21JAN2021    - Initial Create
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    ${rowid}
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name    ${rowid}
    ${Borrower_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    ${rowid}

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    ${Deal_Name}

    ### Create Drawdown ###
    Navigate to Outstanding Select Window from Deal
    ${Loan_Alias}    New Outstanding Select    ${Deal_Name}    ${FacilityName}    ${Borrower_Name}
    ...    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Outstanding_Currency]
    Write Data To Excel    SERV01_LoanDrawdown    Loan_Alias    ${rowid}    ${Loan_Alias}    bTestCaseColumn=True    sColumnReference=rowid

    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Loan_EffectiveDate]
    ...    &{ExcelPath}[Loan_MaturityDate]    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_IntCycleFrequency]
    ...    &{ExcelPath}[Loan_Accrue]    &{ExcelPath}[Loan_RepricingDate]

    ### Cashflow Notebook - Create Cashflows ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_RemittanceDesc]    &{ExcelPath}[Borrower_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender_ShortName]    &{ExcelPath}[Lender_RemittanceDesc]    &{ExcelPath}[Lender_RemittanceInstruction]
    Set All Items to Do It

    ### Send to Approval ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}

    ### Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${APPROVAL_STATUS}

    ### Generate Intent Notice ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${GENERATE_INTENT_NOTICES}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction        ${GENERATE_INTENT_NOTICES}
    Select Notices Recipients
    Exit Notice Window

    ### Rate Setting ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction        ${RATE_SETTING_TRANSACTION}
    Set Base Rate Details    &{ExcelPath}[BorrowerBaseRate]    &{ExcelPath}[AcceptRate_FromPricing]

    ### Send to Rate Approval ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction        ${SEND_TO_RATE_APPROVAL_STATUS}
    
    ### Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction        ${RATE_APPROVAL_STATUS}

    ### Generate Rate Setting Notice ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_RATE_SETTING_NOTICES_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction        ${GENERATE_RATE_SETTING_NOTICES_TRANSACTION}
    Select Notices Recipients
    Exit Notice Window

    ### Release ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RELEASE_STATUS}

    ### Validate Loan Details ###
    Close All Windows on LIQ
    Open Existing Deal    ${Deal_Name}
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    ${FacilityName}    ${Loan_Alias}
    Validate Loan Drawdown Amounts in General Tab    &{ExcelPath}[Expctd_LoanGlobalOriginal]    &{ExcelPath}[Expctd_LoanGlobalCurrent]    &{ExcelPath}[Expctd_LoanHostBankGross]    &{ExcelPath}[Expctd_LoanHostBankNet]
    Validate Loan Drawdown General Details in General Tab    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_RepricingDate]    &{ExcelPath}[Loan_PaymentMode]    &{ExcelPath}[Expctd_Loan_IntCycleFrequency]
    Validate Loan Drawdown Rates in Rates Tab    &{ExcelPath}[Expctd_LoanCurrentBaseRate]    &{ExcelPath}[Expctd_LoanSpread]    &{ExcelPath}[Expctd_LoanAllInRate]

Create Loan Drawdown for LLA Syndicated Deal - Outstanding B
    [Documentation]    This high-level keyword is used to setup the loan drawdown for LLA Syndicated Deal
    ...    Outsanding B - Drawdown 3 and back date to 18/12/2019
    ...    @author: makcamps    21JAN2021    - Initial Create
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup_B    Facility_Name    1
    ${Borrower_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    1

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    ${Deal_Name}

    ### Create Drawdown ###
    Navigate to Outstanding Select Window from Deal
    ${Loan_Alias}    New Outstanding Select    ${Deal_Name}    ${FacilityName}    ${Borrower_Name}    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Outstanding_Currency]
    Write Data To Excel    SERV01_LoanDrawdown    Loan_Alias    &{ExcelPath}[rowid]    ${Loan_Alias}

    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_MaturityDate]    &{ExcelPath}[Loan_RepricingFrequency]    
    ...    &{ExcelPath}[Loan_IntCycleFrequency]    &{ExcelPath}[Loan_Accrue]    &{ExcelPath}[Loan_RepricingDate]

    ### Cashflow Notebook - Create Cashflows ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Set All Items to Do It

    ### Send to Approval ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}

    ### Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${APPROVAL_STATUS}

    ### Generate Intent Notice ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${GENERATE_INTENT_NOTICES}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction        ${GENERATE_INTENT_NOTICES}
    Select Notices Recipients
    Exit Notice Window

    ### Rate Setting ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction        ${RATE_SETTING_TRANSACTION}
    Set Base Rate Details    &{ExcelPath}[BorrowerBaseRate]    &{ExcelPath}[AcceptRate_FromPricing]

    ### Send to Rate Approval ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction        ${SEND_TO_RATE_APPROVAL_STATUS}
    
    ### Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction        ${RATE_APPROVAL_STATUS}

    ### Generate Rate Setting Notice ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_RATE_SETTING_NOTICES_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction        ${GENERATE_RATE_SETTING_NOTICES_TRANSACTION}
    Select Notices Recipients
    Exit Notice Window

    ### Release ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RELEASE_STATUS}

    ### Validate Loan Details ###
    Close All Windows on LIQ
    Open Existing Deal    ${Deal_Name}
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    ${FacilityName}    ${Loan_Alias}
    Validate Loan Drawdown Amounts in General Tab    &{ExcelPath}[Expctd_LoanGlobalOriginal]    &{ExcelPath}[Expctd_LoanGlobalCurrent]    &{ExcelPath}[Expctd_LoanHostBankGross]    &{ExcelPath}[Expctd_LoanHostBankNet]
    Validate Loan Drawdown General Details in General Tab    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_RepricingDate]    &{ExcelPath}[Loan_PaymentMode]    &{ExcelPath}[Expctd_Loan_IntCycleFrequency]
    Validate Loan Drawdown Rates in Rates Tab    &{ExcelPath}[Expctd_LoanCurrentBaseRate]    &{ExcelPath}[Expctd_LoanSpread]    &{ExcelPath}[Expctd_LoanAllInRate]
