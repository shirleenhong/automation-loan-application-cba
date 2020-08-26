*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Admin Fee Payment
    [Documentation]    This keyword makes an Admin/Agency Fee Payment.
    ...    @author: bernchua
    ...    @update: ritragel    21MAR2019    Updated to conform to our scripting standards
    ...    @update: dfajardo    25AUG2020    Removed hard coded values and updated scripts
    [Arguments]    ${ExcelPath}
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Verify if the Event Fee is not yet released###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Check if Admin Fee is Added
    Verify Admin Fee Status    &{ExcelPath}[Deal_Name]    &{ExcelPath}[AdminFee_Alias]    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ${SysDate}    Get System Date
    ${FromDate}    Subtract Days to Date    ${SysDate}    &{ExcelPath}[Subtract_Days]
    ${ThruDate}    Add Days to Date    ${SysDate}    &{ExcelPath}[Add_Days]
    
 	Run Keyword If    "${SCENARIO}"=="2"    Write Data To Excel    SERV21_InterestPayments    ScheduledActivity_FromDate    ${rowid}    ${FromDate}
    Run Keyword If    "${SCENARIO}"=="2"    Write Data To Excel    SERV21_InterestPayments    ScheduledActivity_ThruDate    ${rowid}    ${ThruDate}  
    
    ###Opens the Deal's Scheduled Activity Report from WIP###
    Open Deal Scheduled Activity Report    &{ExcelPath}[Deal_Name]    ${FromDate}    ${ThruDate}
    
    ###Open the transaction in the Scheduled Activity Report###
    Open Transaction In Scheduled Activity Report    &{ExcelPath}[Deal_Name]    &{ExcelPath}[AdminFee_DueDate]    ${ADMIN_FEE_AMORT}
    
    ###Initiate the Admin Fee Payment by entering the required fields###
    ${AdminFeePayment_EffectiveDate}    Get System Date
    Write Data To Excel    SERV30_AdminFeePayment    AdminFeePayment_EffectiveDate    ${rowid}    ${AdminFeePayment_EffectiveDate}
    Create Admin Fee Payment    &{ExcelPath}[Deal_Name]    ${AdminFeePayment_EffectiveDate}    &{ExcelPath}[AdminFeePayment_Comment]
    
    ### Create cashflows and verifying the remittance details
    Navigate Notebook Workflow for Admin Fee Payment    ${CREATE_CASHFLOWS_TYPE}
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_RTGSRemittanceDescription]    &{ExcelPath}[Borrower_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]
 
    ##Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]  
    
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Admin_FeeAmount]    &{ExcelPath}[HostBankSharePct] 

    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
    
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    ${DEBIT_AMT_LABEL}
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    ${CREDIT_AMT_LABEL}
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For:    ${CREDIT_AMT_LABEL}
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For:    ${DEBIT_AMT_LABEL}
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    &{ExcelPath}[Admin_FeeAmount]

 
    Close GL Entries and Cashflow Window
    
    ###Send Admin Fee Payment to Approval###
    Navigate Notebook Workflow    ${LIQ_AdminFeePayment_Window}    ${LIQ_AdminFeePayment_Tab}    ${LIQ_AdminFeePayment_Workflow_Tree}    ${SEND_TO_APPROVAL_STATUS}

      ### Approve Admin Fee Payment###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}    
    Navigate Transaction in WIP    ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${AMORTIZING_ADMIN_FEE_PAYMENT_TYPE}    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_AdminFeePayment_Window}    ${LIQ_AdminFeePayment_Tab}    ${LIQ_AdminFeePayment_Workflow_Tree}    ${APPROVAL_STATUS}
    
    ##Generate Intent Notices for the Admin Fee Payment###
    Navigate Notebook Workflow    ${LIQ_AdminFeePayment_Window}    ${LIQ_AdminFeePayment_Tab}    ${LIQ_AdminFeePayment_Workflow_Tree}    ${GENERATE_INTENT_NOTICES} 
    Generate Intent Notices    &{ExcelPath}[Customer_LegalName]

    Verify Customer Notice Method    &{ExcelPath}[Customer_LegalName]    &{ExcelPath}[Borrower_IntenNoticeContact]    &{ExcelPath}[IntentNoticeStatus]    &{ExcelPath}[User]     ${CBA_EMAIL_PDF_METHOD}    &{ExcelPath}[Borrower_ContactEmail]
    Close All Windows on LIQ


    ### Approve Admin Fee Payment###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    ${PAYMENTS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${AMORTIZING_ADMIN_FEE_PAYMENT_TYPE}    &{ExcelPath}[Deal_Name]
    
    ###Release cashflow###
    Navigate Notebook Workflow    ${LIQ_AdminFeePayment_Window}    ${LIQ_AdminFeePayment_Tab}    ${LIQ_AdminFeePayment_Workflow_Tree}    ${RELEASE_CASHFLOWS_TYPE}
    Release Cashflow    &{ExcelPath}[Borrower_ShortName]    ${RELEASE_STATUS}
    
    ###Release Admin Fee Payment###
    Navigate Notebook Workflow    ${LIQ_AdminFeePayment_Window}    ${LIQ_AdminFeePayment_Tab}    ${LIQ_AdminFeePayment_Workflow_Tree}    ${RELEASE_STATUS}
    
    ###Close all other LIQ windows except for the main LIQ window###
    Close All Windows on LIQ
    

