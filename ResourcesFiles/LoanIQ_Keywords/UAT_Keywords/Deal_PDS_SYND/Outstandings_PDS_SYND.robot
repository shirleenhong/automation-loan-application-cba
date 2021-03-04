*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Create Loan Drawdown for PDS Syndicate Deal - Outstanding A
    [Documentation]    This high-level keyword is used to setup the loan drawdown for PDS Syndicated Deal Outsanding A - 09/18/19
    ...    @author: shirhong    10FEB2021    - Initial Create
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

    ### Rate Setting ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_SETTING}    ${LOAN_INITIAL_DRAWDOWN_TYPE}     ${Loan_Alias}
    Set Notebook to Update Mode    ${LIQ_InitialDrawdown_Window}    ${LIQ_LoanInquiry_InitialDrawdown_Button}
    Navigate to Loan Drawdown Workflow and Proceed with Rate Setting    ${RATE_SETTING_TRANSACTION}
    Set Base Rate Details    &{ExcelPath}[Borrower_BaseRate]    &{ExcelPath}[AcceptRate_FromPricing]
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${SEND_TO_RATE_APPROVAL_STATUS}

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

Create Loan Drawdown for PDS Syndicate Deal - Outstanding B
    [Documentation]    This high-level keyword is used to setup the loan drawdown for PDS Syndicated Deal Outsanding B - 09/18/19
    ...    @author: shirhong    22FEB2021    - Initial Create
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup_B    Facility_Name    1
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

    ### Rate Setting ###
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

Rollover Outstanding A1 for PDS Syndicate Deal
    [Documentation]    This is a high-level keyword to rollover outstanding A1 for PDS Syndicate Deal.
    ...    @author: shirhong    23FEB2021    - Initial Create
    ...    @update: shirhong    03MAR2021    - Updated the correct step for Rate Setting. Remove unnecessary retrieve data from dataset.
    [Arguments]    ${ExcelPath}
    
    ### Retrieve Data from Excel Data Sheet ###
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup_A    Facility_Name    1
    ${Outstanding_A_Alias}    Read Data From Excel    SERV01_LoanDrawdown    Loan_Alias    1
    ${Borrower_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    1
    ${Customer_Name}    Read Data From Excel    CRED01_DealSetup    Deal_AdminAgent    1

    ### Login using Inputter ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Search for Existing Deal and Facility ###
    Launch Existing Facility    ${Deal_Name}    ${FacilityName}

    ### Search for Existing Outstanding ###
    Navigate to Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    ${FacilityName}
        
    ### Select Loan to Rollover ###
    Select Loan to Reprice    ${Outstanding_A_Alias}
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Loan Repricing for Deal    ${Outstanding_A_Alias}
    
    ### Repricing Notebook - Setup Repricing ###  
    Cick Add in Loan Repricing Notebook
    Set Repricing Detail Add Options     &{ExcelPath}[Repricing_Add_Option_Setup]    &{ExcelPath}[Pricing_Option]    ${FacilityName}    ${Borrower_Name}
    ${Effective_Date}    ${NewLoan_Alias}    Set RolloverConversion Notebook General Details    &{ExcelPath}[New_LoanAmount]    &{ExcelPath}[Repricing_Frequency]    &{ExcelPath}[Repricing_Date]
    Save Notebook Transaction    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_Save_Menu}
    Close RolloverConversion Notebook

    Write Data To Excel    SERV08_ComprehensiveRepricing    NewLoan_Alias    ${rowid}    ${NewLoan_Alias}

    ### Adding of Interest Payment ###
    Add Interest Payment for Loan Repricing

    ###Add Principal Payment###
    Add Principal Payment after New Outstanding Addition    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[New_LoanAmount]

    ### Create Cashflow ###
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Create Cashflows

    ### Remittance Instruction per Cashflow ###
    Verify if Method has Remittance Instruction    ${Customer_Name}    &{ExcelPath}[RI_Description]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[TranAmount_1]    &{ExcelPath}[Currency]
    Verify if Method has Remittance Instruction As None    ${Customer_Name}    &{ExcelPath}[RI_Description]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[TranAmount_2]    &{ExcelPath}[Currency]

    Set All Items to Do It

    ### Send to Approval ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    Close All Windows on LIQ
    
     ### Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_REPRICING}    ${Deal_Name}
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${APPROVAL_STATUS}

    ### Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_REPRICING}    ${Deal_Name}
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${APPROVAL_STATUS}

    ### Login as Inputter and Rate Setting ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Rate Setting in Loan Repricing Notebook ###
    Open Existing Deal    ${Deal_Name}
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    &{ExcelPath}[OutstandingSelect_Type]   ${FacilityName}    ${Outstanding_B_Alias}
    Navigate to Loan Pending Tab and Proceed with the Pending Transaction    Awaiting Send to Rate Approval
    Set Notebook to Update Mode    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Inquiry_Button}
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RATE_SETTING_TRANSACTION}
    
    Set Base Rate Details    &{ExcelPath}[Base_Rate]    &{ExcelPath}[AcceptRate_FromPricing]
	
    ### Send to Rate Approval ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${SEND_TO_RATE_APPROVAL_STATUS}

    ### Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_REPRICING}    ${Deal_Name}
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RATE_APPROVAL_STATUS}

    ### Release Loan Repricing ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${LOAN_REPRICING}    ${Deal_Name}
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    Validate Window Title Status    ${LOAN_REPRICING}    ${RELEASED_STATUS}

    ### Validate New Loan Amount ###
    Search for Deal    ${Deal_Name}
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    ${FacilityName}
    Open Existing Loan    ${NewLoan_Alias}
    Validate Updated Global and Host Bank Amount after Repricing    &{ExcelPath}[New_LoanAmount]    &{ExcelPath}[HostBank_Amount]
    Close All Windows on LIQ

    ### Validate Amount in Amortization Schedule ###
    Navigate to Facility Notebook    ${Deal_Name}    ${FacilityName}
    Navigate to Increase Decrease Schedule from Facility Notebook Window
    Validate the Amount from Comment in Amortization Schedule for Facility    &{ExcelPath}[AmortizationSched_EffectiveDate]    &{ExcelPath}[PrincipalPayment_FromRepricing]
    Close All Windows on LIQ

