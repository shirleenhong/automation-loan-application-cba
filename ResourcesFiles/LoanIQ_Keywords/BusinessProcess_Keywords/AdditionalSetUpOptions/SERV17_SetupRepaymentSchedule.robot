*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
   
*** Keywords ***
Create Initial Loan Drawdown with Repayment Schedule
    [Documentation]    @update: jdelacru    16OCT2019    - Deleted unused codes and release cashflow
    ...    @update: dahijara    15JUN2020    - Updated code for GL entries validation and removes hard coded branch code value
    ...                                      - Added currency parameter for getting host bank share in cash flow
    ...    @update: jloretiz    15JUL2020    - Added writing of loan alias to correspondence and updated argument
    [Arguments]    ${ExcelPath}
    
    ###Close all windows###
    # Close All Windows on LIQ
    # Logout from Loan IQ
    # Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    # ###Facility###
    # Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    # ${AvailToDrawAmount}    Get Facility Global Available to Draw Amount
    # ${GlobalOutstandings}    Get Facility Global Outstandings
    # Write Data To Excel    SERV01_LoanDrawdown   Facility_CurrentAvailToDraw    ${rowid}    ${AvailToDrawAmount}
    # Write Data To Excel    SERV01_LoanDrawdown   Facility_CurrentGlobalOutstandings    ${rowid}    ${GlobalOutstandings}
    
    # ##Outstanding Select Window###
    # Navigate to Outstanding Select Window
    # ${Loan_Alias}    Input Initial Loan Drawdown Details    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_Currency]
    # Write Data To Excel    SERV01_LoanDrawdown   Loan_Alias    ${rowid}    ${Loan_Alias}
    # Write Data To Excel    SERV21_InterestPayments   Loan_Alias    ${rowid}    ${Loan_Alias}
    # Run Keyword If    '${SCENARIO}'=='1'    Write Data To Excel    Correspondence    Loan_Alias    ${rowid}    ${Loan_Alias}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    # Run Keyword If    '${SCENARIO}'=='2'    Write Data To Excel    SERV21_InterestPayments   Loan_Alias    ${rowid}    ${Loan_Alias}
    # Run Keyword If    '${SCENARIO}'=='2'    Write Data To Excel    SERV18_Payments   Loan_Alias    ${rowid}    ${Loan_Alias}
        
    # ###Initial Loan Drawdown###
    # ${SysDate}    Get System Date
    # ${MaturityDate}    Add Days to Date    ${SysDate}    365
    # Run Keyword If    '${SCENARIO}'=='7'    Write Data To Excel    SERV35_Terminate_FacilityDeal    Loan_Alias    7    ${Loan_Alias}
    # Validate Initial Loan Dradown Details    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Loan_Currency]
    # ${AdjustedDueDate}    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    ${SysDate}    ${MaturityDate}    None    &{ExcelPath}[Loan_IntCycleFrequency]    &{ExcelPath}[Loan_Accrue]
    # Write Data To Excel    SERV21_InterestPayments    ScheduledActivityReport_Date    ${rowid}    ${AdjustedDueDate}
    # Input Loan Drawdown Rates    &{ExcelPath}[Borrower_BaseRate]    &{ExcelPath}[Facility_Spread]
    
    # ###Repayment Schedule###
    # Create Repayment Schedule for Fixed Loan with Interest
    
    # ###Cashflow Notebook - Create Cashflows###
    # Navigate to Drawdown Cashflow Window
    # Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    # Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]  
 
    # ##Get Transaction Amount for Cashflow###
    # ${HostBankShare}    Get Host Bank Cash in Cashflow    &{ExcelPath}[Loan_Currency]
    # ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
    # ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[HostBankSharePct]
    
    # Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
    # ###GL Entries###
    # Navigate to GL Entries
    # ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Debit Amt
    # ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower1_ShortName]    Credit Amt    
    # ${UITotalCreditAmt}    Run Keyword If    '&{ExcelPath}[BranchCode]' != 'None'    Get GL Entries Amount    ${SPACE}Total For: &{ExcelPath}[BranchCode]     Credit Amt
    # ...    ELSE    Get GL Entries Amount    ${SPACE}Total For: CB001     Credit Amt
    # ${UITotalDebitAmt}    Run Keyword If    '&{ExcelPath}[BranchCode]' != 'None'    Get GL Entries Amount    ${SPACE}Total For: &{ExcelPath}[BranchCode]     Debit Amt
    # ...    ELSE    Get GL Entries Amount    ${SPACE}Total For: CB001     Debit Amt
    # Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Debit}
    # Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}    ${Borrower_Credit}
    # Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    &{ExcelPath}[Loan_RequestedAmount]

    # ###Approval of Loan###
    # Send Initial Drawdown to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Set Test Variable    ${Loan_Alias}    60001209 
    Refresh Tables in LIQ    
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Initial Drawdown     ${Loan_Alias}
    Wait Until Keyword Succeeds    3    5s    Approve Initial Drawdown
    
    ###Rate Setting###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Send to Rate Approval    Loan Initial Drawdown     ${Loan_Alias}
    Send Initial Drawdown to Rate Approval
        
    ###Rate Approval###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Refresh Tables in LIQ
    Select Item in Work in Process    Outstandings    Awaiting Rate Approval    Loan Initial Drawdown     ${Loan_Alias}
    Approve Initial Drawdown Rate
    
    ###Intent Notices Generation
    Generate Rate Setting Notices for Drawdown    &{ExcelPath}[Borrower1_LegalName]    &{ExcelPath}[NoticeStatus]
    
    ###Cashflow Notebook - Release Cashflows###
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_Drawdown_WorkflowItems}    Release

    ### Release Loan Drawdown
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

