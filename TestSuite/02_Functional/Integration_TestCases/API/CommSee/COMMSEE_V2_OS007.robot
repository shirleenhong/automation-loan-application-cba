*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    6

*** Test Cases ***

Loan Drawdown and Non Zero Cycle Due
    [Documentation]   This test case creates a Fixed Rate Loan Drawdown. With Single Line Accrual and Non Zero Cycle Due
    ...    Pre-requisite test case is COMMSEE_V2_OS001
    ...    @author: cfrancis    12OCT2020    - Initial Create
    
    Mx Execute Template With Multiple Data    Write Loan Details for ComSee - Scenario 7    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Loan
    Mx Execute Template With Multiple Data    Get and Validate API Outstanding Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Loan