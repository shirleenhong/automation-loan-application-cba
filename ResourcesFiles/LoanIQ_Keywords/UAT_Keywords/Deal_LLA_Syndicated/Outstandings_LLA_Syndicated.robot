*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Create Loan Drawdown for LLA Syndicated Deal - Outstanding A
    [Documentation]    This high-level keyword is used to setup the loan drawdown for LLA Syndicated Deal
    ...    @author: makcamps    21JAN2021    - Initial Create
    ...    @update: makcamps    08FEB2021    - added writing method for data set and validation for testing
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
    Write Data To Excel    SERV08_ComprehensiveRepricing    Loan_Alias    ${rowid}    ${Loan_Alias}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_Alias    3    ${Loan_Alias}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_Alias    4    ${Loan_Alias}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_Alias    5    ${Loan_Alias}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_Alias    6    ${Loan_Alias}    bTestCaseColumn=True    sColumnReference=rowid

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
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${GENERATE_INTENT_NOTICES}
    Select Notices Recipients
    Exit Notice Window

    ### Rate Setting ###
    Navigate to Loan Drawdown Workflow and Proceed with Rate Setting    ${RATE_SETTING_TRANSACTION}
    Set Base Rate Details    &{ExcelPath}[BorrowerBaseRate]    &{ExcelPath}[AcceptRate_FromPricing]

    ### Send to Rate Approval ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${SEND_TO_RATE_APPROVAL_STATUS}
    
    ### Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RATE_APPROVAL_STATUS}

    ### Generate Rate Setting Notice ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_RATE_SETTING_NOTICES_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${GENERATE_RATE_SETTING_NOTICES_TRANSACTION}
    Select Notices Recipients
    Exit Notice Window

    ### Release ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RELEASE_STATUS}

    ### Validate Loan Details ###
    Close All Windows on LIQ
    Open Existing Deal    ${Deal_Name}
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    ${FacilityName}    ${Loan_Alias}
    Validate Loan Drawdown Amounts in General Tab    &{ExcelPath}[Expctd_LoanGlobalOriginal]    &{ExcelPath}[Expctd_LoanGlobalCurrent]
    ...    &{ExcelPath}[Expctd_LoanHostBankGross]    &{ExcelPath}[Expctd_LoanHostBankNet]
    Validate Loan Drawdown General Details in General Tab    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_RepricingFrequency]
    ...    &{ExcelPath}[Loan_RepricingDate]    &{ExcelPath}[Loan_PaymentMode]    &{ExcelPath}[Expctd_Loan_IntCycleFrequency]
    Validate Loan Drawdown Rates in Rates Tab    &{ExcelPath}[Expctd_LoanCurrentBaseRate]    &{ExcelPath}[Expctd_LoanSpread]    &{ExcelPath}[Expctd_LoanAllInRate]

