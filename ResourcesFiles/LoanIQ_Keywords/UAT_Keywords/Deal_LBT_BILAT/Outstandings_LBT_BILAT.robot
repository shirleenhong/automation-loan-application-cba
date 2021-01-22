*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Loan Drawdown for LBT Bilateral Deal
    [Documentation]    This high-level keyword is used to setup the outstanding for LBT Bilateral facility
    ...    @author: javinzon    16DEC2020    - Initial create
    ...    @update: javinzon    18DEC2020    - Renamed keyword from 'Create Loan Drawdown for LBT Bilateral Deal - Outstanding Z'
    ...                                        to 'Create Loan Drawdown for LBT Bilateral Deal', Removed keywords Read Data from Excel
    ...    @update: javinzon    13JAN2021    - Added keyword Write Data to Excel for Loan_Alias of Correspondence
    ...    @update: javinzon    14JAN2021    - Removed keywords Write Data To Excel
    [Arguments]    ${ExcelPath}
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ### Create Drawdown ###
    Navigate to Outstanding Select Window from Deal
    ${Loan_Alias}    New Outstanding Select    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Outstanding_Currency]
    Write Data To Excel    SERV01_LoanDrawdown    Loan_Alias    ${rowid}    ${Loan_Alias}
   
    Input General Loan Drawdown Details with Accrual End Date    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Loan_MaturityDate]    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_EffectiveDate]            
    ...    &{ExcelPath}[Loan_RepricingDate]    &{ExcelPath}[Loan_RiskType]    &{ExcelPath}[Loan_FiskandLoanRiskType]    &{ExcelPath}[Payment_Mode]    &{ExcelPath}[Loan_Accrue]    &{ExcelPath}[Loan_AccrualEndDate]        

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
    Mx LoanIQ Close Window    ${LIQ_NoticeGroup_Window}

    ### Rate Setting ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RATE_SETTING_TRANSACTION}
    Set Base Rate Details    &{ExcelPath}[AcceptRate_BorrowerBaseRate]    &{ExcelPath}[AcceptRate_FromPricing]
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
     
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    ${Loan_Alias}
    Validate Loan Drawdown Amounts in General Tab    &{ExcelPath}[Expctd_LoanGlobalOriginal]    &{ExcelPath}[Expctd_LoanGlobalCurrent]    &{ExcelPath}[Expctd_LoanHostBankGross]    &{ExcelPath}[Expctd_LoanHostBankNet]
    Validate Loan Drawdown General Details in General Tab    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_RepricingDate]    &{ExcelPath}[Payment_Mode]    &{ExcelPath}[Expctd_Loan_IntCycleFrequency]
    Validate Loan Drawdown Rates in Rates Tab    &{ExcelPath}[Expctd_LoanCurrentBaseRate]    &{ExcelPath}[Expctd_LoanSpread]    &{ExcelPath}[Expctd_LoanAllInRate]

