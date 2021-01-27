*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Create Loan Drawdown for CH EDU Bilateral Deal - Outstanding Y
    [Documentation]    This high-level keyword is used to setup the loan drawdown for CH EDU Bilateral Deal
    ...    @author: dahijara    15DEC2020    - Initial Create
    ...    @update: javinzon    18DEC2020    - updated keyword names for validation of loan drawdown's Amount, General details and Rates
    ...    @update: dahijara    13JAN2020    - Updated keyword name from 'Select Notices Recepients' to 'Select Notices Recipients'
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup_A    Facility_Name    &{ExcelPath}[rowid]
    ${Borrower_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    &{ExcelPath}[rowid]

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
    Set All Items to SPAP

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
    Add Group Comment for Notices    &{Excelpath}[Notice_Subject]    &{Excelpath}[Notice_Comment]
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


Create Loan Drawdown for CH EDU Bilateral Deal - Outstanding A
    [Documentation]    This high-level keyword is used to setup the loan drawdown for CH EDU Bilateral Deal
    ...    @author: dahijara    05JAN2021    - Initial Create
    ...    @update: dahijara    13JAN2020    - Updated keyword name from 'Select Notices Recepients' to 'Select Notices Recipients'
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

Create Loan Drawdown for CH EDU Bilateral Deal - Outstanding B
    [Documentation]    This high-level keyword is used to setup the loan drawdown for CH EDU Bilateral Deal
    ...    Outsanding B - Drawdown 3 and back date to 18/12/2019
    ...    @author: dahijara    06JAN2021    - Initial Create
    ...    @update: dahijara    13JAN2020    - Updated keyword name from 'Select Notices Recepients' to 'Select Notices Recipients'
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

Create Loan Merge for Outstanding A and B for CH EDU Bilateral Deal
    [Documentation]    This is a high-level keyword to combine outstanding A and b for CH EDU Bilateral Deal.
    ...    @author: dahijara    15JAN2021    - Initial Create
    [Arguments]    ${ExcelPath}
    
    ### Retrieve Base Rate Payload Values ###
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup_B    Facility_Name    1
    ${Outstanding_A_Alias}    Read Data From Excel    SERV01_LoanDrawdown    Loan_Alias    3
    ${Outstanding_B_Alias}    Read Data From Excel    SERV01_LoanDrawdown    Loan_Alias    4
    ${Outstanding_A_LoanAmt}    Read Data From Excel    SERV01_LoanDrawdown    Loan_RequestedAmount    3
    ${Outstanding_B_LoanAmt}    Read Data From Excel    SERV01_LoanDrawdown    Loan_RequestedAmount    4
    ${Borrower_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    1
    ${BaseRate_OptionName}    Read Data From Excel    CRED01_DealSetup    Deal_PricingOption    1
    ${BaseRate_Frequency}    Read Data From Excel    SERV01_LoanDrawdown    Loan_RepricingFrequency    3

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Search for Existing Deal and Facility ###
    Launch Existing Facility    ${Deal_Name}    ${FacilityName}

    ### Search for Existing Outstanding ###
    Navigate to Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    ${FacilityName}
        
    ### Select Two Loans to Merge ###
    Select Loan to Reprice    ${Outstanding_A_Alias}
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Multiple Loan to Merge    ${Outstanding_A_Alias}    ${Outstanding_B_Alias}
    
    Change Effective Date for Loan Repricing    &{ExcelPath}[Effective_Date]

    ### Add Repricing Detail ###
    ${Total_LoanMergeAmount}    Add Loan Repricing Option    &{ExcelPath}[Repricing_Add_Option]    ${BaseRate_OptionName}    ${FacilityName}    ${Borrower_Name}    ${Outstanding_A_Alias}
    ...    ${Outstanding_B_Alias}    ${Outstanding_A_LoanAmt}    ${Outstanding_B_LoanAmt}    ${BaseRate_OptionName}
    ${Alias_LoanMerge}    Validate Rollover/Conversion General Tab    ${BaseRate_Frequency}    ${Total_LoanMergeAmount}    &{ExcelPath}[OutstandingSelect_Type]
    
    Write Data To Excel    SERV11_LoanMerge    LoanMerge_Amount    &{ExcelPath}[rowid]    ${Total_LoanMergeAmount}
    Write Data To Excel    SERV11_LoanMerge    Alias_LoanMerge    &{ExcelPath}[rowid]    ${Alias_LoanMerge}
    
    Validate New Outstanding Amount for Loan Repricing    ${BaseRate_OptionName}    ${Alias_LoanMerge}    ${Total_LoanMergeAmount}
    Validate and Add Interest Payment for Loan Repricing    ${Outstanding_B_Alias}    &{ExcelPath}[Outstanding_B_IntAmt]
    Validate and Add Interest Payment for Loan Repricing    ${Outstanding_A_Alias}    &{ExcelPath}[Outstanding_A_IntAmt]
    
    ### Create Cashflow ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Set All Items to Do It

    ### Send to Approval ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    Close All Windows on LIQ
    
    ### Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_REPRICING}    ${Deal_Name}
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${APPROVAL_STATUS}

    ### Generate Intent Notice ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_INTENT_NOTICES_STATUS}    ${LOAN_REPRICING}    ${Deal_Name}
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${GENERATE_INTENT_NOTICES}
    Select Notices Recipients
    Exit Notice Window

    ### Rate Setting ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RATE_SETTING_TRANSACTION}
    Set Base Rate Details    &{ExcelPath}[BorrowerBaseRate]    &{ExcelPath}[AcceptRate_FromPricing]

    ### Send to Rate Approval ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${SEND_TO_RATE_APPROVAL_STATUS}
    
    ### Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_REPRICING}    ${Deal_Name}
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RATE_APPROVAL_STATUS}

    ### Generate Rate Setting Notice ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_RATE_SETTING_NOTICES_STATUS}    ${LOAN_REPRICING}    ${Deal_Name}
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${GENERATE_RATE_SETTING_NOTICES_TRANSACTION}
    Select Notices Recipients
    Exit Notice Window

    ### Release Loan Repricing ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    Validate Window Title Status    ${LOAN_REPRICING}    ${RELEASED_STATUS}

    ### Validation ###
    Close All Windows on LIQ
    Open Existing Deal    ${Deal_Name}
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    ${FacilityName}    ${Alias_LoanMerge}
    Validate Event Status in Loan Events Tab    ${RELEASED_STATUS}
    Close All Windows on LIQ

Create Loan Drawdown for CH EDU Bilateral Deal - Outstanding C
    [Documentation]    This high-level keyword is used to setup the loan drawdown for CH EDU Bilateral Deal
    ...    Outsanding C - Create Drawdown (15/01/2020)
    ...    @author: dahijara    22JAN2021    - Initial Create
    [Arguments]    ${ExcelPath}

    ### Get Data from Excel ###
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup_B    Facility_Name    1
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${Borrower_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    1

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

    ### Release Loan Drawdown ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RELEASE_STATUS}

    ### Validate Loan Drawdown Details ###
    Close All Windows on LIQ
    Open Existing Deal    ${Deal_Name}
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    ${FacilityName}    ${Loan_Alias}
    Validate Loan Drawdown Amounts in General Tab    &{ExcelPath}[Expctd_LoanGlobalOriginal]    &{ExcelPath}[Expctd_LoanGlobalCurrent]    &{ExcelPath}[Expctd_LoanHostBankGross]    &{ExcelPath}[Expctd_LoanHostBankNet]
    Validate Loan Drawdown General Details in General Tab    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_RepricingDate]    &{ExcelPath}[Loan_PaymentMode]    &{ExcelPath}[Expctd_Loan_IntCycleFrequency]
    Validate Loan Drawdown Rates in Rates Tab    &{ExcelPath}[Expctd_LoanCurrentBaseRate]    &{ExcelPath}[Expctd_LoanSpread]    &{ExcelPath}[Expctd_LoanAllInRate]

Create Loan Drawdown for CH EDU Bilateral Deal - Outstanding D
    [Documentation]    This high-level keyword is used to setup the loan drawdown for CH EDU Bilateral Deal
    ...    Outsanding C - Create Drawdown (04/12/2019)
    ...    @author: dahijara    25JAN2021    - Initial Create
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup_B    Facility_Name    1
    ${Borrower_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    1

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
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Set All Items to Do It

    ### Send to Approval ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}

    ### Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${APPROVAL_STATUS}

    ### Generate Intent Notice After Aprroval###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${GENERATE_INTENT_NOTICES}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction        ${GENERATE_INTENT_NOTICES}
    Select Notices Recipients
    Exit Notice Window

    ### Set Rate - Accept Rate from Pricing ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction        ${RATE_SETTING_TRANSACTION}
    Set Base Rate Details    &{ExcelPath}[BorrowerBaseRate]    &{ExcelPath}[AcceptRate_FromPricing]

    ### Send to Rate Approval ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction        ${SEND_TO_RATE_APPROVAL_STATUS}
    
    ### Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction        ${RATE_APPROVAL_STATUS}

    ### Generate Rate Setting Notice After Approval###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_RATE_SETTING_NOTICES_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction        ${GENERATE_RATE_SETTING_NOTICES_TRANSACTION}
    Select Notices Recipients
    Exit Notice Window

    ### Release Loan Drawdown ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RELEASE_STATUS}

    ### Validate Loan Drawdown Details ###
    Close All Windows on LIQ
    Open Existing Deal    ${Deal_Name}
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    ${FacilityName}    ${Loan_Alias}
    Validate Loan Drawdown Amounts in General Tab    &{ExcelPath}[Expctd_LoanGlobalOriginal]    &{ExcelPath}[Expctd_LoanGlobalCurrent]    &{ExcelPath}[Expctd_LoanHostBankGross]    &{ExcelPath}[Expctd_LoanHostBankNet]
    Validate Loan Drawdown General Details in General Tab    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_RepricingDate]    &{ExcelPath}[Loan_PaymentMode]    &{ExcelPath}[Expctd_Loan_IntCycleFrequency]
    Validate Loan Drawdown Rates in Rates Tab    &{ExcelPath}[Expctd_LoanCurrentBaseRate]    &{ExcelPath}[Expctd_LoanSpread]    &{ExcelPath}[Expctd_LoanAllInRate]