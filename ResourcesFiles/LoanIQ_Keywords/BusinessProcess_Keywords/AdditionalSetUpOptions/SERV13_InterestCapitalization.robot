*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
 
*** Keywords ***
Setup Interest Capitalization
    [Documentation]    This keyword is used to setup Interest Capitalization
    ...    @author: ghabal
    ...    @update: sahalder    28MAY2020    - Added Take Screenshot,Commented duplicate WIP approval steps  
    ...    @update: dahijara    30JUL2020    - Removed screenshot in test case level keyword.
    ...                                      - Updated parameters for Enter Loan Drawdown Details
    ...                                      - Updated navigation to Loan Drawdown Workflow
    ...                                      - Removed commented codes.
    ...    @update: dahijara    04AUG2020    - Replaced hardcoded value for Maturity date days.
    [Arguments]    ${ExcelPath}       
    ##LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ###Searching a deal###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Navigating a Facility###
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Loan_FacilityName]
    
    ###Outstanding Select Window###
    Navigate to Outstanding Select Window
    ${Loan_Alias}    Enter Initial Loan Drawdown Details    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Loan_FacilityName]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_Currency]    ${rowid}    &{ExcelPath}[Facility_Currency]    
    Write Data To Excel    SERV13_InterestCapitalization    Loan_Alias    ${rowid}    ${Loan_Alias}
    Write Data To Excel    SERV08C_ComprehensiveRepricing    Loan_Alias    ${rowid}    ${Loan_Alias}
    Write Data To Excel    TRP002_SecondarySale    Loan_Alias    ${rowid}    ${Loan_Alias}
    
    # ###Loan Drawdown Notebook###
    ${Loan_Alias}    Read Data From Excel    SERV13_InterestCapitalization    Loan_Alias    ${rowid}
    Validate Initial Loan Dradown Details    &{ExcelPath}[Loan_FacilityName]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Loan_Currency]
    ${Loan_EffectiveDate}    Get System Date
    ${Loan_MaturityDate}    Add Days to Date    ${Loan_EffectiveDate}    &{ExcelPath}[Loan_AddDaysForMaturityDate]
    Write Data To Excel    SERV13_InterestCapitalization    Loan_EffectiveDate    ${rowid}    ${Loan_EffectiveDate}
    Write Data To Excel    SERV13_InterestCapitalization    Loan_MaturityDate    ${rowid}    ${Loan_EffectiveDate}
    Enter Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    ${Loan_EffectiveDate}    ${Loan_MaturityDate}    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_IntCycleFrequency]    &{ExcelPath}[Loan_Accrue]    &{ExcelPath}[Loan_RiskType]
    Enter Loan Drawdown Rates    &{ExcelPath}[Borrower_BaseRate]    &{ExcelPath}[Facility_Spread]

    ###Interest Capitalization Details###
    Enter Interest Capitalization Details    &{ExcelPath}[Capitalization_Frequency]    &{ExcelPath}[Capitalization_FromDate]    &{ExcelPath}[Capitalization_ToDate]    ${Loan_Alias}    Untick    Untick
    
    ###Cashflows###  
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RemittanceDescription]    &{ExcelPath}[Borrower1_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender1_RemittanceDescription]    &{ExcelPath}[Lender1_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]
    
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[HostBankSharePct]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[LenderSharePct1]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}

    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Debit Amt
    ${Lender1_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    Debit Amt
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower1_ShortName]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}    ${HostBank_Debit}|${Lender1_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}|${Lender1_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalCreditAmt}    &{ExcelPath}[Loan_RequestedAmount]

    ###Loan Drawdown Notebook - Send to Approval###
    Send Loan Drawdown to Approval
                
    ##Loan Drawdown Notebook - Approval###
    Approve Loan Drawdown via WIP    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}   &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingApprovalStatus]    &{ExcelPath}[WIP_OutstandingType]    ${Loan_Alias}
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Facility Notebook###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Loan_FacilityName]
    
    ###Loan Drawdown Notebook###
    Navigate to Outstanding Select Window
    Navigate to Pending Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Loan_FacilityName]    ${Loan_Alias}
     
    ###Loan Drawdown Notebook###
    Send Loan Drawdown Rates to Approval
     
    ###LIQ Window####
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Rate Approval    Loan Initial Drawdown    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Rate Approval
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Release
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD} 
    
