*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup Deal D00000454 Outstandings
    [Documentation]    This high-level keyword is used to setup the outstandings per Facility for Deal D00000454.
    ...                @author: fmamaril    28AUG2019    Initial create
    [Arguments]    ${ExcelPath}
    
    ${Portfolio_Name}    Read Data From Excel    CRED01_Primaries    Primary_Portfolio    1    ${CBAUAT_ExcelPath}
    ${Portfolio_ExpenseCode}    Read Data From Excel    CRED01_Primaries    Primary_RiskBook    1    ${CBAUAT_ExcelPath}
    ${HostBank_CustomerPortfolio}    Set Variable    CB001/${Portfolio_Name}/${Portfolio_ExpenseCode}
    
    Close All Windows on LIQ
    Refresh Tables in LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    Navigate to Outstanding Select Window from Deal
    ${Loan_Alias}    New Outstanding Select    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Outstanding_Currency]
    Write Data To Excel    SERV01_LoanDrawdown    Loan_Alias    &{ExcelPath}[rowid]    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    Run Keyword If    &{ExcelPath}[rowid] == 3    Run Keyword    Write Data To Excel    SERV23_Paperclip    Loan_Alias    2    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV08C_ComprehensiveRepricing    Loan_Alias    &{ExcelPath}[rowid]    ${Loan_Alias}    ${CBAUAT_ExcelPath}

    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_MaturityDate]    &{ExcelPath}[Loan_RepricingFrequency]
    
    Navigate to Rates Tab
    Set Base Rate Details    &{ExcelPath}[Loan_BorrowerBaseRate]
    Run Keyword If    '&{ExcelPath}[rowid]'=='4'    Run Keyword    Set Spread Details    &{ExcelPath}[Loan_OverrideSpread]
    ${AllInRate}    Add Borrower Base Rate and Facility Spread    &{ExcelPath}[Loan_BorrowerBaseRate]    &{ExcelPath}[Loan_FacilitySpread]
    ${AllInRate}    Set Variable    ${AllInRate}%
    Validate String Data In LIQ Object    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_AllInRate}    ${AllInRate}
    Set Outstanding Servicing Group Details    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Borrower_RemittanceInstruction]
    
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Borrower_RemittanceDescription]    &{ExcelPath}[Borrower_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender]    &{ExcelPath}[Lender_RemittanceDescription]    &{ExcelPath}[Lender_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_Name]
    Verify if Status is set to Do It    &{ExcelPath}[Lender]
    
    ### Get Transaction Amount for Cashflow
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_Name]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount with exact percentage    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[HostBank_LenderShare]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount with exact percentage    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Lender1_Share]
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}   
    
    ### GL Entries
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    ${HostBank_CustomerPortfolio}    Debit Amt
    ${Lender1_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender]    Debit Amt    
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower_Name]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    Debit Amt
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}    ${HostBank_Debit}|${Lender1_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}|${Lender1_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalCreditAmt}    &{ExcelPath}[Loan_RequestedAmount]
    
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
    
Setup Deal D00000454 Outstandings with Multiple Lenders
    [Documentation]    This high-level keyword is used to setup the outstandings per Facility for Deal D00000454 with multiple lenders.
    ...                @author: fmamaril    28AUG2019    Initial create
    [Arguments]    ${ExcelPath}
    
    ${Portfolio_Name}    Read Data From Excel    CRED01_Primaries    Primary_Portfolio    1    ${CBAUAT_ExcelPath}
    ${Portfolio_ExpenseCode}    Read Data From Excel    CRED01_Primaries    Primary_RiskBook    1    ${CBAUAT_ExcelPath}
    ${HostBank_CustomerPortfolio}    Set Variable    CB001/${Portfolio_Name}/${Portfolio_ExpenseCode}
    
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    Navigate to Outstanding Select Window from Deal
    ${Loan_Alias}    New Outstanding Select    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Outstanding_Currency]
    Write Data To Excel    SERV01_LoanDrawdown    Loan_Alias    &{ExcelPath}[rowid]    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV08C_ComprehensiveRepricing    Loan_Alias    &{ExcelPath}[rowid]    ${Loan_Alias}    ${CBAUAT_ExcelPath}    
    ### For Debugging Only ${Loan_Alias}    Read Data From Excel    SERV01_LoanDrawdown    Loan_Alias    &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}    
    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Loan_EffectiveDate]    None    &{ExcelPath}[Loan_RepricingFrequency]
    
    Navigate to Rates Tab
    Set Base Rate Details    &{ExcelPath}[Loan_BorrowerBaseRate]
    ${AllInRate}    Add Borrower Base Rate and Facility Spread    &{ExcelPath}[Loan_BorrowerBaseRate]    &{ExcelPath}[Loan_FacilitySpread]
    ${AllInRate}    Set Variable    ${AllInRate}%
    Validate String Data In LIQ Object    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_AllInRate}    ${AllInRate}
    Set Outstanding Servicing Group Details    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Borrower_RemittanceInstruction]
    Set Outstanding Servicing Group Details    &{ExcelPath}[Lender]    &{ExcelPath}[Lender_RemittanceInstruction]
    Set Outstanding Servicing Group Details    &{ExcelPath}[Lender2]    &{ExcelPath}[Lender2_RemittanceInstruction]
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Borrower_RemittanceDescription]    &{ExcelPath}[Borrower_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender]    &{ExcelPath}[Lender_RemittanceDescription]    &{ExcelPath}[Lender_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2]    &{ExcelPath}[Lender2_RemittanceDescription]    &{ExcelPath}[Lender2_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_Name]
    Verify if Status is set to Do It    &{ExcelPath}[Lender]
    Verify if Status is set to Do It    &{ExcelPath}[Lender2]
        
    ### Get Transaction Amount for Cashflow
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_Name]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender]
    ${Lend2TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender2]    
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount with exact percentage    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[HostBank_LenderShare]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount with exact percentage    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Lender1_Share]
    ${ComputedLend2TranAmount}    Compute Lender Share Transaction Amount with exact percentage    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Lender2_Share]
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}|${ComputedLend2TranAmount}  
    
    ### GL Entries
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    ${HostBank_CustomerPortfolio}    Debit Amt
    ${Lender1_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender]    Debit Amt    
    ${Lender2_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender2]    Debit Amt
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower_Name]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    Debit Amt
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalCreditAmt}    &{ExcelPath}[Loan_RequestedAmount]
    Close GL Entries and Cashflow Window
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
    