Create Loan Drawdown TERM and SBLC for Syndicated Deal
    [Documentation]    This will serve as a High Level keyword for the creation of Loan Drawdown specific fow Syndicated Deal
    ...    @author: ritragel
    ...    @update: dfajardo    04AUG2020    Removed Script for generation of notices, it will be tested on CORRO
    ...                                      Updated release cashflow keyword to Release Cashflow Based on Remittance Instruction
    ...    @update: dfajardo    14SEP2020    Removed hard coded variables
    ...                                      Removed Repayment Schedule script
    [Arguments]    ${ExcelPath}

    ###Login to Original User###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ###Deal Notebook###
    Search for Deal    &{ExcelPath}[Deal_Name]
    
    ###Creation of Initial Loan Drawdown in Loan NoteBook###
    ${LoanEffectiveDate}    Get System Date
    Write Data To Excel    SERV01A_LoanDrawdown    Loan_EffectiveDate    ${rowid}    ${LoanEffectiveDate}
    Navigate to Outstanding Select Window from Deal
    ${Alias}    Create Loan Outstanding    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_Currency]  
    
    ###Write Data to Other TestCases###
    Write Data To Excel    SERV01A_LoanDrawdown    Loan_Alias    ${rowid}    ${Alias}
    Write Data To Excel    SERV08_ComprehensiveRepricing    Loan_Alias    ${rowid}    ${Alias}
    Write Data To Excel    SERV29_PaymentFees    Loan_Alias    ${rowid}    ${Alias}
    Write Data To Excel    SERV21_InterestPayments    Loan_Alias    ${rowid}    ${Alias}
    ${Alias}    Read Data From Excel    SERV01A_LoanDrawdown    Loan_Alias    ${rowid}
    Input General Loan Drawdown Details with Accrual End Date    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Loan_MaturityDate]   &{ExcelPath}[Loan_RepricingFrequency]    ${LoanEffectiveDate}
    Input Loan Drawdown Rates for Term Drawdown    &{ExcelPath}[Borrower_BaseRate]
    
    ###Creation of Repayment Schedule###
    Create Repayment Schedule - Fixed Payment
    Get Data from Automatic Schedule Setup
    ${CaculatedFixedPayment}    Verify Select Fixed Payment Amount
    
    Write Data To Excel    SERV21_InterestPayments    Loan_CalculatedFixedPayment    ${rowid}    ${CaculatedFixedPayment}
    ###Cashflow Notebook - Create Cashflows###
    Navigate to Drawdown Cashflow Window
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    
    ##Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]
    ${Lend2TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender2_ShortName]
    
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[HostBankSharePct]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[LenderSharePct1]
    ${ComputedLend2TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[LenderSharePct2] 
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}|${ComputedLend2TranAmount}
 
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    ${DEBIT_AMT_LABEL}
    ${Lender1_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    ${DEBIT_AMT_LABEL}
    ${Lender2_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender2_ShortName]    ${DEBIT_AMT_LABEL}
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    ${CREDIT_AMT_LABEL}
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For:    ${CREDIT_AMT_LABEL}
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For:    ${DEBIT_AMT_LABEL}
     
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    &{ExcelPath}[Loan_RequestedAmount]

    ###Approval of Loan###
    Send Initial Drawdown to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}     ${Alias}
    Approve Initial Drawdown
    
    ###Rate Setting###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_SEND_TO_RATE_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}     ${Alias}
    Send Initial Drawdown to Rate Approval
        
    ###Rate Approval###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}     ${Alias}
    Approve Initial Drawdown Rate
    
    ###Cashflow Notebook - Release Cashflows###
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Borrower_ShortName]
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance2_Instruction]    &{ExcelPath}[Lender1_ShortName]
    Release Loan Drawdown
    
    ###Cashflow Notebook - Complete Cashflows###
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance3_Description]    &{ExcelPath}[Remittance3_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    Release Cashflow    &{ExcelPath}[Lender2_ShortName]
    Close All Windows on LIQ
            
Create Term Loan Drawdown for SYNDICATED deal in USD
    [Documentation]    This keyword is used to create Term Loan Drawdown for SYNDICATED deal in USD
    ...    @author: ghabal
    ...    @update: jdelacru    26MAR2019    - Applied coding standards
    ...    @update: dahijara    28AUG2020    - Added keyword for getting Host bank and lender shares.
    ...                                      - Added writing to excel for SERV10_ConversionOfInterestType-Loan_Alias
    ...                                      - Updated arguments for Enter Loan Drawdown Details for USD Libor Option
    ...                                      - Refactored Verify Fixed Principal Payment Amount and Validate Total Amount of the Repayment Schedule vs Current Host Bank Amount
    ...                                      - Added writing to excel for SERV01_TermLoanDrawdowninUSD-Displayed_FixedPrincipalPaymentAmount and SERV01_TermLoanDrawdowninUSD-HostBank_Amount
    ...                                      - Added Navigate to Loan Drawdown Workflow and Proceed With Transaction
    ...                                      - Updated argument for Compute Lender Share Transaction Amount with ${HostBankSharePct} & ${LenderSharePct1}
    ...                                      - Updated hard coded values.
    ...                                      - Updated codes for Release Cashflow Based on Remittance Instruction
    ...                                      - Updated validation to add amount conversion.
    [Arguments]    ${ExcelPath}     
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
        
    ###Deal Notebook###
    Open Existing Deal    &{ExcelPath}[Deal_Name]

    ###Lender Shares###
    ${HostBankSharePct}    ${LenderSharePct1}    Get Host Bank and Lender Shares    &{ExcelPath}[HostBank_LegalName]    &{ExcelPath}[Lender1_LegalName]
    
    ###Facility Notebook###
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    ${AvailToDrawAmount}    Get Facility Global Available to Draw Amount
    ${GlobalOutstandings}    Get Facility Global Outstandings
    Write Data To Excel    SERV01_TermLoanDrawdowninUSD   Facility_CurrentAvailToDraw    ${rowid}    ${AvailToDrawAmount}
    Write Data To Excel    SERV01_TermLoanDrawdowninUSD   Facility_CurrentGlobalOutstandings    ${rowid}    ${GlobalOutstandings}

    ###Outstanding Select###
    Navigate to Outstanding Select Window
    ${LoanEffectiveDate}    Get System Date  
    Write Data To Excel    SERV01_TermLoanDrawdowninUSD    Loan_EffectiveDate    ${rowid}    ${LoanEffectiveDate}
    
    ### Initial Loan Drawdown###
    ${New_Loan_Alias}    Enter Initial Loan Drawdown Details    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_Currency]    ${rowid}    &{ExcelPath}[Facility_Currency]
    Write Data To Excel    SERV01_TermLoanDrawdowninUSD    Loan_Alias    ${rowid}    ${New_Loan_Alias}    
    Write Data To Excel    SERV10_ConversionOfInterestType    Loan_Alias    ${rowid}    ${New_Loan_Alias}    
    ${Loan_Alias}    Read Data From Excel    SERV01_TermLoanDrawdowninUSD   Loan_Alias    ${rowid}
    ${MaturityDate}    Read Data From Excel    SERV01_TermLoanDrawdowninUSD    Loan_MaturityDate    ${rowid}
    Enter Loan Drawdown Details for USD Libor Option    &{ExcelPath}[Loan_RequestedAmount]    ${LoanEffectiveDate}    ${MaturityDate}    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_IntCycleFrequency]    &{ExcelPath}[Loan_Accrue]    &{ExcelPath}[Loan_RiskType]
    Input Loan Drawdown Rates for Term Facility (USD)    &{ExcelPath}[Borrower_BaseRate]
    
    ###Repayment Schedule###
    Create Repayment Schedule - Fixed Principal Plus Interest Due
    ${DisplayFixedPrincipalPaymentAmount}    Verify Fixed Principal Payment Amount
    Write Data To Excel    SERV01_TermLoanDrawdowninUSD    Displayed_FixedPrincipalPaymentAmount    ${rowid}     ${DisplayFixedPrincipalPaymentAmount}
    ${DisplayCurrentHostBankAmount}    Validate Total Amount of the Repayment Schedule vs Current Host Bank Amount
    Write Data To Excel    SERV01_TermLoanDrawdowninUSD    HostBank_Amount    ${rowid}    ${DisplayCurrentHostBankAmount}
      
    ##Cashflows###  
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RemittanceDescription]    &{ExcelPath}[Borrower1_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender1_RemittanceDescription]    &{ExcelPath}[Lender1_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    
    ${HostBankShare}    Get Host Bank Cash in Cashflow    USD
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]
    
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    ${HostBankSharePct}
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    ${LenderSharePct1}
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}
    
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    ${DEBIT_AMT_LABEL}
    ${Lender1_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    ${DEBIT_AMT_LABEL}
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower1_ShortName]    ${CREDIT_AMT_LABEL}
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    ${CREDIT_AMT_LABEL}
    ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    ${DEBIT_AMT_LABEL}
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}    ${HostBank_Debit}|${Lender1_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}|${Lender1_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    &{ExcelPath}[Loan_RequestedAmount]
    
    ###Initial Loan Drawdown###
    Send Initial Drawdown to Approval
    
    ###LIQ Window###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Work in Process - Loan Notebook###
    Approve Initial Loan Drawdown via WIP    ${Loan_Alias}
    Set FX Rates Loan Drawdown    &{ExcelPath}[Loan_Currency]
    
    
    ###LIQ Window###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
           
    ###Work in Process - Loan Notebook###
    Send to Rate Approval Initial Loan Drawdown via WIP    ${Loan_Alias}
    
    ###LIQ Window###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Work in Process - Loan Notebook###
    Rate Approval Initial Loan Drawdown via WIP    ${Loan_Alias}
    
    ###LIQ Window###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
        
    ###Notice Window###
    Generate Rate Setting Notices via WIP    &{ExcelPath}[Lender1_LegalName]    &{ExcelPath}[RateSettingNotice_Status]    ${Loan_Alias}
    
    ###LIQ Window###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Work in Process###
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    
    ###Cashflow###
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Borrower1_RemittanceInstruction]    &&{ExcelPath}[Borrower1_ShortName]|&{ExcelPath}[Lender1_ShortName]
        
    ###Initial Loan Drawdown Notebook###
    Release Initial Loan Drawdown    ${Loan_Alias}
    
    ###LIQ Window###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
        
    ###Deal Notebook###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Facility Notebook###
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    ${CurrentCmtAmt}    Get Current Commitment Amount
    ${NewGlobalOutstandings}    Get New Facility Global Outstandings
    ${Facility_CurrentGlobalOutstandings}    Read Data From Excel    SERV01_TermLoanDrawdowninUSD    Facility_CurrentGlobalOutstandings    ${rowid}
    ${FacilityCurrency}    Read Data From Excel    CRED02_FacilitySetup    Facility_Currency    ${rowid}
    ${NewLoanAlias}    Read Data From Excel    SERV01_TermLoanDrawdowninUSD    Loan_Alias    ${rowid}
    ${LoanEffectiveDate}    Read Data From Excel    SERV01_TermLoanDrawdowninUSD    Loan_EffectiveDate    ${rowid}

    ${ConvertedLoanRequestAmount}    Convert Loan Requested Amount Based On Currency FX Rate    ${FacilityCurrency}    &{ExcelPath}[Loan_Currency]    &{ExcelPath}[Loan_RequestedAmount]    ${NewLoanAlias}    ${LOAN_TYPE}    &{ExcelPath}[Facility_Name]    ${LoanEffectiveDate}

    ${Computed_GlobalOutstandings}    Compute New Global Outstandings of the Facility    ${Facility_CurrentGlobalOutstandings}    ${ConvertedLoanRequestAmount}
    Validate Outstandings    ${NewGlobalOutstandings}    ${Computed_GlobalOutstandings}    
    ${NewAvailToDrawAmount}    Get New Facility Available to Draw Amount
    ${AvailToDrawAmount}    Read Data From Excel    SERV01_TermLoanDrawdowninUSD   Facility_CurrentAvailToDraw    ${rowid}
    ${Computed_AvailToDrawAmt}    Compute New Facility Available to Draw Amount after Drawdown    ${AvailToDrawAmount}    ${ConvertedLoanRequestAmount}
    Validate Draw Amounts    ${NewAvailToDrawAmount}    ${Computed_AvailToDrawAmt}    
    Validate Global Facility Amounts - Balanced    ${NewAvailToDrawAmount}    ${NewGlobalOutstandings}    ${CurrentCmtAmt}
    Close All Windows on LIQ
    
