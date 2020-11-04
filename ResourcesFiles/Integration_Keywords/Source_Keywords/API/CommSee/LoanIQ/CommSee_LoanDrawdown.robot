*** Settings ***
Resource     ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Loan Drawdown for Syndicated Deal - ComSee
    [Documentation]    This will serve as a High Level keyword for the creation of Loan Drawdown specific fow Syndicated Deal
    ...    @author: rtarayao    16SEP2019    - Duplicate high level keyword from Functional Scenario 2.
    ...    @update: cfrancis    14OCT2020    - moved getting system date before Search for Deal keyword
    [Arguments]    ${ExcelPath}

    ##Login to Original User###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ###Deal Notebook###
    ${LoanEffectiveDate}    Get System Date
    Search for Deal    &{ExcelPath}[Deal_Name]
    
    ###Creation of Initial Loan Drawdown in Loan NoteBook###   
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_EffectiveDate    ${rowid}    ${LoanEffectiveDate}    ${ComSeeDataSet}
    Navigate to Outstanding Select Window from Deal
    ${Alias}    Create Loan Outstanding    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_Currency]  
    
    ###Write Data to Other TestCases###
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_Alias    ${rowid}    ${Alias}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_LoanRepricing    Outstanding_Alias    ${rowid}    ${Alias}    ${ComSeeDataSet}
    ${Alias}    Read Data From Excel    ComSee_SC2_Loan    Outstanding_Alias    ${rowid}    ${ComSeeDataSet}
    Input General Loan Drawdown Details with Accrual End Date    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Loan_MaturityDate]   &{ExcelPath}[Loan_RepricingFrequency]    ${LoanEffectiveDate}
    Input Loan Drawdown Rates for Term Drawdown    &{ExcelPath}[Borrower_BaseRate]
    
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
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}|${ComputedLend2TranAmount}
 
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Debit Amt
    ${Lender1_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    Debit Amt
    ${Lender2_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender2_ShortName]    Debit Amt
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For:    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For:    Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}    ${HostBank_Debit}|${Lender1_Debit}
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}|${Lender1_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    &{ExcelPath}[Loan_RequestedAmount]

    ###Approval of Loan###
    Send Initial Drawdown to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Approval    Loan Initial Drawdown     ${Alias}
    Approve Initial Drawdown
    
    ###Rate Setting###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Send to Rate Approval    Loan Initial Drawdown     ${Alias}
    Send Initial Drawdown to Rate Approval
        
    ###Rate Approval###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Rate Approval    Loan Initial Drawdown     ${Alias}
    Approve Initial Drawdown Rate
    
    ##Cashflow Notebook - Release Cashflows###
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_Drawdown_WorkflowItems}    Release 
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Borrower_ShortName]|&{ExcelPath}[Lender1_ShortName]|&{ExcelPath}[Lender2_ShortName]
    # # Release Cashflow    &{ExcelPath}[Borrower_ShortName]|&{ExcelPath}[Lender1_ShortName]
    Release Loan Drawdown
    
    ###Cashflow Notebook - Complete Cashflows###
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance3_Description]    &{ExcelPath}[Remittance3_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    # Release Cashflow    &{ExcelPath}[Lender2_ShortName]
    # Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Borrower1_RemittanceInstruction]    &{ExcelPath}[Borrower1_ShortName]|&{ExcelPath}[Lender1_ShortName]
    
    Close All Windows on LIQ
    Logout from Loan IQ
    
Pay Loan Outstanding Accrual Zero Cycle Due
    [Documentation]    This keyword update the PaidToDate value after Payment transaction has been made. 
    ...    @author: sacuisia 02OCT2020    -initialCreate
    [Arguments]    ${ExcelPath}    ${sCyclesForLoan}=None    
    
    ${CyclesForLoan}    Acquire Argument Value    ${sCyclesForLoan}
    
    Launch Loan Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Outstanding_Alias]
    
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ select    ${LIQ_Loan_Options_Payment}
    mx LoanIQ activate window    ${LIQ_Loan_ChoosePayment_Window} 
    Mx LoanIQ Set    ${LIQ_Loan_ChoosePayment_InterestPayment_RadioButton}    ON
    mx LoanIQ click    ${LIQ_Loan_ChoosePayment_OK_Button}
    
    ### Cycles for Loan Window Selection Condition ###
    mx LoanIQ activate window    ${LIQ_Loan_CyclesforLoan_Window} 
    Run Keyword If    '${sCyclesForLoan}'=='1'    mx LoanIQ enter   ${LIQ_CyclesForLoan_LenderSharesPrepayCycle_RadioButton}    ${ON}
    ...    ELSE IF    '${sCyclesForLoan}'=='0'    mx LoanIQ enter    ${LIQ_CyclesForLoan_LenderSharesPrepayCycle_RadioButton}    ${OFF}
    Run Keyword If    '${sCyclesForLoan}'=='1'    mx LoanIQ enter    ${LIQ_CyclesForLoan_CycleDue_RadioButton}    ${ON}
    ...    ELSE IF    '${sCyclesForLoan}'=='0'    mx LoanIQ enter    ${LIQ_CyclesForLoan_CycleDue_RadioButton}    ${OFF}
    Run Keyword If    '${sCyclesForLoan}'=='1'    mx LoanIQ enter    ${LIQ_Loan_CyclesforLoan_ProjectedDue_RadioButton}    ${ON}
    ...    ELSE IF    '${sCyclesForLoan}'=='0'    mx LoanIQ enter    ${LIQ_Loan_CyclesforLoan_ProjectedDue_RadioButton}    ${OFF}
	Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CyclesForLoanWindow
    mx LoanIQ click    ${LIQ_CyclesForLoan_Ok_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    
    ${ProjectedCycleDue}    Get ProjectedCycleDue
    Write Data To Excel    ComSee_SC2_Loan    ProjectedCycleDue    ${rowid}    ${ProjectedCycleDue}    ${ComSeeDataSet}
    
    ${ProjectedCycleDue}    Run Keyword If    '&{ExcelPath}[OverPayment]'!='${EMPTY}'    Evaluate    ${ProjectedCycleDue} + &{ExcelPath}[OverPayment]
    ...    ELSE    Set Variable    ${ProjectedCycleDue}

    ${requestAmount}    Get Requested Amount
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_paidToDate    ${rowid}    ${requestAmount}    ${ComSeeDataSet}    
    
    ${SysDate}    Get System Date
    mx LoanIQ enter    ${LIQ_InterestPayment_EffectiveDate_Textfield}    ${SysDate}
    Mx LoanIQ select    ${LIQ_InterestPayment_FileSave_Menu}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    
    Generate Intent Notices of an Interest Payment-CommSee    ${ExcelPath}[Borrower_ShortName]
    Send Loan Payment to Approval
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    Navigate Transaction in WIP    Payments    Awaiting Approval    Interest Payment    &{ExcelPath}[Deal_Name]
    
    Approve Interest Payment
    Release Interest Payment
    
    Launch Loan Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Outstanding_Alias]
    
    ##Acrued Amount after EOD
    ${LoanAccruedtodateAmount}    Get Loan Accrued to Date Amount
    ${LoanAccruedtodateAmount}    Remove Comma and Convert to Number    ${LoanAccruedtodateAmount}
    ${TotalRowCount}    Get Accrual Row Count    ${LIQ_Loan_Window}    ${LIQ_Loan_AccrualTab_Cycles_Table}
    ${AccruedtoDateAmt}    Compute Total Accruals for Fee    ${TotalRowCount}    ${LIQ_Loan_Tab}    ${LIQ_Loan_AccrualTab_Cycles_Table}
    ${AccruedtoDateAmt}    Remove Comma and Convert to Number    ${AccruedtoDateAmt}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_AccruedInterest    ${rowid}    ${LoanAccruedtodateAmount}    ${ComSeeDataSet}
    
    Navigate to Share Accrual Cycle    &{ExcelPath}[Host_Bank]
    
    ${LoanCycleDueAmount}    Get Cycle Due Amount
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_cycleDue    ${rowid}    ${LoanCycleDueAmount}    ${ComSeeDataSet}
    
    ${LoanPaidDueAmount}   Get PaidToDate   
    Write Data To Excel    ComSee_SC2_Loan   Outstanding_paidToDate    ${rowid}    ${LoanPaidDueAmount}    ${ComSeeDataSet}
    
 