Create Loan Drawdown for LLA Syndicated Deal - Outstanding B
    [Documentation]    This high-level keyword is used to setup the loan drawdown for LLA Syndicated Deal
    ...    Outsanding B - Drawdown and back date to 11/08/2019
    ...    @author: makcamps    26JAN2021    - Initial Create
    ...    @update: makcamps    08FEB2021    - fixed arguments for creating drawdown
    ...    @update: makcamps    17FEB2021    - fixed loan alias value for argument
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name    1
    ${Borrower_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    1

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    ${Deal_Name}

    ### Create Drawdown ###
    Navigate to Outstanding Select Window from Deal
    ${Loan_Alias}    New Outstanding Select    ${Deal_Name}    ${FacilityName}    ${Borrower_Name}    &{ExcelPath}[Outstanding_Type]
    ...    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Outstanding_Currency]
    Write Data To Excel    SERV01_LoanDrawdown    Loan_Alias    ${rowid}    ${Loan_Alias}    bTestCaseColumn=True    sColumnReference=rowid

    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_MaturityDate]    &{ExcelPath}[Loan_RepricingFrequency]    
    ...    &{ExcelPath}[Loan_IntCycleFrequency]    &{ExcelPath}[Loan_Accrue]    &{ExcelPath}[Loan_RepricingDate]

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
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${GENERATE_INTENT_NOTICES}
    Select Notices Recipients
    Exit Notice Window

    ### Rate Setting ###
    Navigate to Loan Drawdown Workflow and Proceed with Rate Setting    ${RATE_SETTING_TRANSACTION}
    Set Base Rate Details    &{ExcelPath}[BorrowerBaseRate]    &{ExcelPath}[AcceptRate_FromPricing]

    ### Send to Rate Approval ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${SEND_TO_RATE_APPROVAL_STATUS}
    
    ### Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RATE_APPROVAL_STATUS}

    ### Generate Rate Setting Notice ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_RATE_SETTING_NOTICES_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${GENERATE_RATE_SETTING_NOTICES_TRANSACTION}
    Select Notices Recipients
    Exit Notice Window

    ### Release ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RELEASE_STATUS}

    ### Validate Loan Details ###
    Close All Windows on LIQ
    Open Existing Deal    ${Deal_Name}
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    ${FacilityName}    ${Loan_Alias}
    Validate Loan Drawdown Amounts in General Tab    &{ExcelPath}[Expctd_LoanGlobalOriginal]    &{ExcelPath}[Expctd_LoanGlobalCurrent]
    ...    &{ExcelPath}[Expctd_LoanHostBankGross]    &{ExcelPath}[Expctd_LoanHostBankNet]
    Validate Loan Drawdown General Details in General Tab    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_EffectiveDate]
    ...    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_RepricingDate]    &{ExcelPath}[Loan_PaymentMode]    &{ExcelPath}[Expctd_Loan_IntCycleFrequency]
    Validate Loan Drawdown Rates in Rates Tab    &{ExcelPath}[Expctd_LoanCurrentBaseRate]    &{ExcelPath}[Expctd_LoanSpread]    &{ExcelPath}[Expctd_LoanAllInRate]

Create Loan Drawdown for LLA Syndicated Deal - Outstanding C
    [Documentation]    This high-level keyword is used to setup the loan drawdown for LLA Syndicated Deal
    ...    Outsanding C - Drawdown and back date to 06/12/2019
    ...    @author: makcamps    27JAN2021    - Initial Create
    ...    @update: makcamps    08FEB2021    - updated arguments for drawdown creation and added validation
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name    1
    ${Borrower_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    1

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    ${Deal_Name}

    ### Create Drawdown ###
    Navigate to Outstanding Select Window from Deal
    ${Loan_Alias}    New Outstanding Select    ${Deal_Name}    ${FacilityName}    ${Borrower_Name}    &{ExcelPath}[Outstanding_Type]
    ...    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Outstanding_Currency]
    Write Data To Excel    SERV01_LoanDrawdown    Loan_Alias    ${rowid}    ${Loan_Alias}    bTestCaseColumn=True    sColumnReference=rowid

    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_MaturityDate]    &{ExcelPath}[Loan_RepricingFrequency]    
    ...    &{ExcelPath}[Loan_IntCycleFrequency]    &{ExcelPath}[Loan_Accrue]    &{ExcelPath}[Loan_RepricingDate]

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
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${GENERATE_INTENT_NOTICES}
    Select Notices Recipients
    Exit Notice Window

    ### Rate Setting ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RATE_SETTING_TRANSACTION}
    Set Base Rate Details    &{ExcelPath}[BorrowerBaseRate]    &{ExcelPath}[AcceptRate_FromPricing]

    ### Send to Rate Approval ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${SEND_TO_RATE_APPROVAL_STATUS}
    
    ### Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RATE_APPROVAL_STATUS}

    ### Generate Rate Setting Notice ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_RATE_SETTING_NOTICES_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${GENERATE_RATE_SETTING_NOTICES_TRANSACTION}
    Select Notices Recipients
    Exit Notice Window

    ### Release ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RELEASE_STATUS}

    ### Validate Loan Details ###
    Close All Windows on LIQ
    Open Existing Deal    ${Deal_Name}
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    ${FacilityName}    ${Loan_Alias}
    Validate Loan Drawdown Amounts in General Tab    &{ExcelPath}[Expctd_LoanGlobalOriginal]    &{ExcelPath}[Expctd_LoanGlobalCurrent]
    ...    &{ExcelPath}[Expctd_LoanHostBankGross]    &{ExcelPath}[Expctd_LoanHostBankNet]
    Validate Loan Drawdown General Details in General Tab    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_EffectiveDate]
    ...    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_RepricingDate]    &{ExcelPath}[Loan_PaymentMode]    &{ExcelPath}[Expctd_Loan_IntCycleFrequency]
    Validate Loan Drawdown Rates in Rates Tab    &{ExcelPath}[Expctd_LoanCurrentBaseRate]    &{ExcelPath}[Expctd_LoanSpread]    &{ExcelPath}[Expctd_LoanAllInRate]