Create Initial Loan Drawdown for Syndicated Deal with Repayment Schedule
    [Documentation]    This keyword is used to Fixed Loan Drawdown for SYNDICATED
    ...    @author: dfajardo
    [Arguments]    ${ExcelPath}
    
    ##Close all windows##
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Facility###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    ${AvailToDrawAmount}    Get Facility Global Available to Draw Amount
    ${GlobalOutstandings}    Get Facility Global Outstandings
    Write Data To Excel    SERV01_LoanDrawdown   Facility_CurrentAvailToDraw    ${rowid}    ${AvailToDrawAmount}
    Write Data To Excel    SERV01_LoanDrawdown   Facility_CurrentGlobalOutstandings    ${rowid}    ${GlobalOutstandings}
    
    ##Outstanding Select Window###
    Navigate to Outstanding Select Window
    ${Loan_Alias}    Input Initial Loan Drawdown Details    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_Currency]
    Write Data To Excel    SERV01_LoanDrawdown   Loan_Alias    ${rowid}    ${Loan_Alias}
    Write Data To Excel    SERV21_InterestPayments   Loan_Alias    ${rowid}    ${Loan_Alias}
    Run Keyword If    '${SCENARIO}'=='1'    Write Data To Excel    Correspondence    Loan_Alias    ${rowid}    ${Loan_Alias}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Run Keyword If    '${SCENARIO}'=='2'    Write Data To Excel    SERV21_InterestPayments   Loan_Alias    ${rowid}    ${Loan_Alias}
    Run Keyword If    '${SCENARIO}'=='2'    Write Data To Excel    SERV18_Payments   Loan_Alias    ${rowid}    ${Loan_Alias}
        
    ###Initial Loan Drawdown###
    Run Keyword If    '${SCENARIO}'=='7'    Write Data To Excel    SERV35_Terminate_FacilityDeal    Loan_Alias    7    ${Loan_Alias}
    Validate Initial Loan Dradown Details    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Loan_Currency]
    ${AdjustedDueDate}    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_MaturityDate]    None    &{ExcelPath}[Loan_IntCycleFrequency]    &{ExcelPath}[Loan_Accrue]
    Write Data To Excel    SERV21_InterestPayments    ScheduledActivityReport_Date    ${rowid}    ${AdjustedDueDate}
    Input Loan Drawdown Rates    &{ExcelPath}[Borrower_BaseRate]    &{ExcelPath}[Facility_Spread]
    
    ###Repayment Schedule###
    Create Repayment Schedule for Fixed Loan with Interest
    
     ##Cashflow Notebook - Create Cashflows###
    Navigate to Drawdown Cashflow Window
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    
    ##Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]
    ${Lend2TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender2_ShortName]
    
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[HostBankSharePct]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[LenderSharePct1]
    ${ComputedLend2TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[LenderSharePct2] 
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}|${ComputedLend2TranAmount}
 
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    ${DEBIT_AMT_LABEL}
    ${Lender1_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    ${DEBIT_AMT_LABEL}
    ${Lender2_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender2_ShortName]    ${DEBIT_AMT_LABEL}
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    ${CREDIT_AMT_LABEL}
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For:    ${CREDIT_AMT_LABEL}
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For:    ${DEBIT_AMT_LABEL}
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    &{ExcelPath}[Loan_RequestedAmount]

    ###Approval of Loan###
    Send Initial Drawdown to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Approve Initial Drawdown
    
    ###Rate Setting###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_SEND_TO_RATE_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}     ${Loan_Alias}
    Send Initial Drawdown to Rate Approval
        
    ###Rate Approval###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}     ${Loan_Alias}
    Approve Initial Drawdown Rate
    
    ###Cashflow Notebook - Release Cashflows###
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Borrower_ShortName]
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance2_Instruction]    &{ExcelPath}[Lender1_ShortName]
    Release Loan Drawdown
    
    ###Cashflow Notebook - Complete Cashflows###
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance3_Description]    &{ExcelPath}[Remittance3_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    Release Cashflow    &{ExcelPath}[Lender2_ShortName]
    Close All Windows on LIQ
    