Combine Drawdown A and B and Make Partial Repayment for LBT Bilateral Deal
     [Documentation]    This is a high-level keyword to Combine drawdowns and pay for partial payment then Rollover
    ...    @author: javinzon    19JAN2021    - Initial Create 
    [Arguments]    ${ExcelPath}

	${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    ${rowid}
    ${Borrower_Name}    Read Data From Excel    SERV01_LoanDrawdown    Borrower_Name    ${rowid}
    ${Facility_Name}    Read Data From Excel    SERV01_LoanDrawdown    Facility_Name    ${rowid}
    ${Loan_Alias_A}    Read Data From Excel    SERV01_LoanDrawdown    Loan_Alias    2
    ${Loan_Alias_B}    Read Data From Excel    SERV01_LoanDrawdown    Loan_Alias    3
    ${Loan_AliasA_Amount}    Read Data From Excel    SERV01_LoanDrawdown    Loan_RequestedAmount    2
    ${Loan_AliasB_Amount}    Read Data From Excel    SERV01_LoanDrawdown    Loan_RequestedAmount    3
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Open Loan Notebook ###
    Search for Deal    ${Deal_Name}
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    ${Facility_Name}
    
    ### Combine Loans A and B ###
    ${RepricingDate_LoansAB}    Get Repricing Date of Loans then Validate if Equal    ${Loan_Alias_A}    ${Loan_Alias_B}
    Select Loan to Reprice    ${Loan_Alias_A}
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Multiple Loan to Merge    ${Loan_Alias_A}    ${Loan_Alias_B}
    
    ### Added pause execution to change effective date to a valid date since LIQ date is not correct during build of this keyword (step not included in screenshots) ###
    Pause Execution
    
    ### Validate Total of Existing Outstandings ###
    ${TotalExistingOutstanding_Amount}    Validate the Total Amount of Existing Outstandings    &{ExcelPath}[Pricing_Option]    ${Loan_Alias_A}    ${Loan_Alias_B}      ${Loan_AliasA_Amount}    ${Loan_AliasB_Amount}
    Validate Fields in Loan Repricing General Tab    &{ExcelPath}[Effective_Date] 
    Validate if Repricing Date and Effective Date in Loan Repricing are Equal    ${RepricingDate_LoansAB}    &{ExcelPath}[Effective_Date]
   
    ### Add New Outstandings ###
    ${Alias_LoanMerge}    Add New Outstandings    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Base_Rate]    &{ExcelPath}[NewLoan_Amount]
    ${Alias_LoanMerge}    Set Variable    60002489
    Validate General Tab of Pending Rollover/Conversion Notebook    ${Alias_LoanMerge}    &{ExcelPath}[Effective_Date]    &{ExcelPath}[Maturity_Date]    &{ExcelPath}[Repricing_Frequency]    &{ExcelPath}[Repricing_Date]
    ...    &{ExcelPath}[Payment_Mode]    &{ExcelPath}[Int_Cycle_Freq]    &{ExcelPath}[Actual_Due_Date]    &{ExcelPath}[Adjusted_Due_Date]    &{ExcelPath}[Accrue]    &{ExcelPath}[Accrual_End_Date]
    
    ### Add Interest Amount and Validate Amount ###
    Add Auto Generate Interest Payment for Loan Repricing
    Validate Interest Payments Amount    &{ExcelPath}[Pricing_Option]    ${Loan_Alias_A}    &{ExcelPath}[Expected_InterestAmt_LoanA]  
    Validate Interest Payments Amount    &{ExcelPath}[Pricing_Option]    ${Loan_Alias_B}    &{ExcelPath}[Expected_InterestAmt_LoanB]   
    
    ### Add Principal Payment ###
    ${Actual_PrincipalAmount}    Add Principal Payment after New Outstanding Addition    &{ExcelPath}[Pricing_Option]     &{ExcelPath}[NewLoan_Amount]   
    Write Data To Excel    SERV11_LoanMerge    NewLoan_Alias    1    ${Alias_LoanMerge}
    
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
    ### Pause execution because of breakfunding part to do it manually (step not included in screenshots)
    # Pause Execution
    Validate Window Title Status    ${LOAN_REPRICING}    ${RELEASED_STATUS}

    ### New Outstanding Validation ###
    Close All Windows on LIQ
    Open Existing Deal    ${Deal_Name}
    Navigate to Outstanding Select Window from Deal
    Validate the Merged Loan in Existing Loans    &{ExcelPath}[OutstandingSelect_Type]    ${Facility_Name}    ${Alias_LoanMerge}
    Validate Loan Drawdown Amounts in General Tab    &{ExcelPath}[Expctd_LoanGlobalOriginal]    &{ExcelPath}[Expctd_LoanGlobalCurrent]    &{ExcelPath}[Expctd_LoanHostBankGross]    &{ExcelPath}[Expctd_LoanHostBankNet]
    Validate Loan Drawdown General Details in General Tab    &{ExcelPath}[NewLoan_Pricing_Option]    &{ExcelPath}[Effective_Date]    &{ExcelPath}[Repricing_Frequency]    &{ExcelPath}[Repricing_Date]    &{ExcelPath}[Payment_Mode]    &{ExcelPath}[Int_Cycle_Freq]
    Validate Loan Drawdown Rates in Rates Tab    &{ExcelPath}[Expctd_LoanCurrentBaseRate]    &{ExcelPath}[Expctd_LoanSpread]    &{ExcelPath}[Expctd_LoanAllInRate]
    Validate Event Status in Loan Events Tab    ${RELEASED_STATUS}
    Close All Windows on LIQ
    
    