Create Comprehensive Repricing for LLA Syndicated Deal
    [Documentation]    This is a high-level keyword to Create Comprehensive Repricing for LLA Syndicated Deal
    ...    @author: makcamps    03FEB2021    - initial create
    [Arguments]    ${ExcelPath}

    ### Navigate to Existing Outstandings Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]

    ### Select Loan to Reprice ###
    Select Loan to Reprice    &{ExcelPath}[Loan_Alias]
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Loan Repricing for Deal    &{ExcelPath}[Loan_Alias]

    ### Repricing Notebook - Setup Repricing ###
    ${NewLoanAlias}    Setup Repricing    &{ExcelPath}[Repricing_Add_Option_Setup]    &{ExcelPath}[Base_Rate]    &{ExcelPath}[Pricing_Option]
    ...    &{ExcelPath}[Rollover_Amount]    &{ExcelPath}[Repricing_Frequency]    &{ExcelPath}[AcceptRatePricing]    &{ExcelPath}[LoanRepricingSetup]
    Write Data To Excel    SERV08_ComprehensiveRepricing    New_Loan_Alias    ${rowid}    ${NewLoanAlias}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_Alias    7    ${NewLoanAlias}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_Alias    8    ${NewLoanAlias}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_Alias    9    ${NewLoanAlias}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_Alias    10    ${NewLoanAlias}    bTestCaseColumn=True    sColumnReference=rowid
    Add Interest Payment for Loan Repricing

    ### Cashflows - Create Cashflows ###
    Navigate to Create Cashflow for Loan Repricing
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance1_Description]    &{ExcelPath}[Remittance1_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender2_ShortName]
    Set All Items to Do It

    ### Send Loan Approval ###
    Close All Windows on LIQ
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${GENERATE_INTENT_NOTICES}    ${LOAN_REPRICING}     &{ExcelPath}[Deal_Name]
    Set Notebook to Update Mode    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Inquiry_Button}
    Send Loan Repricing for Approval

    ### Approve Loan Repricing ###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_INTENT_NOTICES_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Deal_Name]
    Approve Loan Repricing

    ### Generate Intent Notice ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${GENERATE_INTENT_NOTICES}
    Generate Intent Notices    &{ExcelPath}[Borrower_ShortName]
    Close Generate Notice Window

    ### Rate Setting ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RATE_SETTING_TRANSACTION}
    Set Base Rate Details    &{ExcelPath}[Base_Rate]    &{ExcelPath}[AcceptRate_FromPricing]
    Send to Rate Approval

    ## Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_REPRICING}     &{ExcelPath}[Deal_Name]
    Approve Rate Setting Notice
    
    ### Generate Rate Setting Notice and Release Loan ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_RATE_SETTING_NOTICES_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Deal_Name]
    Generate Rate Setting Notices    &{ExcelPath}[Borrower_ShortName]    ${AWAITING_RELEASE_NOTICE_STATUS}
    
    ### Release Repricing ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RELEASE_STATUS}

    ### Loan Notebook ###
    Validate Release of Loan Repricing    ${RELEASED_STATUS}
    Close All Windows on LIQ

    ### Validate New Loan Amount ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Open Existing Loan    ${NewLoan_Alias}
    Validate Updated Global and Host Bank Amount after Repricing    &{ExcelPath}[New_LoanAmount]    &{ExcelPath}[New_HostBankAmount]
    Navigate to Initial Drawdown Notebook from Loan Notebook
    Validate Release of Loan Repricing    &{ExcelPath}[Event_Name]

    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

