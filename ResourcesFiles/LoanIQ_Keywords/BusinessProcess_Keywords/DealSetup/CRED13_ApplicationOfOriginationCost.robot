*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

***Keyword***

Application of Origination Cost
    [Documentation]    This keyword is used to peform Application of Origination Cost
    ...    @author : Archana
    [Arguments]    ${ExcelPath}
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Deal Notebook###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Upfront Fee Payment Notebook###
    ${Effective_date}    Get System Date
    Populate Upfront Fee Payment Notebook    &{ExcelPath}[UpfrontFee_Amount]    ${Effective_date}
    Populate Fee Details Window    &{ExcelPath}[Fee_Type]    &{ExcelPath}[UpfrontFeePayment_Comment]
    
    Navigate to GL Entries_Upfront Fee payment
    ${ReceivableAcct_DebitAmount}    Get GL Entries Amount    &{ExcelPath}[ShortName_ReceivableAcct]    Debit Amt
    ${FeesHeld_CreditAmount}    Get GL Entries Amount    &{ExcelPath}[ShortName_FeesHeld]    Credit Amt
    ${TotalDebit}    Get GL Entries Amount    Total For    Debit Amt
    ${TotalCredit}    Get GL Entries Amount    Total For    Credit Amt
    Close GL Entries_Upfront Fee payment Notebook
    
    ###Create Cashflows ###
    Navigate Notebook Workflow -Create Cashflow    
    Verify if Method has Remittance Instruction    &{ExcelPath}[Short_Name]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    ${CFTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Short_Name]
    Verify if Status is set to Do It    &{ExcelPath}[Short_Name]
    
    ###Sending the transaction to Approval###
    Send to Approval Upfront Fee Payment
     
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Transaction in Process###
    Navigate Transaction in WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Approval]    &{ExcelPath}[Payment_Type]    &{ExcelPath}[Deal_Name]    
    
    ###Upfront Fee Payment Notebook###
    Approve Upfront Fee Payment
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Release Transaction###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate to Pending Upfront Fee Payment Notebook
    Release Upfront Fee Payment
    
    ###Validation of Released Upfront Fee Payment Status###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Verification of Released Upfront Fee Payment Status
    
    ###Portfolio position Selection###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate to Portfolio Positions Notebook
    Select Portfolio Position    &{ExcelPath}[Portfolio_Position]
    Portfolio Settled Discount Change    ${Effective_date}    &{ExcelPath}[Adjustment_Amount]
    GLOffset Details    &{ExcelPath}[GL_ShortName]    &{ExcelPath}[AwaitingDispose]
 
    ###Send transaction for approval###
    Send to Approval Portfolio Selection Discount Change  

    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Transaction in Process###
    Navigate Transaction in WIP    &{ExcelPath}[PFDC_Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Approval]    &{ExcelPath}[PFDC_Payment_Type]    &{ExcelPath}[Deal_Name]    
    
    ###Portfolio Selection Discount Change Notebook###
    Approve Portfolio Selection Discount Change    
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Release Transaction###
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Pending Portfolio Selection Discount Change
    
    ###Portfolio Selection Discount Change Notebook###
    Release Portfolio Selection Discount Change
    Verification of Portfolio Selection Discount Change
    Close All Windows on LIQ 