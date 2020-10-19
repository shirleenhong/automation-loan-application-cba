*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Manual Cashflow for Upfront Fee Payment
    [Documentation]    This automation script is for Manual Cashflow for Upfront Fee Payment.
    ...    @author: mgaling
    ...    @update: hstone     23JUL2020     - Fixed DataSet Column Variable Matching
    ...                                      - Removed Commented Codes
    ...                                      - Applied usage of 'Navigate Transaction in WIP' on WIP Navigation
    ...                                      - Added missing window navigations and confirmations
    ...                                      - Removed Extra Spaces
    ...    @update: dahijara    09OCT2020    - Updated hardcoded values with global variables.
    [Arguments]    ${ExcelPath}

    ##LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    ${Remittance_Description}    Get Deal Borrower Remittance Instruction Description     &{ExcelPath}[Deal_Borrower]    &{ExcelPath}[Remittance_Instruction]
    Close All Windows on LIQ
    
    ###Accounting and Control Window###
    Navigate to Manual Cashflow Select    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Deal_Borrower] 
    
    ###Manual Cashflow Window###
    Launch Incoming Manual Cashflow Notebook
    ${System_Date}    Get System Date
    Write Data To Excel    MTAM02_ManualCashflow    Effective_Date    ${rowid}    ${System_Date}
    ${Effective_Date}    Read Data From Excel    MTAM02_ManualCashflow    Effective_Date    ${rowid}
    Populate Incoming Manual Cashflow Notebook - General Tab    &{ExcelPath}[Branch_Code]    ${Effective_Date}    &{ExcelPath}[Currency]    &{ExcelPath}[UpfrontFee_Amount]
    ...    &{ExcelPath}[Description]    &{ExcelPath}[Proc_Area]    &{ExcelPath}[Deal_ExpenseCode]    &{ExcelPath}[Deal_Borrower]    &{ExcelPath}[Customer_ServicingGroup]    &{ExcelPath}[Branch_ServicingGroup]
    Add Credit Offset in Incoming Manual Cashflow Notebook    &{ExcelPath}[UpfrontFee_Amount]    &{ExcelPath}[GL_ShortName]
    Save and Validate Data in Incoming Manual Cashflow Notebook    &{ExcelPath}[UpfrontFee_Amount]    &{ExcelPath}[GL_ShortName]    &{ExcelPath}[Deal_ExpenseCode]
    Navigate to Cashflow in Incoming Manual Cashflow Notebook
    Verify if Method has Remittance Instruction    &{ExcelPath}[Deal_Borrower]    ${Remittance_Description}    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Deal_Borrower]
  
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[GL_Account_ShortName1]    ${DEBIT_AMT_LABEL}
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[GL_Account_ShortName2]    ${CREDIT_AMT_LABEL}
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001     ${CREDIT_AMT_LABEL}
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001     ${DEBIT_AMT_LABEL}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    &{ExcelPath}[UpfrontFee_Amount]

    ###Approval of Manual Cashflow###
    Send Incoming Manual Cashflow to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    Navigate Transaction in WIP    ${MANUALTRANS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${MANUAL_CASHFLOW_TRANSACTION}    &{ExcelPath}[Deal_Name]
    Approve Incoming Manual Cashflow to Approval
    Logout from Loan IQ
    
    ###Release of Manual Cashflow###
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP     ${MANUALTRANS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${MANUAL_CASHFLOW_TRANSACTION}    &{ExcelPath}[Deal_Name]
    Release Cashflows for Incoming Manual Cashflow    &{ExcelPath}[Deal_Borrower]
    Release Incoming Manual Cashflow
    Logout from Loan IQ
    
    ###Upfront Fee Payment (INPUTTER)###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD} 
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Upfront Fee Payment-General Tab###
    Populate Upfront Fee Payment Notebook    &{Excelpath}[UpfrontFee_Amount]
    Populate Fee Details Window    &{ExcelPath}[Fee_Type]    &{ExcelPath}[UpfrontFeePayment_Comment]
    
    ###Upfront Fee Payment Workflow Tab- Create Cashflow Item###
    Navigate to Payment Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Verify if Method has Remittance Instruction    &{ExcelPath}[Deal_Borrower]    ${Remittance_Description}    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Deal_Borrower]
    Click OK In Cashflows
    
    ###Upfront Fee Payment Workflow Tab- Send to Approval Item### 
    Send to Approval Upfront Fee Payment
    
    ###Upfront Fee Payment Workflow Tab- Approval Item (SUPERVISOR)###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${FEE_PAYMENT_FROM_BORROWER_TYPE}    &{ExcelPath}[Deal_Name]
    Approve Upfront Fee Payment

    ###Upfront Fee Payment Workflow Tab- Release Item (MANAGER)###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    ${PAYMENTS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${FEE_PAYMENT_FROM_BORROWER_TYPE}    &{ExcelPath}[Deal_Name]
    Release Upfront Fee Payment with Custom Instructions

    ###Upfront Fee Payment Workflow Tab- Validation (MANAGER)###
    Validate Upfront Fee Notebook - Events Tab
    Close All Windows on LIQ 
    
    ### <update> 14Dec18 - bernchua : Scenario 8 integration. Go back to original user
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