Rollover Outstanding B1 for PDS Syndicate Deal
    [Documentation]    This is a high-level keyword to rollover outstanding B1 for PDS Syndicate Deal.
    ...    @author: shirhong    03MAR2021    - Initial Create
    [Arguments]    ${ExcelPath}
    
    ### Retrieve Data from Excel Data Sheet ###
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup_B    Facility_Name    1
    ${Outstanding_B_Alias}    Read Data From Excel    SERV01_LoanDrawdown    Loan_Alias    2
    ${Borrower_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    1
    ${Customer_Name}    Read Data From Excel    CRED01_DealSetup    Deal_AdminAgent    1

    ### Login using Inputter ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Search for Existing Deal and Facility ###
    Launch Existing Facility    ${Deal_Name}    ${FacilityName}

    ### Search for Existing Outstanding ###
    Navigate to Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    ${FacilityName}
        
    ### Select Loan to Rollover ###
    Select Loan to Reprice    ${Outstanding_B_Alias}
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Loan Repricing for Deal    ${Outstanding_B_Alias}
    
    ### Repricing Notebook - Setup Repricing ###  
    Cick Add in Loan Repricing Notebook
    Set Repricing Detail Add Options     &{ExcelPath}[Repricing_Add_Option_Setup]    &{ExcelPath}[Pricing_Option]    ${FacilityName}    ${Borrower_Name}
    ${Effective_Date}    ${NewLoan_Alias}    Set RolloverConversion Notebook General Details    &{ExcelPath}[New_LoanAmount]    &{ExcelPath}[Repricing_Frequency]    &{ExcelPath}[Repricing_Date]
    Save Notebook Transaction    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_Save_Menu}
    Close RolloverConversion Notebook

    Write Data To Excel    SERV08_ComprehensiveRepricing    NewLoan_Alias    ${rowid}    ${NewLoan_Alias}

    ### Adding of Interest Payment ###
    Add Interest Payment for Loan Repricing

    ###Add Principal Payment###
    Add Principal Payment after New Outstanding Addition    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[New_LoanAmount]

    ### Create Cashflow ###
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Create Cashflows

    ### Remittance Instruction per Cashflow ###
    Verify if Method has Remittance Instruction    ${Customer_Name}    &{ExcelPath}[RI_Description]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[TranAmount_1]    &{ExcelPath}[Currency]
    Verify if Method has Remittance Instruction As None    ${Customer_Name}    &{ExcelPath}[RI_Description]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[TranAmount_2]    &{ExcelPath}[Currency]

    Set All Items to Do It

    ### Send to Approval ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    Close All Windows on LIQ

    ### Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_REPRICING}    ${Deal_Name}
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${APPROVAL_STATUS}

    ### Login as Inputter and Rate Setting ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Rate Setting in Loan Repricing Notebook ###
    Open Existing Deal    ${Deal_Name}
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    &{ExcelPath}[OutstandingSelect_Type]   ${FacilityName}    ${Outstanding_B_Alias}
    Navigate to Loan Pending Tab and Proceed with the Pending Transaction    Awaiting Send to Rate Approval
    Set Notebook to Update Mode    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Inquiry_Button}
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RATE_SETTING_TRANSACTION}
    
    Set Base Rate Details    &{ExcelPath}[Base_Rate]    &{ExcelPath}[AcceptRate_FromPricing]
	
    ### Send to Rate Approval ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${SEND_TO_RATE_APPROVAL_STATUS}
    
    ### Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_REPRICING}    ${Deal_Name}
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RATE_APPROVAL_STATUS}

    ### Release Loan Repricing ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${LOAN_REPRICING}    ${Deal_Name}
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    Validate Window Title Status    ${LOAN_REPRICING}    ${RELEASED_STATUS}

    ### Validate New Loan Amount ###
    Search for Deal    ${Deal_Name}
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    ${FacilityName}
    Open Existing Loan    ${NewLoan_Alias}
    Validate Updated Global and Host Bank Amount after Repricing    &{ExcelPath}[New_LoanAmount]    &{ExcelPath}[HostBank_Amount]	
    Close All Windows on LIQ

    ### Validate Amount in Amortization Schedule ###
    Navigate to Facility Notebook    ${Deal_Name}    ${FacilityName}
    Navigate to Increase Decrease Schedule from Facility Notebook Window
    Validate the Amount from Comment in Amortization Schedule for Facility    &{ExcelPath}[AmortizationSched_EffectiveDate]    &{ExcelPath}[PrincipalPayment_FromRepricing]
    Close All Windows on LIQ
    