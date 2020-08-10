*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Payment For Ticking Fee
    [Documentation]    This high-level keyword is for making a Ticking Fee Payment.
    ...    @author: bernchua
    ...    @update: dahijara    22JUL2020    - Updated keyword for Ticking Fee workflow navigation.
    ...                                      - removed reading of LIQCustomer_LegalName. ${Customer_LegalName} is not used in the script. Updated Variable for 'Validate Ticking Fee In Deal Notebook's Events And Pending Tabs'
    [Arguments]    ${ExcelPath}     

    ${Current_Date}    Get System Date
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    ${TickingFee_Amount}    Get Ticking Fee Amount From Definition    
    Write Data To Excel    SYND04_TickingFeePayment    TickingFee_Amount    &{ExcelPath}[rowid]    ${TickingFee_Amount}
    ${TickingFeeAmount}    Remove string    ${TickingFee_Amount}    %
    Log    ${TickingFeeAmount}      
    ${ConvertedTickingFee_Amount}    Remove Comma and convert to Number     ${TickingFeeAmount} 
    Log    ${ConvertedTickingFee_Amount} 
    Create Ticking Fee Payment
    Validate Ticking Fee Details    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Deal_ClosingCmt]    ${TickingFee_Amount}    &{ExcelPath}[Borrower_ShortName]
    Set Ticking Fee General Tab Details    ${TickingFee_Amount}    ${Current_Date}    &{ExcelPath}[TickingFee_Comment]
    Save Ticking Fee 
    
    ###Cashflow Notebook - Create Cashflows###
    Navigate to Ticking Fee Workflow and Proceed With Transaction    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]
    
    ###Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    ${TickingFeeAmount}    100
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
       
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Debit Amt
    ${Borrower_Credit}    Get GL Entries Amount    Ticking Fee    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Debit Amt
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalCreditAmt}    ${TickingFee_Amount}
    
    Navigate to Ticking Fee Workflow and Proceed With Transaction    Send to Approval
    Validate Window Title Status    Ticking Fee    Awaiting Approval 
  
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    Navigate Transaction in WIP    Payments    Awaiting Approval    Ticking Fee Fee    &{ExcelPath}[Deal_Name]
    Navigate to Ticking Fee Workflow and Proceed With Transaction    Approval
    Validate Window Title Status    Ticking Fee    Awaiting Release
    
    Navigate to Ticking Fee Workflow and Proceed With Transaction    Release
    Validate Window Title Status    Ticking Fee    Released
    
    Validate Ticking Fee Events    ${ConvertedTickingFee_Amount}
    Validate Ticking Fee Notebook Pending Tab
    Validate Ticking Fee In Deal Notebook's Events And Pending Tabs    ${TickingFeeAmount}
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
