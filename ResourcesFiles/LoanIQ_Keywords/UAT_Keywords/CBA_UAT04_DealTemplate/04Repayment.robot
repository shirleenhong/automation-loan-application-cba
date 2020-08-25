*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Create Full Repayment for Loans in Deal D00000963
    [Documentation]    High-level keyword used to create an Full Loan Prepayments for Loans in Deal D00000963
    ...                @author: bernchua    18SEP2019    Initial create
    [Arguments]    ${ExcelPath}
    
    ${Portfolio_Name}    Read Data From Excel    CRED01_DealSetup    Primary_Portfolio    1    ${CBAUAT_ExcelPath}
    ${Portfolio_ExpenseCode}    Read Data From Excel    CRED01_DealSetup    Deal_ExpenseCode    1    ${CBAUAT_ExcelPath}
    ${HostBank_CustomerPortfolio}    Set Variable    CB001/${Portfolio_Name}/${Portfolio_ExpenseCode}
    ${HostBankLender_Share}    Read Data From Excel    CRED01_DealSetup    Primary_PctOfDeal    1    ${CBAUAT_ExcelPath}
    
    Refresh Tables in LIQ
    
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    Loan    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    Set Notebook to Update Mode    ${LIQ_Loan_Window}    ${LIQ_Loan_InquiryMode_Button}
    
    Navigate to Principal Payment
    Populate Principal Payment General Tab    &{ExcelPath}[FullRepayment_PrincipalAmount]    &{ExcelPath}[FullRepayment_EffectiveDate]    &{ExcelPath}[FullRepayment_Reason]
    Tick Principal Payment Prepayment Checkbox    
    
    Navigate Notebook Workflow    ${LIQ_PrincipalPayment_Window}    ${LIQ_PrincipalPayment_Tab}    ${LIQ_PrincipalPayment_WorkflowTree}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[FullRepayment_PrincipalAmount]    AUD
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[FullRepayment_PrincipalAmount]
    
    ### Get Transaction Amount for Cashflow
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_Name]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[FullRepayment_PrincipalAmount]    ${HostBankLender_Share}
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
    
    ### GL Entries
    Navigate to GL Entries
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower_Name]    Debit Amt
    ${HostBank_Credit}    Get GL Entries Amount    ${HostBank_CustomerPortfolio}    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    Debit Amt
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Credit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Credit}    ${Borrower_Debit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalCreditAmt}    &{ExcelPath}[FullRepayment_PrincipalAmount]    
    
    Navigate Notebook Workflow    ${LIQ_PrincipalPayment_Window}    ${LIQ_PrincipalPayment_Tab}    ${LIQ_PrincipalPayment_WorkflowTree}    Send to Approval        
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Payments    Awaiting Approval    Loan Principal Prepayment    &{ExcelPath}[Loan_Alias]
    Navigate Notebook Workflow    ${LIQ_PrincipalPayment_Window}    ${LIQ_PrincipalPayment_Tab}    ${LIQ_PrincipalPayment_WorkflowTree}    Approval
    
    Navigate Notebook Workflow    ${LIQ_PrincipalPayment_Window}    ${LIQ_PrincipalPayment_Tab}    ${LIQ_PrincipalPayment_WorkflowTree}    Release Cashflows 
    Cashflows Mark All To Release
    Click OK In Cashflows
    
    Navigate Notebook Workflow    ${LIQ_PrincipalPayment_Window}    ${LIQ_PrincipalPayment_Tab}    ${LIQ_PrincipalPayment_WorkflowTree}    Release
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    