Process Interest Payment for Capitalize Interest
    [Documentation]    This keyword do Interest Payment for Capitalize Interest (Scenario 8)
    ...    @author: ghabal
    ...    @update: dahijara    14OCT2020    Added Login for inputter.
    ...                                      Removed unused/missing keywords in codebase.
    ...                                      Add correct flow for cashflow creation.
    ...                                      Fix computations
    ...                                      Update navigation in WIP
    ...                                      Replaced hard coded  values
         
    [Arguments]    ${ExcelPath}           
    ##LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Searching a deal
    Open Existing Deal in Inquiry Mode    &{ExcelPath}[Deal_Name]
    
    # # ##...Navigating a Facility and Get Values
    Navigate to Facility Notebook from Deal Notebook in Inquiry Mode    &{ExcelPath}[Loan_FacilityName]
    ${Orig_FacilityProposedcmt}    ${Orig_FacilityClosingCmt}    ${Orig_FacilityCurrentCmt}    ${Orig_FacilityOutstandings}    ${Orig_FacilityAvailableToDraw}    Get Original Data on Global Facility Amounts Section
    Write Data To Excel    CAP03_InterestPayment    Orig_FacilityProposedcmt    ${rowid}    ${Orig_FacilityProposedcmt}
    Write Data To Excel    CAP03_InterestPayment    Orig_FacilityClosingCmt    ${rowid}    ${Orig_FacilityClosingCmt}
    Write Data To Excel    CAP03_InterestPayment    Orig_FacilityCurrentCmt    ${rowid}    ${Orig_FacilityCurrentCmt}
    Write Data To Excel    CAP03_InterestPayment    Orig_FacilityOutstandings    ${rowid}    ${Orig_FacilityOutstandings}
    Write Data To Excel    CAP03_InterestPayment    Orig_FacilityAvailableToDraw    ${rowid}    ${Orig_FacilityAvailableToDraw}
    
    #...Outstanding Select Window###
    Navigate to Outstanding Select Window
    
    # ##...Navigating to existing loan and get values
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Loan_FacilityName]    &{ExcelPath}[Loan_Alias]
    
    ${Orig_LoanGlobalOriginal}    ${Orig_LoanGlobalCurrent}    ${Orig_LoanHostBankGross}    ${Orig_LoanHostBankNet}    Get Original Data on Loan Amounts Section  
    Write Data To Excel    CAP03_InterestPayment    Orig_LoanGlobalOriginal    ${rowid}    ${Orig_LoanGlobalOriginal}
    Write Data To Excel    CAP03_InterestPayment    Orig_LoanGlobalCurrent    ${rowid}    ${Orig_LoanGlobalCurrent}
    Write Data To Excel    CAP03_InterestPayment    Orig_LoanHostBankGross    ${rowid}    ${Orig_LoanHostBankGross}
    Write Data To Excel    CAP03_InterestPayment    Orig_LoanHostBankNet    ${rowid}    ${Orig_LoanHostBankNet}
    
    ${SystemDate}    Get System Date
    ${InterestPayment_EffectiveDate}    Get System Date
    ${ProjectedCycleDue}    Compute Interest Payment Amount Per Cycle - Zero Cycle Due    &{ExcelPath}[Loan_CycleNumber]    ${SystemDate}
    
    Write Data To Excel    CAP03_InterestPayment    Computed_LoanIntProjectedCycleDue    ${rowid}    ${ProjectedCycleDue}   
    ${Computed_LoanIntProjectedCycleDue}    Read Data From Excel    CAP03_InterestPayment    Computed_LoanIntProjectedCycleDue    ${rowid}
    
    # ##...Step 2-5    
    Initiate Loan Interest Payment (Scenario 8)    &{ExcelPath}[Loan_CycleNumber]    &{ExcelPath}[Pro_Rate]
    Input Effective Date and Requested Amount for Loan Interest Payment    ${InterestPayment_EffectiveDate}    ${ProjectedCycleDue}
    
    # ##...Step 5-6
    View Lender Shares From Interest Payment Window
    
    Validate Lender Shares    &{ExcelPath}[Lender_Name1]    &{ExcelPath}[Lender_SharePercentage1]    ${Computed_LoanIntProjectedCycleDue}    Lender_ShareAmount1
    Validate Lender Shares    &{ExcelPath}[Lender_Name2]    &{ExcelPath}[Lender_SharePercentage2]    ${Computed_LoanIntProjectedCycleDue}    Lender_ShareAmount2    
    Validate Lender Shares    &{ExcelPath}[Lender_Name3]    &{ExcelPath}[Lender_SharePercentage3]    ${Computed_LoanIntProjectedCycleDue}    Lender_ShareAmount3    
    Close Lender Shares Window
    
    ### Cashflow Notebook - Create Cashflows ###
    Navigate to Payment Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Verify if Method has Remittance Instruction    &{ExcelPath}[Loan_Borrower]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender_Name2]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender_Name3]    &{ExcelPath}[Remittance3_Description]    &{ExcelPath}[Remittance3_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Loan_Borrower]
    Verify if Status is set to Do It    &{ExcelPath}[Lender_Name2]
    Verify if Status is set to Do It    &{ExcelPath}[Lender_Name3]
    Close GL Entries and Cashflow Window

    # # ##...Step 13            
    Do Generate Intent Notices for an Interest Payment (for Scenario 8)
    Verify Customer Notice Method    &{ExcelPath}[Lender1_LegalName]    &{ExcelPath}[Lender1_IntenNoticeContact]    &{ExcelPath}[IntentNoticeStatus]    ${INPUTTER_USERNAME}    &{ExcelPath}[Lender1_IntentNoticeMethod]    &{ExcelPath}[Lender1_ContactEmail]
    Verify Customer Notice Method    &{ExcelPath}[Lender2_LegalName]    &{ExcelPath}[Lender2_IntenNoticeContact]    &{ExcelPath}[IntentNoticeStatus]    ${INPUTTER_USERNAME}    &{ExcelPath}[Lender2_IntentNoticeMethod]    &{ExcelPath}[Lender2_ContactEmail]
    Verify Customer Notice Method    &{ExcelPath}[Borrower_LegalName]    &{ExcelPath}[Borrower_IntenNoticeContact]    &{ExcelPath}[IntentNoticeStatus]    ${INPUTTER_USERNAME}    &{ExcelPath}[Borrower_IntentNoticeMethod]    &{ExcelPath}[Borrower_ContactEmail]
    Close Interest Payment Notice Window
    
    ##...Step 14     
    Send Loan Interest Payment to Approval (Scenario 8)
    
    # ##...Step 15
    # # ##...Logout and Relogin in Supervisor Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
   
    ###Work in Process#####
    Navigate Transaction in WIP     ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${INTEREST_PAYMENT}    &{ExcelPath}[Loan_Alias]
    ##Workflow Tab - Approval###
    Navigate to Payment Workflow and Proceed With Transaction    ${APPROVAL_STATUS}

    # ##...Step 16
    # # ##...Logout and Relogin in Manager Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Work in Process#####
    Navigate Transaction in WIP     ${PAYMENTS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${INTEREST_PAYMENT}    &{ExcelPath}[Loan_Alias]

    # # ##Workflow Tab - Release###
    Navigate to Payment Workflow and Proceed With Transaction    ${RELEASE_STATUS}
      
    #Step 17: Validation on Interest Payment Notebook (MANAGER)###
    Validation on Interest Payment Notebook - Events Tab 
    
    View Lender Shares From Interest Payment Window
    
    Validate Lender Shares    &{ExcelPath}[Lender_Name1]    &{ExcelPath}[Lender_SharePercentage1]    ${Computed_LoanIntProjectedCycleDue}    Lender_ShareAmount1
    Validate Lender Shares    &{ExcelPath}[Lender_Name2]    &{ExcelPath}[Lender_SharePercentage2]    ${Computed_LoanIntProjectedCycleDue}    Lender_ShareAmount2    
    Validate Lender Shares    &{ExcelPath}[Lender_Name3]    &{ExcelPath}[Lender_SharePercentage3]    ${Computed_LoanIntProjectedCycleDue}    Lender_ShareAmount3    
    Close Lender Shares Window
          
    ###Step 18: Validation on Loan Notebook (MANAGER)###
    ${Orig_LoanGlobalOriginal}    Read Data From Excel    CAP03_InterestPayment    Orig_LoanGlobalOriginal    ${rowid}    
    ${Orig_LoanGlobalCurrent}    Read Data From Excel    CAP03_InterestPayment    Orig_LoanGlobalCurrent    ${rowid}    
    ${Orig_LoanHostBankGross}    Read Data From Excel    CAP03_InterestPayment    Orig_LoanHostBankGross    ${rowid}    
    ${Orig_LoanHostBankNet}    Read Data From Excel    CAP03_InterestPayment    Orig_LoanHostBankNet    ${rowid}          
    
    Get Updated and Validate Data on Loan Amounts Section    ${Orig_LoanGlobalOriginal}    ${Orig_LoanGlobalCurrent}    &{ExcelPath}[Computed_LoanIntProjectedCycleDue]    &{ExcelPath}[CurrentAmount_ExpectedIncreasePercentage] 
    
    #####Step 19: Validation on the FX rate
    Validate Currency against FX rate in API    &{ExcelPath}[FXrate_fromAPI]
    
    ${Orig_FacilityOutstandings}    Read Data From Excel    CAP03_InterestPayment    Orig_FacilityOutstandings    ${rowid}
    Validate Conversion Amount for the Increase in Loan Amount    &{ExcelPath}[FXrate_fromAPI]    &{ExcelPath}[Computed_IncreasedCurrentAmount]    ${Orig_FacilityOutstandings}
       
    # #####Step 20 Validation on Loan Notebook (MANAGER)###
    Navigate to Outstanding Select Window
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Loan_FacilityName]    &{ExcelPath}[Loan_Alias]
    
    Validation on Loan Notebook - Events Tab
    ${HostBank_Percentage}    Get Host Bank Percentage in Lender Shares Window From Loan Notebook    &{ExcelPath}[HostBank_Name]
    
    Get Updated and Validate Loan Amounts    ${Orig_LoanGlobalOriginal}    ${Orig_LoanGlobalCurrent}    &{ExcelPath}[Computed_LoanIntProjectedCycleDue]    &{ExcelPath}[CurrentAmount_ExpectedIncreasePercentage]    ${Orig_LoanHostBankGross}
    ...    ${Orig_LoanHostBankNet}    ${HostBank_Percentage}    ${HostBank_Percentage}    &{ExcelPath}[Computed_IncreasedCurrentAmount]
       
    Validation on Loan Notebook - Pending Tab
    
    # # #####Step 21 Validation on Facility Notebook (MANAGER)###        
    ${Orig_FacilityCurrentCmt}    Read Data From Excel    CAP03_InterestPayment    Orig_FacilityCurrentCmt    ${rowid}    
    ${Orig_FacilityOutstandings}    Read Data From Excel    CAP03_InterestPayment    Orig_FacilityOutstandings    ${rowid}    
    ${Orig_FacilityAvailableToDraw}    Read Data From Excel    CAP03_InterestPayment    Orig_FacilityAvailableToDraw    ${rowid}    
    
    Get Updated and Validate Facility Amounts    ${Orig_FacilityCurrentCmt}    ${Orig_FacilityOutstandings}    ${Orig_FacilityAvailableToDraw}    &{ExcelPath}[Computed_IncreasedCurrentAmountinAUD]

    Close All Windows on LIQ
    
