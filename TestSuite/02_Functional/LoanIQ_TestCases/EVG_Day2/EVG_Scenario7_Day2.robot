*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    7 
*** Test Cases *** 
Initiate Ongoing Fee Payment - SERV29
    [Tags]    05 Initiate Ongoing Fee Payment - SERV29
    Mx Execute Template With Multiple Data    Pay Commitment Fee Amount    ${ExcelPath}    ${rowid}    SERV29_PaymentFees 
    
# Initiate Loan Interest Payment - SERV21
    # [Tags]    06 Initiate Loan Interest Payment - SERV21
    # Mx Execute Template With Multiple Data    Initiate Interest Payment    ${ExcelPath}    ${rowid}    SERV21_InterestPayments
    
Unscheduled Principal Payment - SERV18
    [Tags]    07 Unscheduled Principal Payment - SERV19
    Mx Execute Template With Multiple Data    Unscheduled Principal Payment - No Schedule    ${ExcelPath}    ${rowid}    SERV18_Payments
    
Terminate Facility - SERV35
    [Documentation]    This keyword is used to terminate a facility
    ...    There is a 1-day Batch EoD run inside the script
    [Tags]    08 Terminate Facility - AMCH02 
    Mx Execute Template With Multiple Data    Terminate Facility - Commitment Decrease    ${ExcelPath}    ${rowid}    SERV35_Terminate_FacilityDeal
    Log To Console    Test Execution has been Paused. Need to Run EoD Batch | 1 day      
