*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Admin Fee Payment
    [Documentation]    This keyword makes an Admin/Agency Fee Payment.
    ...    @author: bernchua
    ...    @update: ritragel    21MAR2019    Updated to conform to our scripting standards
    [Arguments]    ${ExcelPath}
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Verify if the Event Fee is not yet released###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Check if Admin Fee is Added
    Verify Admin Fee Status    &{ExcelPath}[Deal_Name]    &{ExcelPath}[AdminFee_Alias]    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ${SysDate}    Get System Date
    ${FromDate}    Subtract Days to Date    ${SysDate}    90
    ${ThruDate}    Add Days to Date    ${SysDate}    15
    
 	Run Keyword If    "${SCENARIO}"=="2"    Write Data To Excel    SERV21_InterestPayments    ScheduledActivity_FromDate    ${rowid}    ${FromDate}
    Run Keyword If    "${SCENARIO}"=="2"    Write Data To Excel    SERV21_InterestPayments    ScheduledActivity_ThruDate    ${rowid}    ${ThruDate}  
    
    ###Opens the Deal's Scheduled Activity Report from WIP###
    Open Deal Scheduled Activity Report    &{ExcelPath}[Deal_Name]    ${FromDate}    ${ThruDate}
    
    ###Open the transaction in the Scheduled Activity Report###
    Open Transaction In Scheduled Activity Report    &{ExcelPath}[Deal_Name]    &{ExcelPath}[AdminFee_DueDate]    Adm Fee (Amort)
    
    ###Initiate the Admin Fee Payment by entering the required fields###
    ${AdminFeePayment_EffectiveDate}    Get System Date
    Write Data To Excel    SERV30_AdminFeePayment    AdminFeePayment_EffectiveDate    ${rowid}    ${AdminFeePayment_EffectiveDate}
    Create Admin Fee Payment    &{ExcelPath}[Deal_Name]    ${AdminFeePayment_EffectiveDate}    &{ExcelPath}[AdminFeePayment_Comment]
    
    ###Cashflows for the Admin Fee Payment###
    Navigate Notebook Workflow    ${LIQ_AdminFeePayment_Window}    ${LIQ_AdminFeePayment_Tab}    ${LIQ_AdminFeePayment_Workflow_Tree}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Create Cashflow    &{ExcelPath}[Borrower_ShortName]    release
    
    ##Generate Intent Notices for the Admin Fee Payment###
    Navigate Notebook Workflow    ${LIQ_AdminFeePayment_Window}    ${LIQ_AdminFeePayment_Tab}    ${LIQ_AdminFeePayment_Workflow_Tree}    Generate Intent Notices
    Generate Intent Notices    &{ExcelPath}[Customer_LegalName]

    Verify Customer Notice Method    &{ExcelPath}[Customer_LegalName]    &{ExcelPath}[Borrower_IntenNoticeContact]    &{ExcelPath}[IntentNoticeStatus]    ${INPUTTER_USERNAME}    Email    &{ExcelPath}[Borrower_ContactEmail]
    mx LoanIQ click    ${LIQ_NoticeGroup_Exit_Button}
    
    mx LoanIQ activate    ${LIQ_AdminFeePayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AdminFeePayment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AdminFeePayment_Workflow_Tree}    Create Cashflow%d
    
    ###Send Admin Fee Payment to Approval###
    Navigate Notebook Workflow    ${LIQ_AdminFeePayment_Window}    ${LIQ_AdminFeePayment_Tab}    ${LIQ_AdminFeePayment_Workflow_Tree}    Send to Approval
    Validate Window Title Status    Admin Fee Payment    Awaiting Approval
    
    ### Approve Admin Fee Payment###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Payments    Awaiting Approval    Amortizing Admin Fee Payment    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_AdminFeePayment_Window}    ${LIQ_AdminFeePayment_Tab}    ${LIQ_AdminFeePayment_Workflow_Tree}    Approval
    Validate Window Title Status    Admin Fee Payment    Awaiting Release
    
    ###Release cashflow###
    Navigate Notebook Workflow    ${LIQ_AdminFeePayment_Window}    ${LIQ_AdminFeePayment_Tab}    ${LIQ_AdminFeePayment_Workflow_Tree}    Release Cashflows
    Release Cashflow    &{ExcelPath}[Borrower_ShortName]    release
    
    ###Release Admin Fee Payment###
    Navigate Notebook Workflow    ${LIQ_AdminFeePayment_Window}    ${LIQ_AdminFeePayment_Tab}    ${LIQ_AdminFeePayment_Workflow_Tree}    Release
    Validate Window Title Status    Admin Fee Payment    Released
    
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

