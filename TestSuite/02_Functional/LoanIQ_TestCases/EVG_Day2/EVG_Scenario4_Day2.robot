*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
#Test Teardown    Test Suite Tear Down

*** Variables ***
${rowid}    1
${SCENARIO}    4

*** Test Cases ***
###___Start of Day 2
Create Comprehensive Repricing - SERV09C
    [Tags]    10 Loan Repricing - Other Bank is Agent
    Mx Execute Template With Multiple Data    Create Comprehensive Repricing for Non-Agent Syndicated Deal    ${ExcelPath}   ${rowid}    SERV09C_LoanRepricing
    
Create Interest Payment - SERV22
    [Documentation]    Need to Run Eod Here
    ...    Commenting this for now as discussed with Ice will do changes accordingly once feedback from Travis has been received
    [Tags]    11 Interest Payment - Other Bank is Agent
    Mx Execute Template With Multiple Data    Initiate Interest Payment for Agency Deal    ${ExcelPath}   ${rowid}    SERV22_InterestPayments
      
Perform Lender Share Adjustment - AMCH02
    [Documentation]    This keyword performs lender share adjustment to a deal
    [Tags]    12 Perform Lender Share Adjustment - AMCH02 
    Mx Execute Template With Multiple Data    Perform Lender Share Adjustment    ${ExcelPath}    ${rowid}    AMCH02_LenderShareAdjustment
    
Extend Facility Maturity Date - AMCH0
    [Tags]    13 Facility Change Transaction - Extend Maturity Exp Date
    Mx Execute Template With Multiple Data    Extend Maturity Date    ${ExcelPath}   ${rowid}    AMCH05_ExtendMaturityDate
