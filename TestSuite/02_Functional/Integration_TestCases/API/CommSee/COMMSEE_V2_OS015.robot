*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    7

*** Test Case ***
    
Reprice Loan and Get Outstanding Details
    [Documentation]   This CommSee test case Reverses the Payment for Advanced Interest
    ...    pre-requisite test case is COMMSEE_V2_OS013 andCOMMSEE_V2_OS014
    ...    run EOD to loan repricing date
    ...    @ author: cfrancis    18OCT2020    - Initial Create

    # Mx Execute Template With Multiple Data    Create Loan Repricing for ComSee - Scenario 7    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_LoanRepricing
    Mx Execute Template With Multiple Data    Write Loan Details for ComSee - Scenario 7    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Loan
    Mx Execute Template With Multiple Data    Write Repriced Loan Details for ComSee - Scenario 7    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Loan
    Mx Execute Template With Multiple Data    Get and Validate API Outstanding Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_Loan