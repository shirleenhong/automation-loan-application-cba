*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Facility Drawdown
    [Documentation]    This high-level keyword is used to make a loan drawdown on a facility.
    ...                @author: hstone    21AUG2019    Initial create
    ...                @update: mcastro   03SEP2020    Replaced incorrect argument variable for ${sLoan_RepricingFrequency} on Input General Loan Drawdown Details keyword; Updated screenshot path
    [Arguments]    ${ExcelPath}
     
    ${Portfolio_Name}    Read Data From Excel    CRED01_DealSetup    Primary_Portfolio    1    ${CBAUAT_ExcelPath}
    ${Portfolio_ExpenseCode}    Read Data From Excel    CRED01_DealSetup    Deal_ExpenseCode    1    ${CBAUAT_ExcelPath}
    ${HostBank_CustomerPortfolio}    Set Variable    CB001/${Portfolio_Name}/${Portfolio_ExpenseCode}
    ${HostBankLender_Share}    Read Data From Excel    CRED01_DealSetup    Primary_PctOfDeal    1    ${CBAUAT_ExcelPath}    
    ${Faciltiy_Spread}    Read Data From Excel    CRED08_FacilityFeeSetup    Interest_SpreadValue    &{ExcelPath}[Facility_RowID]    ${CBAUAT_ExcelPath} 
    ${Facility_Name}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name    &{ExcelPath}[Facility_RowID]    ${CBAUAT_ExcelPath}
    ${Pricing_Option}    Read Data From Excel    CRED08_FacilityFeeSetup    Interest_OptionName    &{ExcelPath}[Facility_RowID]    ${CBAUAT_ExcelPath}    
    
    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    &{ExcelPath}[rowid]    ${Facility_Name}     ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV01_LoanDrawdown    Pricing_Option    &{ExcelPath}[rowid]    ${Pricing_Option}     ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV08C_ComprehensiveRepricing    Facility_Name    &{ExcelPath}[rowid]    ${Facility_Name}     ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV08C_ComprehensiveRepricing    Borrower_RemittanceDescription    &{ExcelPath}[rowid]    &{ExcelPath}[Remittance_Description]    ${CBAUAT_ExcelPath}
    
    Close All Windows on LIQ
    Refresh Tables in LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    Navigate to Outstanding Select Window from Deal
    ${Loan_Alias}    New Outstanding Select    &{ExcelPath}[Deal_Name]    ${Facility_Name}    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Outstanding_Type]    ${Pricing_Option}    &{ExcelPath}[Outstanding_Currency]
    Write Data To Excel    SERV01_LoanDrawdown    Loan_Alias    &{ExcelPath}[rowid]    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV08C_ComprehensiveRepricing    Loan_Alias    &{ExcelPath}[rowid]    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    ${Loan_Alias}    Read Data From Excel    SERV01_LoanDrawdown    Loan_Alias    &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CreateOutstandings_Outstanding Select  
    
    ${RepricingFrequency}    Set Variable    &{ExcelPath}[Loan_RepricingFrequency]
    ${RepricingDate}    Set Variable    &{ExcelPath}[Loan_RepricingDate]
    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_MaturityDate]
    ...    ${RepricingFrequency}    sRepricing_Date=${RepricingDate}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CreateOutstandings_Input General Loan Details    
    
    ### Outstanding Servicing Group Details Setup ###
    ${RepricingSingleCashflow}    Set Variable    &{ExcelPath}[Loan_RepricingSingleCashflow]
    Run Keyword If    '${RepricingSingleCashflow}'=='Y'    Set Outstanding Servicing Group Details    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Remittance_Instruction]  
    
    Navigate to Rates Tab
    Set Base Rate Details    &{ExcelPath}[Loan_BorrowerBaseRate]
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CreateOutstandings_Set Base Rate
    ${AllInRate}    Add Borrower Base Rate and Facility Spread    &{ExcelPath}[Loan_BorrowerBaseRate]    ${Faciltiy_Spread}
    ${AllInRate}    Set Variable    ${AllInRate}%
    Validate String Data In LIQ Object    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_AllInRateFromPricing_Text}    ${AllInRate}
    
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_Name]
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CreateOutstandings_Create Cashflows
    
    ### Get Transaction Amount for Cashflow
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_Name]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    ${HostBankLender_Share}
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
    
    ### GL Entries
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    ${HostBank_CustomerPortfolio}    Debit Amt
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower_Name]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    Debit Amt
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalCreditAmt}    &{ExcelPath}[Loan_RequestedAmount]
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CreateOutstandings_GL Entries
      
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Send to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Approval    Loan Initial Drawdown    ${Loan_Alias}
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Approval
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Send to Rate Approval
    Logout from Loan IQ
    
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Rate Approval    Loan Initial Drawdown    ${Loan_Alias}
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Rate Approval
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Release
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
