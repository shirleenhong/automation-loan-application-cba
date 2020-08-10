*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
#Test Teardown    Test Suite Tear Down

*** Variables ***
${rowid}    1
${SCENARIO}    3

*** Test Cases ***
#___Start of Day 2    
# Run EOD
    # [Documentation]    Need to Run EOD here
    # Log    Execution was paused. Need to run EoD
    # Pause Execution    

SBLC Fee on Lender - CRE10       
    [Tags]    05 SBLC Fee on Lender - CRE10
    Mx Execute Template With Multiple Data    Initiate Fee On Lender Shares Payment    ${ExcelPath}    ${rowid}    SERV18_FeeOnLenderSharesPayment
    
Create Cashflow  
    [Tags]    06 Create Cashflow
    Mx Execute Template With Multiple Data    Create Issuance Payment Cashflow    ${ExcelPath}    ${rowid}    SERV24_CreateCashflow

Fee on Lender Payment
    [Tags]    07 Fee on Lender Shares
    Mx Execute Template With Multiple Data    Workflow Navigation For Fee On Lender Shares Payment     ${ExcelPath}    ${rowid}    SERV18_FeeOnLenderSharesPayment 

Cycle Share Adjustment Setup - MTAM05A
    [Tags]    08 SBLC Fee on Lender - CRE10
    Mx Execute Template With Multiple Data    Create Cycle Share Adjustment    ${ExcelPath}    ${rowid}    MTAM05A_CycleShareAdjustment  

Set Up SBLC Decrease - SERV05
    [Tags]    09 SBLC Decrease
    Mx Execute Template With Multiple Data    Set Up SLBC Decrease    ${ExcelPath}    ${rowid}    SERV05_SBLCDecrease

# ___End of Day 2
