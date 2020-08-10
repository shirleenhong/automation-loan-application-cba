*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***


*** Keywords ***
Create Issuance Payment Cashflow
    [Documentation]    This keyword is used for SBLC Issuance/Guarantee payment.
    ...    @author: rtarayao
    [Arguments]    ${ExcelPath}
    
    ##Cashflow Notebook - Create Cashflows###
    Navigate Notebook Workflow    ${LIQ_Payment_Window}    ${LIQ_Payment_Tab}    ${LIQ_Payment_WorkflowItems}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]  
    
    ##Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Computed_ProjectedCycleDue]    &{ExcelPath}[HostBankSharePct]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower1_ShortName]    Debit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Credit}
    Validate if Debit and Credit Amt is Balanced    ${Borrower_Debit}    ${HostBank_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    &{ExcelPath}[Computed_ProjectedCycleDue]

Split Cashflow for Drawdown
    [Arguments]    ${ExcelPath}
      
    Navigate Split Cashflows for Drawdown 
    Populate Split Cashflow Details    &{ExcelPath}[Split_Method]    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[SplitPrincipal_Percent]
    #Set up DO IT status in Split Cashflow    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Split_Method]    &{ExcelPath}[Remittance_Status]
    #Validate GL Entries for Split Cashflow in Drawdown     &{ExcelPath}[HostBank_GLAccount]    &{ExcelPath}[BorrowerDDA_ShortName]    &{ExcelPath}[BorrowerRTGS_ShortName]    &{ExcelPath}[Loan_RequestedAmount]    
    
