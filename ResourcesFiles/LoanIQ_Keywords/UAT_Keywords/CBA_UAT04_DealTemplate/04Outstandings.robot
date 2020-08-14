*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Create Outstandings for Deal D00000963
    [Documentation]    High-level keyword for creating the Outstandings in Deal D00000963 
    ...                @author: bernchua    22AUG2019    Initial create
    ...                @author: bernchua    23AUG2019    Added taking of screenshots
    ...                @author: bernchua    28AUG2019    Added Write to Excel to Runbook sheet
    [Arguments]    ${ExcelPath}
    
    ${Portfolio_Name}    Read Data From Excel    CRED01_DealSetup    Primary_Portfolio    1    ${CBAUAT_ExcelPath}
    ${Portfolio_ExpenseCode}    Read Data From Excel    CRED01_DealSetup    Deal_ExpenseCode    1    ${CBAUAT_ExcelPath}
    ${HostBank_CustomerPortfolio}    Set Variable    CB001/${Portfolio_Name}/${Portfolio_ExpenseCode}
    ${HostBankLender_Share}    Read Data From Excel    CRED01_DealSetup    Primary_PctOfDeal    1    ${CBAUAT_ExcelPath}    
    ${Faciltiy_Spread}    Run Keyword If    '&{ExcelPath}[rowid]'=='1'    Read Data From Excel    CRED02_FacilitySetup    Interest_SpreadValue    1    ${CBAUAT_ExcelPath} 
    ...    ELSE    Read Data From Excel    CRED02_FacilitySetup    Interest_SpreadValue    2    ${CBAUAT_ExcelPath}
    
    Close All Windows on LIQ
    Refresh Tables in LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    Navigate to Outstanding Select Window from Deal
    ${Loan_Alias}    New Outstanding Select    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Outstanding_Currency]
    Write Data To Excel    SERV01_LoanDrawdown    Loan_Alias    &{ExcelPath}[rowid]    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]'=='1'    Write Data To Excel    UAT04_Runbook    Loan_Alias    1    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    ...    ELSE IF    '&{ExcelPath}[rowid]'=='2'    Write Data To Excel    UAT04_Runbook    Loan_Alias    5    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    ...    ELSE IF    '&{ExcelPath}[rowid]'=='3'    Write Data To Excel    UAT04_Runbook    Loan_Alias    8    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    ...    ELSE IF    '&{ExcelPath}[rowid]'=='4'    Write Data To Excel    UAT04_Runbook    Loan_Alias    10    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    
    ${Repricing_Frequency}    Set Variable    &{ExcelPath}[Loan_RepricingFrequency]
    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_MaturityDate]    Loan_RepricingFrequency=${Repricing_Frequency}
    
    Navigate to Rates Tab
    Set Base Rate Details    &{ExcelPath}[Loan_BorrowerBaseRate]
    ${AllInRate}    Add Borrower Base Rate and Facility Spread    &{ExcelPath}[Loan_BorrowerBaseRate]    ${Faciltiy_Spread}
    ${AllInRate}    Set Variable    ${AllInRate}%
    Take Screenshot    InitialDrawdown-Rates
    Validate String Data In LIQ Object    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_AllInRateFromPricing_Text}    ${AllInRate}
    
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_Name]
    
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
    
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Send to Approval
    
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Approval    Loan Initial Drawdown    ${Loan_Alias}
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Approval
    Take Screenshot    InitialDrawdown-Approved
    
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Send to Rate Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Rate Approval    Loan Initial Drawdown    ${Loan_Alias}
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Rate Approval
    Take Screenshot    InitialDrawdown-RateApproved
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Release
    Take Screenshot    InitialDrawdown-Released
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    