Create Interest Capitalisation Rule
    [Documentation]    This keyword create Interest Capitalisation Rule at Outstanding level (Advance Servicing)
    ...    @author: ghabal      
    [Arguments]    ${ExcelPath}       
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Deal Notebook###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Navigating a Facility###
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    
    ###Outstanding Select Window###
    Navigate to Outstanding Select Window
    
    ###Navigating to existing loan###
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]    
    ${LoanCapitalization_FromDate}    Get System Date
    ${LoanCapitalization_ToDate}    Add Days to Date    ${LoanCapitalization_FromDate}    90
    Write Data To Excel    CAP02_InterestCapitalRule    LoanCapitalization_FromDate    ${rowid}    ${LoanCapitalization_FromDate}
    Write Data To Excel    CAP02_InterestCapitalRule    LoanCapitalization_ToDate    ${rowid}    ${LoanCapitalization_ToDate}       
    
    ###Add Capitalize Interest Details###
    ${CapitalizeFrom_Value}    Enter Capitalize Interest Details    ${LoanCapitalization_FromDate}    ${LoanCapitalization_ToDate}    &{ExcelPath}[PercentofPayment]    
    Write Data To Excel    CAP02_InterestCapitalRule    CapitalizeFromToLoan_Value    ${rowid}    ${CapitalizeFrom_Value}
          
    ###Validate Capitalize Interest Details### 
    Validate Capitalize Interest Details    ${LoanCapitalization_FromDate}    ${LoanCapitalization_ToDate}    &{ExcelPath}[PercentofPayment]    ${CapitalizeFrom_Value}
    Close All Windows on LIQ