Create Loan Merge for Outstanding B1 and C for LLA Syndicated Deal
    [Documentation]    This is a high-level keyword to combine outstanding B1 and C for LLA Syndicated Deal.
    ...    @author: makcamps    23FEB2021    - Initial Create
    [Arguments]    ${ExcelPath}
    
    ### Retrieve Base Rate Payload Values ###
    ${Outstanding_B_Alias}    Read Data From Excel    SERV01_LoanDrawdown    Loan_Alias    2
    ${Outstanding_C_Alias}    Read Data From Excel    SERV01_LoanDrawdown    Loan_Alias    3
    ${Outstanding_C_LoanAmt}    Read Data From Excel    SERV01_LoanDrawdown    Loan_RequestedAmount    3
    ${Borrower_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    1
    ${BaseRate_OptionName}    Read Data From Excel    CRED01_DealSetup    Deal_PricingOption    1
    ${BaseRate_Frequency}    Read Data From Excel    SERV01_LoanDrawdown    Loan_RepricingFrequency    2

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Search for Existing Deal and Facility ###
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]

    ### Search for Existing Outstanding ###
    Navigate to Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
        
    ### Select Two Loans to Merge ###
    Select Loan to Reprice    ${Outstanding_B_Alias}
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Multiple Loan to Merge    ${Outstanding_B_Alias}    ${Outstanding_C_Alias}

    ### Add Repricing Detail ###
    ${Total_LoanMergeAmount}    Add Loan Repricing Option    &{ExcelPath}[Repricing_Add_Option_Setup]    ${BaseRate_OptionName}    &{ExcelPath}[Facility_Name]
    ...    ${Borrower_Name}    ${Outstanding_B_Alias}    ${Outstanding_C_Alias}    &{ExcelPath}[LoanC_Amount]    ${Outstanding_C_LoanAmt}    ${BaseRate_OptionName}
    ${Alias_LoanMerge}    Validate Rollover/Conversion General Tab    ${BaseRate_Frequency}    &{ExcelPath}[Rollover_Amount]    &{ExcelPath}[OutstandingSelect_Type]
    ...    &{ExcelPath}[RepricingDate]
    
    Write Data To Excel    SERV08_ComprehensiveRepricing    New_LoanAmount    ${rowid}    &{ExcelPath}[Rollover_Amount]
    Write Data To Excel    SERV08_ComprehensiveRepricing    New_Loan_Alias    ${rowid}    ${Alias_LoanMerge}
    Validate New Outstanding Amount for Loan Repricing    ${BaseRate_OptionName}    ${Alias_LoanMerge}    &{ExcelPath}[Rollover_Amount]
    Validate and Add Interest Payment for Loan Repricing    ${Outstanding_C_Alias}    &{ExcelPath}[Outstanding_C_IntAmt]
    Validate and Add Interest Payment for Loan Repricing    ${Outstanding_B_Alias}    &{ExcelPath}[Outstanding_B_IntAmt]
    
    ### Create Cashflow ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance1_Description]    &{ExcelPath}[Remittance1_Instruction]
    Set All Items to Do It

    ### Send to Approval ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    Close All Windows on LIQ
    
    ### Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Deal_Name]
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${APPROVAL_STATUS}

    ### Generate Intent Notice ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_INTENT_NOTICES_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Deal_Name]
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${GENERATE_INTENT_NOTICES}
    Select Notices Recipients
    Exit Notice Window

    ### Rate Setting ###    
    Navigate to Loan Repricing Workflow and Proceed With Rate Setting    ${RATE_SETTING_TRANSACTION}
    Set Base Rate Details    &{ExcelPath}[Base_Rate]    &{ExcelPath}[AcceptRate_FromPricing]

    ### Send to Rate Approval ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${SEND_TO_RATE_APPROVAL_STATUS}
    
    ### Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Deal_Name]
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RATE_APPROVAL_STATUS}

    ### Generate Rate Setting Notice ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_RATE_SETTING_NOTICES_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Deal_Name]
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${GENERATE_RATE_SETTING_NOTICES_TRANSACTION}
    Select Notices Recipients
    Exit Notice Window

    ### Release Loan Repricing ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    Validate Window Title Status    ${LOAN_REPRICING}    ${RELEASED_STATUS}

    ### Validation ###
    Close All Windows on LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[New_Loan_Alias]
    Validate Event Status in Loan Events Tab    ${RELEASED_STATUS}
    Close All Windows on LIQ