*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Manual GL Transaction for Fee Payment
    [Documentation]    This keyword will serve as the high-level integration for Manual GL Transaction for Fee Payment
    ...    @author: ritragel
    ...    @update: hstone     21JUL2020     - Removed Unnecessary Logout/Login of Inputter
    ...                                      - Replaced 'Navigate Notebook Workflow' with 'Navigate to Upfront Fee Payment Workflow and Proceed With Transaction'
    ...                                      - Added 'Save Manual GL Changes'
    ...    @update: dahijara    08OCT2020    - Updated hardcoded values with global variables
    ...                                      - Rewmoved duplicated action of releasing cashflow (Release Cashflow). Navigate to Upfront Fee Payment Workflow and Proceed With Transaction has realse cahsflow steps already.
    [Arguments]    ${ExcelPath}
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Verify if the Event Fee is not yet released###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Check if Admin Fee is Added
    Verify Admin Fee Status    &{ExcelPath}[Deal_Name]    &{ExcelPath}[AdminFee_Alias]    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Close All Windows on LIQ
    
    ###Navigate to Payment and Input Details for Payment###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Navigate to Upfront Fee Payment then Input Details    &{ExcelPath}[Fee_Amount]    &{ExcelPath}[Fee_Currency]
    Populate Fee Details Window    &{ExcelPath}[Fee_Type]    &{ExcelPath}[Fee_Comment]
    
    ###Cashflow Notebook - Create Cashflows###
    Navigate to Upfront Fee Payment Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RTGSRemittanceDescription]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]  
    
    ###Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Fee_Amount]    &{ExcelPath}[HostBankSharePct]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
    ###GL Entries###
    Navigate to GL Entries
    ${Credit}    Get GL Entries Amount    &{ExcelPath}[GL_Account_Credit]    ${CREDIT_AMT_LABEL}
    ${Debit}    Get GL Entries Amount    &{ExcelPath}[GL_Account_Debit]    ${DEBIT_AMT_LABEL}
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    ${CREDIT_AMT_LABEL}
    ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    ${DEBIT_AMT_LABEL}
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${Credit}
    Validate if Debit and Credit Amt is Balanced    ${Debit}    ${Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    &{ExcelPath}[Fee_Amount]
      
    ###Send Upfron Fee payment to Approval###
    Send to Approval Upfront Fee Payment
    
    ###Approve Upfront Fee Payment###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Work In Process Window###
    Select Item in Work in Process    ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${FEE_PAYMENT_FROM_BORROWER_TYPE}     &{ExcelPath}[Deal_Name]
    Approve Upfront Fee Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}

    Select Item in Work in Process    ${PAYMENTS_TRANSACTION}   ${AWAITING_RELEASE_STATUS}    ${FEE_PAYMENT_FROM_BORROWER_TYPE}     &{ExcelPath}[Deal_Name]
    Navigate to Upfront Fee Payment Workflow and Proceed With Transaction    ${RELEASE_CASHFLOWS_TYPE}
    Release Upfront Fee Payment
    
    ###Create Manual GL###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate to Manual GL    &{ExcelPath}[Deal_Name]
    New Manual GL Select
    ${SysDate}    Get System Date
    Enter Manual GL Details    &{ExcelPath}[Processing_Area]    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Branch_Code]    ${SysDate}
    Add Debit for Manual GL    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Debit_GL_ShortName]
    Add Credit for Manual GL    &{ExcelPath}[Credit_Fee_Amount]    &{ExcelPath}[Credit_GL_ShortName]    &{ExcelPath}[Expense_Code]
    Save Manual GL Changes
    
    ###Send to Approval###
    Send Manual GL to Approval
    
    ###Approve Manual GL###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Manual Transaction on Work in Process    ${MANUALTRANS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${MANUAL_GL_TRANSACTION}     &{ExcelPath}[Deal_Name]    
    Approve Manual GL

    ###Release Manual GL###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Manual Transaction on Work in Process    ${MANUALTRANS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${MANUAL_GL_TRANSACTION}     &{ExcelPath}[Deal_Name]
    Release Manual GL
    
    ###Validate Events and GL###
    Validate Events Tab for Manual GL
    ${Debit_GL_ShortName}    Read Data From Excel    MTAM01_ManualGL    Debit_GL_ShortName    ${rowid}
    Validate GL Entries    &{ExcelPath}[Credit_GL_ShortName]    &{ExcelPath}[Debit_GL_ShortName]    &{ExcelPath}[Debit_GL_ShortName]
    Close All Windows on LIQ
