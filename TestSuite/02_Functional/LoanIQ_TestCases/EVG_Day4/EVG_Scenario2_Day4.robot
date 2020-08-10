*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
#Test Teardown    Test Suite Tear Down

*** Variables ***
${rowid}    1
${SCENARIO}    2

*** Test Cases ***
Initiate Repayment Paper Clip with Three Lenders - SERV21
    [Tags]    08 initiate Repayment Paper Clip with Three Lenders - Interest and Principal (SERV21)
    Mx Execute Template With Multiple Data    Initiate Repayment Paper Clip with Three Lenders - Interest and Principal    ${ExcelPath}   ${rowid}    SERV21_InterestPayments 
    
Initiate Agency Fee Payment - SERV30
    [Tags]    10 User is able to initiate AGENCY FEE payment (SERV30)
    Mx Execute Template With Multiple Data    Admin Fee Payment    ${ExcelPath}    ${rowid}    SERV30_AdminFeePayment  
    
Create Recurring Fee Payment - SERV33
    [Tags]    11 User is able to initiate RECURRING FEE Payment - SERV33
    Mx Execute Template With Multiple Data    Setup Recurring Event Fee    ${ExcelPath}    ${rowid}    CRED10_EventFee
    Mx Execute Template With Multiple Data    Initiate Recurring Fee Payment    ${ExcelPath}    ${rowid}    SERV33_RecurringFee
    
Initiate Unscheduled Principal Payment - SERV20
    [Tags]    12 User is able to initiate UNSCHEDULED Principal Payment - SERV20 
    Mx Execute Template With Multiple Data    Initiate Unscheduled Principal Payment    ${Excelpath}    ${rowid}    SERV20_UnschedPrincipalPayments
    
Create Break Funding for Early Full Repayment - SERV40
    [Tags]    13 User is able to initiate BREAKFUNDING Early Full Repayment - SERV40
    Mx Execute Template With Multiple Data    Initiate Break Funding Early Full Repayment    ${ExcelPath}   ${rowid}    SERV40_BreakFunding

# Create SBLC Guarantee Issuance - SERV05
    # [Tags]    14 Create and Release of Standard Bank Letter of Credit - SERV05
    # Mx Execute Template With Multiple Data    SBLC Guarantee Issuance    ${ExcelPath}    ${rowid}    	SERV05_SBLCIssuance
    # Log to Console    Pause Execution - Run Daily EOD
    # Pause Execution

# Create Paperclip Transaction including SBLC and Facing Fee - SERV23
    # [Tags]    15 Create Paperclip Transaction including SBLC and Facing Fee - CRE01
    # Mx Execute Template With Multiple Data    Create Paperclip Transaction including SBLC and Facing Fee    ${ExcelPath}    ${rowid}    SERV23_PaperclipTransaction