Write Loan Outstanding Accrual Non Zero Cycle
    [Documentation]    This test case writes the updated Loan Outstanding details after EOD for comsee use.
    ...    @author:    sacuisia    29SEPT2020    -InitialCreate
    [Arguments]    ${ExcelPath}
    
    Launch Loan Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Outstanding_Alias]
    
    ##Acrued Amount after EOD
    ${LoanAccruedtodateAmount}    Get Loan Accrued to Date Amount
    ${LoanAccruedtodateAmount}    Remove Comma and Convert to Number    ${LoanAccruedtodateAmount}
    ${TotalRowCount}    Get Accrual Row Count    ${LIQ_Loan_Window}    ${LIQ_Loan_AccrualTab_Cycles_Table}
    ${AccruedtoDateAmt}    Compute Total Accruals for Fee    ${TotalRowCount}    ${LIQ_Loan_Tab}    ${LIQ_Loan_AccrualTab_Cycles_Table}
    ${AccruedtoDateAmt}    Remove Comma and Convert to Number    ${AccruedtoDateAmt}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_AccruedInterest    ${rowid}    ${LoanAccruedtodateAmount}    ${ComSeeDataSet}
    
    
    ##Validate Cycle Due paidToDate after EOD
    Navigate to Share Accrual Cycle    &{ExcelPath}[Host_Bank]
    
    ${LoanCycleDueAmount}    Get Cycle Due Amount
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_cycleDue    ${rowid}    ${LoanCycleDueAmount}    ${ComSeeDataSet}
    
    ${LoanPaidDueAmount}   Get PaidToDate   
    Write Data To Excel    ComSee_SC2_Loan   Outstanding_paidToDate    ${rowid}    ${LoanPaidDueAmount}    ${ComSeeDataSet}
    
   
    