Admin Fee Payment for Secondary Sale
    [Documentation]    This keyword makes an Admin/Agency Fee Payment.
    ...    @author: bernchua
    ...    @update: jdelacru    21MAR2019    - Applied coding standards
    ...    @update: sahalder    17JUN2020    - Moved to the new framework, edited steps as per BNS reqirement
    ...    @update: dahijara    06AUG2020    - Removed hardcoded value for UniqueTransactionIdentifier
    ...                                      - Removed "mx LoanIQ click element if present    ${LIQ_Cashflows_OK_Button}" in test case level. Addednavigation to GL entries and Close keyword for GL and Cashflow window.
    ...                                      - Replaced hard coded values with global variables.
    ...    @update: dahijara    07AUG2020    - Added 3 # for comments
    [Arguments]    ${ExcelPath}
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Opens the Deal's SScheduled Activity Report from WIP
    Open Deal Scheduled Activity Report    &{ExcelPath}[Deal_Name]    &{ExcelPath}[ScheduledActivityFilter_FromDate]    &{ExcelPath}[ScheduledActivityFilter_ThruDate]
    
    ### Open the transaction in the Scheduled Activity Report
    Open Transaction In Scheduled Activity Report    &{ExcelPath}[Deal_Name]    &{ExcelPath}[AdminFee_DueDate]    &{ExcelPath}[UniqueTransactionIdentifier]
    
    ### Initiate the Admin Fee Payment by entering the required fields
    ${AdminFeePayment_EffectiveDate}    Get System Date
    Write Data To Excel    SERV30_AdminFeePayment    AdminFeePayment_EffectiveDate    ${rowid}    ${AdminFeePayment_EffectiveDate}
    Create Admin Fee Payment    &{ExcelPath}[Deal_Name]    ${AdminFeePayment_EffectiveDate}    &{ExcelPath}[AdminFeePayment_Comment]

    ### Create cashflows and verifying the remittance details
    Navigate Notebook Workflow for Admin Fee Payment    ${CREATE_CASHFLOWS_TYPE}
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RemittanceDescription]    &{ExcelPath}[Borrower1_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]

    Navigate to GL Entries
    Close GL Entries and Cashflow Window

    ### Send Admin Fee Payment to Approval
    Navigate Notebook Workflow for Admin Fee Payment    ${SEND_TO_APPROVAL_STATUS}
    Validate Window Title Status    ${ADMIN_FEE_PAYMENT_TITLE}    ${AWAITING_APPROVAL_STATUS}
    
    ### Approve Admin Fee Payment
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${AMORTIZING_ADMIN_FEE_PAYMENT_TYPE}    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow for Admin Fee Payment    ${APPROVAL_STATUS}
    Validate Window Title Status    ${ADMIN_FEE_PAYMENT_TITLE}    ${AWAITING_RELEASE_STATUS}
    
    ### Release Admin Fee Payment
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Borrower1_RemittanceInstruction]    &{ExcelPath}[Borrower1_ShortName]    sNavigateToWorkflow=${PAYMENT_TRANSACTION}
    Navigate Notebook Workflow for Admin Fee Payment    ${RELEASE_STATUS}
        
    ### Close all other LIQ windows except for the main LIQ window.
    Close All Windows on LIQ

