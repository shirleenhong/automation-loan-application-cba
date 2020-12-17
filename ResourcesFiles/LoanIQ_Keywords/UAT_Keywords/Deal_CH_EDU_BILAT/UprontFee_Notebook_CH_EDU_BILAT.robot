*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Charge Upfront Fee for CH EDU Bilateral Deal
    [Documentation]    Initiate Upfront Fee Payment.
    ...    @author: dahijara    14DEC2020    - Initial create
    [Arguments]    ${ExcelPath}

    ### Read Excel Data ###
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]
    ${Borrower_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    &{ExcelPath}[rowid]

    ### Close all windows and Login as original user ###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Open the existing Closed Deal ###
    Search Existing Deal    ${Deal_Name}
    
    ### Upfront Fee Payment-General Tab ###
    Populate Upfront Fee Payment Notebook    &{Excelpath}[UpfrontFee_Amount]    &{Excelpath}[UpfrontFee_EffectiveDate]
    Populate Fee Details Window    &{ExcelPath}[Fee_Type]    &{ExcelPath}[UpfrontFeePayment_Comment]    
    
    ### Upfront Fee Payment Workflow Tab- Create Cashflow Item ###
    Navigate to Upfront Fee Payment Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Set All Items to None

    ### Intent Notice ###
    Navigate to Upfront Fee Payment Workflow and Proceed With Transaction    ${GENERATE_INTENT_NOTICES}
    Add Group Comment for Notices    &{Excelpath}[Notice_Subject]    &{Excelpath}[Notice_Comment]
    Exit Notice Window
 
    ### Upfront Fee Payment Workflow Tab- Send to Approval Item ###
    Send to Approval Upfront Fee Payment    
    
    ### Upfront Fee Payment Workflow Tab- Approval Item ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}   ${SUPERVISOR_PASSWORD}
    Navigate to Payment Notebook via WIP    ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${FEE_PAYMENT_FROM_BORROWER_TYPE}    ${Deal_Name}
    Approve Upfront Fee Payment
    
    ### Upfront Fee Payment Workflow Tab- Release Item ###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate to Payment Notebook via WIP    ${PAYMENTS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${FEE_PAYMENT_FROM_BORROWER_TYPE}    ${Deal_Name}
    Navigate to Upfront Fee Payment Workflow and Proceed With Transaction    ${RELEASE_STATUS}

    ### Close all windows and Login as original user ###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}