Write Loan Details for ComSee - Scenario 2
    [Documentation]    This test case writes the Outstanding(Loan) details for comsee use.
    ...    @author: rtarayao    05SEP2019    - Initial create
    [Arguments]    ${ExcelPath}
    ###LIQ login
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Outstanding Navigation###
    Launch Loan Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Outstanding_Alias]
    
    ###Get and Write General Tab Details for Comsee##
    ${LoanRiskType}    Get Loan Risk Type 
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_RiskType    ${rowid}    ${LoanRiskType}    ${ComSeeDataSet}
    
    ${LoanCCY}    Get Loan Currency
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_Currency    ${rowid}    ${LoanCCY}    ${ComSeeDataSet}
    
    ${LoanEffectiveDate}    ${LoanMaturityDate}    Get Loan Effective and Maturity Expiry Dates
    ${RepricngFrequency}    ${RepricingDate}    Get Loan Repricing Frequency and Date
    ${LoanEffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${LoanEffectiveDate}
    ${LoanMaturityDate}    Convert LIQ Date to Year-Month-Day Format    ${LoanMaturityDate}
    ${RepricingDate}    Convert LIQ Date to Year-Month-Day Format    ${RepricingDate}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_EffectiveDate    ${rowid}    ${LoanEffectiveDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_MaturityExpiryDate    ${rowid}    ${LoanMaturityDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_RepricingFrequency    ${rowid}    ${RepricngFrequency}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_RepricingDate    ${rowid}    ${RepricingDate}    ${ComSeeDataSet}
    
    ${HBGrossAmount}    ${HBNetAmount}    Get Loan Host Bank Net and Gross Amount
    ${HBGrossAmount}    Remove Comma and Convert to Number    ${HBGrossAmount}
    ${HBNetAmount}    Remove Comma and Convert to Number    ${HBNetAmount}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_HBGrossAmount    ${rowid}    ${HBGrossAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_HBNetAmount    ${rowid}    ${HBNetAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_HBNetFacCCYAmount    ${rowid}    ${HBNetAmount}    ${ComSeeDataSet}
    
    ${GlobalOriginalAmount}    ${GlobalCurrentAmount}    Get Loan Global Original and Current Amount
    ${GlobalOriginalAmount}    Remove Comma and Convert to Number    ${GlobalOriginalAmount}
    ${GlobalCurrentAmount}    Remove Comma and Convert to Number    ${GlobalCurrentAmount}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_GlobalOriginalAmount    ${rowid}    ${GlobalOriginalAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_GlobalCurrentAmount    ${rowid}    ${GlobalCurrentAmount}    ${ComSeeDataSet}
     
    ${PaymentMode}    ${IntCycleFrequency}    Get Loan Payment Mode and Interest Frequency Cycle
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_PaymentMode    ${rowid}    ${PaymentMode}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_IntCycleFrequency    ${rowid}    ${IntCycleFrequency}    ${ComSeeDataSet}
    
    ###Get and Write Rates Tab Details for Comsee##
    ${SpreadRate}    ${AllInRate}    Get Loan Spread and All In Rates
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_Margin    ${rowid}    ${SpreadRate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_AllInRate    ${rowid}    ${AllInRate}    ${ComSeeDataSet}
    
    
    ###Get and Write Accrual Tab Details for Comsee
    ${LoanAccruedtodateAmount}    Get Loan Accrued to Date Amount
    ${LoanAccruedtodateAmount}    Remove Comma and Convert to Number    ${LoanAccruedtodateAmount}
    ${TotalRowCount}    Get Accrual Row Count    ${LIQ_Loan_Window}    ${LIQ_Loan_AccrualTab_Cycles_Table}
    ${AccruedtoDateAmt}    Compute Total Accruals for Fee    ${TotalRowCount}    ${LIQ_Loan_Tab}    ${LIQ_Loan_AccrualTab_Cycles_Table}
    ${AccruedtoDateAmt}    Remove Comma and Convert to Number    ${AccruedtoDateAmt}
    Validate Accrued to Date Amount    ${AccruedtoDateAmt}    ${LoanAccruedtodateAmount}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_AccruedInterest    ${rowid}    ${LoanAccruedtodateAmount}    ${ComSeeDataSet}

    ###Get and Write Accrual Tab Details for Comsee
    ${PricingOptionCode}    Get Loan Pricing Option Code
    ${LoanPricingDescription}    Get Pricing Option Description from Table Maintenance    ${PricingOptionCode}
    ${LoanPricingOption}    Get Pricing Code and Description Combined    ${PricingOptionCode}    ${LoanPricingDescription}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_PricingOption    ${rowid}    ${LoanPricingOption}    ${ComSeeDataSet}
    Close All Windows on LIQ
    
    ###Logout from LIQ
    Logout from Loan IQ


Write Repriced Loan Details for ComSee - Scenario 2
    [Documentation]    This test case writes the Repriced Outstanding(Loan) details for comsee use.
    ...    @author: jloretiz    10JAN2020    - Initial create
    [Arguments]    ${ExcelPath}
    ###LIQ login
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ${New_OutstandingAlias}    Read Data From Excel    ComSee_SC2_LoanRepricing    NewOutstanding_Alias    ${rowid}    ${ComSeeDataSet}    
    ###Outstanding Navigation###
    Launch Loan Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    ${New_OutstandingAlias}
    
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_Alias    ${rowid}    &{ExcelPath}[Outstanding_Alias],${New_OutstandingAlias}    ${ComSeeDataSet}

    ###Get and Write General Tab Details for Comsee##
    ${LoanRiskType}    Get Loan Risk Type 
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_RiskType    ${rowid}    &{ExcelPath}[Outstanding_RiskType],${LoanRiskType}    ${ComSeeDataSet}
    
    ${LoanCCY}    Get Loan Currency
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_Currency    ${rowid}    &{ExcelPath}[Outstanding_Currency],${LoanCCY}    ${ComSeeDataSet}
    
    ${LoanEffectiveDate}    ${LoanMaturityDate}    Get Loan Effective and Maturity Expiry Dates
    ${RepricngFrequency}    ${RepricingDate}    Get Loan Repricing Frequency and Date
    ${LoanEffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${LoanEffectiveDate}
    ${LoanMaturityDate}    Convert LIQ Date to Year-Month-Day Format    ${LoanMaturityDate}
    ${RepricingDate}    Convert LIQ Date to Year-Month-Day Format    ${RepricingDate}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_EffectiveDate    ${rowid}    &{ExcelPath}[Outstanding_EffectiveDate],${LoanEffectiveDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_MaturityExpiryDate    ${rowid}    &{ExcelPath}[Outstanding_MaturityExpiryDate],${LoanMaturityDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_RepricingFrequency    ${rowid}    &{ExcelPath}[Outstanding_RepricingFrequency],${RepricngFrequency}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_RepricingDate    ${rowid}    &{ExcelPath}[Outstanding_RepricingDate],${RepricingDate}    ${ComSeeDataSet}
    
    ${HBGrossAmount}    ${HBNetAmount}    Get Loan Host Bank Net and Gross Amount
    ${HBGrossAmount}    Remove Comma and Convert to Number    ${HBGrossAmount}
    ${HBNetAmount}    Remove Comma and Convert to Number    ${HBNetAmount}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_HBGrossAmount    ${rowid}    &{ExcelPath}[Outstanding_HBGrossAmount],${HBGrossAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_HBNetAmount    ${rowid}    &{ExcelPath}[Outstanding_HBNetAmount],${HBNetAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_HBNetFacCCYAmount    ${rowid}    &{ExcelPath}[Outstanding_HBNetFacCCYAmount],${HBNetAmount}    ${ComSeeDataSet}
    
    ${GlobalOriginalAmount}    ${GlobalCurrentAmount}    Get Loan Global Original and Current Amount
    ${GlobalOriginalAmount}    Remove Comma and Convert to Number    ${GlobalOriginalAmount}
    ${GlobalCurrentAmount}    Remove Comma and Convert to Number    ${GlobalCurrentAmount}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_GlobalOriginalAmount    ${rowid}    &{ExcelPath}[Outstanding_GlobalOriginalAmount],${GlobalOriginalAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_GlobalCurrentAmount    ${rowid}    &{ExcelPath}[Outstanding_GlobalCurrentAmount],${GlobalCurrentAmount}    ${ComSeeDataSet}
     
    ${PaymentMode}    ${IntCycleFrequency}    Get Loan Payment Mode and Interest Frequency Cycle
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_PaymentMode    ${rowid}    &{ExcelPath}[Outstanding_PaymentMode],${PaymentMode}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_IntCycleFrequency    ${rowid}    &{ExcelPath}[Outstanding_IntCycleFrequency],${IntCycleFrequency}    ${ComSeeDataSet}
    
    ###Get and Write Rates Tab Details for Comsee##
    ${SpreadRate}    ${AllInRate}    Get Loan Spread and All In Rates
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_Margin    ${rowid}    &{ExcelPath}[Outstanding_Margin],${SpreadRate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_AllInRate    ${rowid}    &{ExcelPath}[Outstanding_AllInRate],${AllInRate}    ${ComSeeDataSet}
    
    
    ###Get and Write Accrual Tab Details for Comsee
    ${LoanAccruedtodateAmount}    Get Loan Accrued to Date Amount
    ${LoanAccruedtodateAmount}    Remove Comma and Convert to Number    ${LoanAccruedtodateAmount}
    ${TotalRowCount}    Get Accrual Row Count    ${LIQ_Loan_Window}    ${LIQ_Loan_AccrualTab_Cycles_Table}
    ${AccruedtoDateAmt}    Compute Total Accruals for Fee    ${TotalRowCount}    ${LIQ_Loan_Tab}    ${LIQ_Loan_AccrualTab_Cycles_Table}
    ${AccruedtoDateAmt}    Remove Comma and Convert to Number    ${AccruedtoDateAmt}
    # Validate Accrued to Date Amount    ${AccruedtoDateAmt}    ${LoanAccruedtodateAmount}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_AccruedInterest    ${rowid}    &{ExcelPath}[Outstanding_AccruedInterest],${LoanAccruedtodateAmount}    ${ComSeeDataSet}

    ###Get and Write Accrual Tab Details for Comsee
    ${PricingOptionCode}    Get Loan Pricing Option Code
    ${LoanPricingDescription}    Get Pricing Option Description from Table Maintenance    ${PricingOptionCode}
    ${LoanPricingOption}    Get Pricing Code and Description Combined    ${PricingOptionCode}    ${LoanPricingDescription}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_PricingOption    ${rowid}    &{ExcelPath}[Outstanding_PricingOption],${LoanPricingOption}    ${ComSeeDataSet}
    Close All Windows on LIQ
    
    ###Logout from LIQ
    Logout from Loan IQ
    
Create Initial Loan Drawdown with no Repayment Schedule - Scenario 7 ComSee
    [Documentation]    This keyword is used to create a Loan Drawdown without selecting a Payment Schedule.
    ...    @author: rtarayao    11SEP2019    - Duplicate of Scenario 7 from Functional Scenarios
    ...    @update: clanding    03NOV2020    - Added argument for Currency; Updated hard coded value CB001 to input dataset
    [Arguments]    ${ExcelPath}
    
    ###Facility###
    ${SystemDate}    Get System Date
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    ${AvailToDrawAmount}    Get Facility Global Available to Draw Amount
    ${GlobalOutstandings}    Get Facility Global Outstandings
    Write Data To Excel    ComSee_SC7_Loan   Facility_CurrentAvailToDraw    ${rowid}    ${AvailToDrawAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan   Facility_CurrentGlobalOutstandings    ${rowid}    ${GlobalOutstandings}    ${ComSeeDataSet}
    
    ##Outstanding Select Window###
    Navigate to Outstanding Select Window
    ${Loan_Alias}    Input Initial Loan Drawdown Details    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_Currency]
    Write Data To Excel    ComSee_SC7_Loan   Loan_Alias    ${rowid}    ${Loan_Alias}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_Alias    ${rowid}    ${Loan_Alias}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_LoanInterestPayment   Loan_Alias    ${rowid}    ${Loan_Alias}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_PrincipalLoanPayment   Loan_Alias    ${rowid}    ${Loan_Alias}    ${ComSeeDataSet}
        
    ###Initial Loan Drawdown###
    Validate Initial Loan Dradown Details    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Loan_Currency]
    ${AdjustedDueDate}    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    ${SystemDate}    &{ExcelPath}[Loan_MaturityDate]    None    &{ExcelPath}[Loan_IntCycleFrequency]    &{ExcelPath}[Loan_Accrue]
    Write Data To Excel    ComSee_SC7_LoanInterestPayment    ScheduledActivityReport_Date    ${rowid}    ${AdjustedDueDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_PrincipalLoanPayment    ActualAmount    ${rowid}    &{ExcelPath}[Loan_RequestedAmount]    ${ComSeeDataSet}
    Input Loan Drawdown Rates    &{ExcelPath}[Borrower_BaseRate]    &{ExcelPath}[Facility_Spread]
    
    ###Cashflow Notebook - Create Cashflows###
    Navigate to Drawdown Cashflow Window
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]  
     
    ##Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow    &{ExcelPath}[Loan_Currency]
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[HostBankSharePct]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Debit Amt
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower1_ShortName]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For: &{ExcelPath}[Facility_BranchCode]     Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For: &{ExcelPath}[Facility_BranchCode]     Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    &{ExcelPath}[Loan_RequestedAmount]

    ###Approval of Loan###
    Send Initial Drawdown to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Initial Drawdown     ${Loan_Alias}
    Approve Initial Drawdown
    
    ###Rate Setting###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Send to Rate Approval    Loan Initial Drawdown     ${Loan_Alias}
    Send Initial Drawdown to Rate Approval
        
    ###Rate Approval###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Rate Approval    Loan Initial Drawdown     ${Loan_Alias}
    Approve Initial Drawdown Rate
    
    ###Cashflow Notebook - Release Cashflows###
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_Drawdown_WorkflowItems}    Release Cashflows
    # Release Cashflow    &{ExcelPath}[Borrower1_ShortName]
    Release Loan Drawdown
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
Write Loan Details for ComSee - Scenario 7
    [Documentation]    This test case writes the Outstanding(Loan) details for comsee use.
    ...    @author: rtarayao    05SEP2019    - Initial create
    [Arguments]    ${ExcelPath}
    ###LIQ login
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Outstanding Navigation###
    Launch Loan Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Outstanding_Alias]
    
    ###Get and Write General Tab Details for Comsee##
    ${LoanRiskType}    Get Loan Risk Type 
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_RiskType    ${rowid}    ${LoanRiskType}    ${ComSeeDataSet}
    
    ${LoanCCY}    Get Loan Currency
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_Currency    ${rowid}    ${LoanCCY}    ${ComSeeDataSet}
    
    ${LoanEffectiveDate}    ${LoanMaturityDate}    Get Loan Effective and Maturity Expiry Dates
    ${LoanEffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${LoanEffectiveDate}
    ${LoanMaturityDate}    Convert LIQ Date to Year-Month-Day Format    ${LoanMaturityDate}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_EffectiveDate    ${rowid}    ${LoanEffectiveDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_MaturityExpiryDate    ${rowid}    ${LoanMaturityDate}    ${ComSeeDataSet}
    
    ${HBGrossAmount}    ${HBNetAmount}    Get Loan Host Bank Net and Gross Amount
    ${HBGrossAmount}    Remove Comma and Convert to Number    ${HBGrossAmount}
    ${HBNetAmount}    Remove Comma and Convert to Number    ${HBNetAmount}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_HBGrossAmount    ${rowid}    ${HBGrossAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_HBNetAmount    ${rowid}    ${HBNetAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_HBNetFacCCYAmount    ${rowid}    ${HBNetAmount}    ${ComSeeDataSet}
    
    ${GlobalOriginalAmount}    ${GlobalCurrentAmount}    Get Loan Global Original and Current Amount
    ${GlobalOriginalAmount}    Remove Comma and Convert to Number    ${GlobalOriginalAmount}
    ${GlobalCurrentAmount}    Remove Comma and Convert to Number    ${GlobalCurrentAmount}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_GlobalOriginalAmount    ${rowid}    ${GlobalOriginalAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_GlobalCurrentAmount    ${rowid}    ${GlobalCurrentAmount}    ${ComSeeDataSet}
     
    ${PaymentMode}    ${IntCycleFrequency}    Get Loan Payment Mode and Interest Frequency Cycle
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_PaymentMode    ${rowid}    ${PaymentMode}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_IntCycleFrequency    ${rowid}    ${IntCycleFrequency}    ${ComSeeDataSet}
    
    ###Get and Write Rates Tab Details for Comsee##
    ${SpreadRate}    ${AllInRate}    Get Loan Spread and All In Rates
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_Margin    ${rowid}    ${SpreadRate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_AllInRate    ${rowid}    ${AllInRate}    ${ComSeeDataSet}
    
    
    ###Get and Write Accrual Tab Details for Comsee
    ${LoanAccruedtodateAmount}    Get Loan Accrued to Date Amount
    ${LoanAccruedtodateAmount}    Remove Comma and Convert to Number    ${LoanAccruedtodateAmount}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_AccruedInterest    ${rowid}    ${LoanAccruedtodateAmount}    ${ComSeeDataSet}
    
    ${LoanCycleDueAmount}    Get Loan Cycle Due Amount
    ${LoanCycleDueAmount}    Remove Comma and Convert to Number    ${LoanCycleDueAmount}
    Write Data To Excel    ComSee_SC7_Loan   Outstanding_cycleDue    ${rowid}    ${LoanCycleDueAmount}    ${ComSeeDataSet}

    ${LoanPaidDueAmount}   Get Loan Paid to Date Amount
    ${LoanPaidDueAmount}    Remove Comma and Convert to Number    ${LoanPaidDueAmount}
    Write Data To Excel    ComSee_SC7_Loan   Outstanding_paidToDate    ${rowid}    ${LoanPaidDueAmount}    ${ComSeeDataSet}

    ###Get and Write Accrual Tab Details for Comsee
    ${PricingOptionCode}    Get Loan Pricing Option Code
    ${LoanPricingDescription}    Get Pricing Option Description from Table Maintenance    ${PricingOptionCode}
    ${LoanPricingOption}    Get Pricing Code and Description Combined    ${PricingOptionCode}    ${LoanPricingDescription}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_PricingOption    ${rowid}    ${LoanPricingOption}    ${ComSeeDataSet}
    Close All Windows on LIQ
    
Create Initial Loan Drawdown with Repricing - Scenario 7 ComSee
    [Documentation]    This keyword is used to create a Loan Drawdown without selecting a Payment Schedule.
    ...    @author: rtarayao    11SEP2019    - Duplicate of Scenario 7 from Functional Scenarios
    [Arguments]    ${ExcelPath}
    
    ###Facility###
    ${SystemDate}    Get System Date
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    ${AvailToDrawAmount}    Get Facility Global Available to Draw Amount
    ${GlobalOutstandings}    Get Facility Global Outstandings
    Write Data To Excel    ComSee_SC7_Loan   Facility_CurrentAvailToDraw    ${rowid}    ${AvailToDrawAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan   Facility_CurrentGlobalOutstandings    ${rowid}    ${GlobalOutstandings}    ${ComSeeDataSet}
    
    ##Outstanding Select Window###
    Navigate to Outstanding Select Window
    ${Loan_Alias}    Input Initial Loan Drawdown Details    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_Currency]
    Write Data To Excel    ComSee_SC7_Loan   Loan_Alias    ${rowid}    ${Loan_Alias}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_Alias    ${rowid}    ${Loan_Alias}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_LoanInterestPayment   Loan_Alias    ${rowid}    ${Loan_Alias}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_PrincipalLoanPayment   Loan_Alias    ${rowid}    ${Loan_Alias}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_LoanRepricing    Outstanding_Alias    ${rowid}    ${Loan_Alias}    ${ComSeeDataSet}
        
    ###Initial Loan Drawdown###
    Validate Initial Loan Dradown Details    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Loan_Currency]
    ${AdjustedDueDate}    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    ${SystemDate}    &{ExcelPath}[Loan_MaturityDate]    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_IntCycleFrequency]    &{ExcelPath}[Loan_Accrue]
    Write Data To Excel    ComSee_SC7_LoanInterestPayment    ScheduledActivityReport_Date    ${rowid}    ${AdjustedDueDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_PrincipalLoanPayment    ActualAmount    ${rowid}    &{ExcelPath}[Loan_RequestedAmount]    ${ComSeeDataSet}
    Input Loan Drawdown Rates    &{ExcelPath}[Borrower_BaseRate]    &{ExcelPath}[Facility_Spread]
    
    ###Cashflow Notebook - Create Cashflows###
    Navigate to Drawdown Cashflow Window
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]  
 
    ##Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[HostBankSharePct]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Debit Amt
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower1_ShortName]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001     Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001     Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    &{ExcelPath}[Loan_RequestedAmount]

    ###Approval of Loan###
    Send Initial Drawdown to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Initial Drawdown     ${Loan_Alias}
    Approve Initial Drawdown
    
    ###Rate Setting###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Send to Rate Approval    Loan Initial Drawdown     ${Loan_Alias}
    Send Initial Drawdown to Rate Approval
        
    ###Rate Approval###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Rate Approval    Loan Initial Drawdown     ${Loan_Alias}
    Approve Initial Drawdown Rate
    
    ###Cashflow Notebook - Release Cashflows###
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_Drawdown_WorkflowItems}    Release Cashflows
    Release Loan Drawdown
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
Write Loan Details for ComSee with Repricing - Scenario 7
    [Documentation]    This test case writes the Outstanding(Loan) details for comsee use.
    ...    @author: rtarayao    05SEP2019    - Initial create
    [Arguments]    ${ExcelPath}
    ###LIQ login
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Outstanding Navigation###
    Launch Loan Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Outstanding_Alias]
    
    ###Get and Write General Tab Details for Comsee##
    ${LoanRiskType}    Get Loan Risk Type 
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_RiskType    ${rowid}    ${LoanRiskType}    ${ComSeeDataSet}
    
    ${LoanCCY}    Get Loan Currency
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_Currency    ${rowid}    ${LoanCCY}    ${ComSeeDataSet}
    
    ${LoanEffectiveDate}    ${LoanMaturityDate}    Get Loan Effective and Maturity Expiry Dates
    ${LoanEffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${LoanEffectiveDate}
    ${LoanMaturityDate}    Convert LIQ Date to Year-Month-Day Format    ${LoanMaturityDate}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_EffectiveDate    ${rowid}    ${LoanEffectiveDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_MaturityExpiryDate    ${rowid}    ${LoanMaturityDate}    ${ComSeeDataSet}
    
    ${RepricngFrequency}    ${RepricingDate}    Get Loan Repricing Frequency and Date
    ${RepricingDate}    Convert LIQ Date to Year-Month-Day Format    ${RepricingDate}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_RepricingFrequency    ${rowid}    ${RepricngFrequency}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_RepricingDate    ${rowid}    ${RepricingDate}    ${ComSeeDataSet}
    
    ${HBGrossAmount}    ${HBNetAmount}    Get Loan Host Bank Net and Gross Amount
    ${HBGrossAmount}    Remove Comma and Convert to Number    ${HBGrossAmount}
    ${HBNetAmount}    Remove Comma and Convert to Number    ${HBNetAmount}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_HBGrossAmount    ${rowid}    ${HBGrossAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_HBNetAmount    ${rowid}    ${HBNetAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_HBNetFacCCYAmount    ${rowid}    ${HBNetAmount}    ${ComSeeDataSet}
    
    ${GlobalOriginalAmount}    ${GlobalCurrentAmount}    Get Loan Global Original and Current Amount
    ${GlobalOriginalAmount}    Remove Comma and Convert to Number    ${GlobalOriginalAmount}
    ${GlobalCurrentAmount}    Remove Comma and Convert to Number    ${GlobalCurrentAmount}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_GlobalOriginalAmount    ${rowid}    ${GlobalOriginalAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_GlobalCurrentAmount    ${rowid}    ${GlobalCurrentAmount}    ${ComSeeDataSet}
     
    ${PaymentMode}    ${IntCycleFrequency}    Get Loan Payment Mode and Interest Frequency Cycle
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_PaymentMode    ${rowid}    ${PaymentMode}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_IntCycleFrequency    ${rowid}    ${IntCycleFrequency}    ${ComSeeDataSet}
    
    ###Get and Write Rates Tab Details for Comsee##
    ${SpreadRate}    ${AllInRate}    Get Loan Spread and All In Rates
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_Margin    ${rowid}    ${SpreadRate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_AllInRate    ${rowid}    ${AllInRate}    ${ComSeeDataSet}
    
    
    ###Get and Write Accrual Tab Details for Comsee
    ${LoanAccruedtodateAmount}    Get Loan Accrued to Date Amount
    ${LoanAccruedtodateAmount}    Remove Comma and Convert to Number    ${LoanAccruedtodateAmount}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_AccruedInterest    ${rowid}    ${LoanAccruedtodateAmount}    ${ComSeeDataSet}
    
    ${LoanCycleDueAmount}    Get Loan Cycle Due Amount
    ${LoanCycleDueAmount}    Remove Comma and Convert to Number    ${LoanCycleDueAmount}
    Write Data To Excel    ComSee_SC7_Loan   Outstanding_cycleDue    ${rowid}    ${LoanCycleDueAmount}    ${ComSeeDataSet}

    ${LoanPaidDueAmount}   Get Loan Paid to Date Amount
    ${LoanPaidDueAmount}    Remove Comma and Convert to Number    ${LoanPaidDueAmount}
    Write Data To Excel    ComSee_SC7_Loan   Outstanding_paidToDate    ${rowid}    ${LoanPaidDueAmount}    ${ComSeeDataSet}

    ###Get and Write Accrual Tab Details for Comsee
    ${PricingOptionCode}    Get Loan Pricing Option Code
    ${LoanPricingDescription}    Get Pricing Option Description from Table Maintenance    ${PricingOptionCode}
    ${LoanPricingOption}    Get Pricing Code and Description Combined    ${PricingOptionCode}    ${LoanPricingDescription}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_PricingOption    ${rowid}    ${LoanPricingOption}    ${ComSeeDataSet}
    Close All Windows on LIQ
    
Create Loan Repricing for ComSee - Scenario 7
    [Documentation]    This will serve as a High Level keyword for the creation of Comprehensive Loan Repricing.
    ...    @author: cfrancis    18OCT2020    - Initial Create
    [Arguments]    ${ExcelPath}
    
    ###Deal Notebook###
    ${Facility_Spread}    Read Data From Excel    ComSee_SC7_LoanRepricing    Interest_SpreadValue    1    ${ComSeeDataSet}
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]
    Select Loan to Reprice    &{ExcelPath}[Outstanding_Alias]
    Select Repricing Type    Comprehensive Repricing
    Select Loan Repricing for Deal    &{ExcelPath}[Outstanding_Alias]

    ###Select Outstanding to Reprice###
    Select Existing Outstandings for Loan Repricing    &{ExcelPath}[Outstanding_PricingOption]    &{ExcelPath}[Outstanding_Alias]
    Cick Add in Loan Repricing Notebook

    ###Input Repricing Details###
    Set Repricing Detail Add Options    Rollover/Conversion to New    &{ExcelPath}[Outstanding_PricingOption]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_ShortName]
    ${Effective_Date}    ${Loan_Alias}    Set RolloverConversion Notebook General Details    &{ExcelPath}[Rollover_RequestedAmount]    &{ExcelPath}[Rollover_RepricingFrequency]
    Write Data To Excel    ComSee_SC7_LoanRepricing    NewOutstanding_Alias    ${rowid}    ${Loan_Alias}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_LoanRepricing    Rollover_EffectiveDate    ${rowid}    ${Effective_Date}    ${ComSeeDataSet}
    Save Notebook Transaction    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_Save_Menu}

    ###Input Base and Spread Rates###
    Set RolloverConversion Notebook Rates    &{ExcelPath}[Rollover_BaseRate]
    Close RolloverConversion Notebook

    ###Validate New Oustanding Details###
    ${New_Outstanding}    Set Variable    &{ExcelPath}[Outstanding_PricingOption] (${Loan_Alias})
    Validate Loan Repricing Effective Date    ${Effective_Date}
    Validate Loan Repricing New Outstanding Amount    ${New_Outstanding}    ${Loan_Alias}    &{ExcelPath}[Rollover_RequestedAmount]

    ###Create Cashflow###
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Create Cashflows
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Send to Approval

    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Generate Rate Setting Notices    Loan Repricing    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Approval
    
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Send to Rate Approval
    
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Generate Rate Setting Notices    Loan Repricing    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Rate Approval
    Release Loan Repricing
    
    Close All Windows on LIQ
    Logout from Loan IQ
    
Write Repriced Loan Details for ComSee - Scenario 7
    [Documentation]    This test case writes the Repriced Outstanding(Loan) details for comsee use.
    ...    @author: cfrancis    19OCT2020    - Initial create
    [Arguments]    ${ExcelPath}
    
    ${New_OutstandingAlias}    Read Data From Excel    ComSee_SC7_LoanRepricing    NewOutstanding_Alias    ${rowid}    ${ComSeeDataSet}
    
    ###Outstanding Navigation###
    Launch Loan Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    ${New_OutstandingAlias}
    
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_Alias    ${rowid}    &{ExcelPath}[Outstanding_Alias],${New_OutstandingAlias}    ${ComSeeDataSet}

    ###Get and Write General Tab Details for Comsee##
    ${LoanRiskType}    Get Loan Risk Type 
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_RiskType    ${rowid}    &{ExcelPath}[Outstanding_RiskType],${LoanRiskType}    ${ComSeeDataSet}
    
    ${LoanCCY}    Get Loan Currency
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_Currency    ${rowid}    &{ExcelPath}[Outstanding_Currency],${LoanCCY}    ${ComSeeDataSet}
    
    ${LoanEffectiveDate}    ${LoanMaturityDate}    Get Loan Effective and Maturity Expiry Dates
    ${RepricngFrequency}    ${RepricingDate}    Get Loan Repricing Frequency and Date
    ${LoanEffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${LoanEffectiveDate}
    ${LoanMaturityDate}    Convert LIQ Date to Year-Month-Day Format    ${LoanMaturityDate}
    ${RepricingDate}    Convert LIQ Date to Year-Month-Day Format    ${RepricingDate}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_EffectiveDate    ${rowid}    &{ExcelPath}[Outstanding_EffectiveDate],${LoanEffectiveDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_MaturityExpiryDate    ${rowid}    &{ExcelPath}[Outstanding_MaturityExpiryDate],${LoanMaturityDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_RepricingFrequency    ${rowid}    &{ExcelPath}[Outstanding_RepricingFrequency],${RepricngFrequency}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_RepricingDate    ${rowid}    &{ExcelPath}[Outstanding_RepricingDate],${RepricingDate}    ${ComSeeDataSet}
    
    ${HBGrossAmount}    ${HBNetAmount}    Get Loan Host Bank Net and Gross Amount
    ${HBGrossAmount}    Remove Comma and Convert to Number    ${HBGrossAmount}
    ${HBNetAmount}    Remove Comma and Convert to Number    ${HBNetAmount}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_HBGrossAmount    ${rowid}    &{ExcelPath}[Outstanding_HBGrossAmount],${HBGrossAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_HBNetAmount    ${rowid}    &{ExcelPath}[Outstanding_HBNetAmount],${HBNetAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_HBNetFacCCYAmount    ${rowid}    &{ExcelPath}[Outstanding_HBNetFacCCYAmount],${HBNetAmount}    ${ComSeeDataSet}
    
    ${GlobalOriginalAmount}    ${GlobalCurrentAmount}    Get Loan Global Original and Current Amount
    ${GlobalOriginalAmount}    Remove Comma and Convert to Number    ${GlobalOriginalAmount}
    ${GlobalCurrentAmount}    Remove Comma and Convert to Number    ${GlobalCurrentAmount}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_GlobalOriginalAmount    ${rowid}    &{ExcelPath}[Outstanding_GlobalOriginalAmount],${GlobalOriginalAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_GlobalCurrentAmount    ${rowid}    &{ExcelPath}[Outstanding_GlobalCurrentAmount],${GlobalCurrentAmount}    ${ComSeeDataSet}
     
    ${PaymentMode}    ${IntCycleFrequency}    Get Loan Payment Mode and Interest Frequency Cycle
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_PaymentMode    ${rowid}    &{ExcelPath}[Outstanding_PaymentMode],${PaymentMode}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_IntCycleFrequency    ${rowid}    &{ExcelPath}[Outstanding_IntCycleFrequency],${IntCycleFrequency}    ${ComSeeDataSet}
    
    ###Get and Write Rates Tab Details for Comsee##
    ${SpreadRate}    ${AllInRate}    Get Loan Spread and All In Rates
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_Margin    ${rowid}    &{ExcelPath}[Outstanding_Margin],${SpreadRate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_AllInRate    ${rowid}    &{ExcelPath}[Outstanding_AllInRate],${AllInRate}    ${ComSeeDataSet}
    
    
    ###Get and Write Accrual Tab Details for Comsee
    ${LoanAccruedtodateAmount}    Get Loan Accrued to Date Amount
    ${LoanAccruedtodateAmount}    Remove Comma and Convert to Number    ${LoanAccruedtodateAmount}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_AccruedInterest    ${rowid}    &{ExcelPath}[Outstanding_AccruedInterest],${LoanAccruedtodateAmount}    ${ComSeeDataSet}
    
    ${LoanCycleDueAmount}    Get Loan Cycle Due Amount
    ${LoanCycleDueAmount}    Remove Comma and Convert to Number    ${LoanCycleDueAmount}
    Write Data To Excel    ComSee_SC7_Loan   Outstanding_cycleDue    ${rowid}    &{ExcelPath}[Outstanding_cycleDue],${LoanCycleDueAmount}    ${ComSeeDataSet}

    ${LoanPaidDueAmount}   Get Loan Paid to Date Amount
    ${LoanPaidDueAmount}    Remove Comma and Convert to Number    ${LoanPaidDueAmount}
    Write Data To Excel    ComSee_SC7_Loan   Outstanding_paidToDate    ${rowid}    &{ExcelPath}[Outstanding_paidToDate],${LoanPaidDueAmount}    ${ComSeeDataSet}

    ###Get and Write Accrual Tab Details for Comsee
    ${PricingOptionCode}    Get Loan Pricing Option Code
    ${LoanPricingDescription}    Get Pricing Option Description from Table Maintenance    ${PricingOptionCode}
    ${LoanPricingOption}    Get Pricing Code and Description Combined    ${PricingOptionCode}    ${LoanPricingDescription}
    Write Data To Excel    ComSee_SC7_Loan    Outstanding_PricingOption    ${rowid}    &{ExcelPath}[Outstanding_PricingOption],${LoanPricingOption}    ${ComSeeDataSet}
    Close All Windows on LIQ