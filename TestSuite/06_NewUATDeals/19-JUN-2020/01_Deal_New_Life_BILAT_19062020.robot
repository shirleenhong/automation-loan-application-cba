*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    6

*** Test Cases ***
Get Dataset for New Life BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    New_Life_BILAT    UAT_Deal_Scenarios

Rollover and Auto Generate Interest Payment - $204,308,828.54 
    Mx Execute Template With Multiple Data    Rollover and Auto Generate Interest Payment    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing

Collect Commitment Fee - $52,102.83
    Set Test Variable    ${rowid}    12
    Mx Execute Template With Multiple Data    Collect Commitment Fee Payment For New Life BILAT    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment

Expire the Fee by Amending the Expiry Date to Start Date 14 May 20 (Create Negative Cycle Due)
    Set Test Variable    ${rowid}    13
    Mx Execute Template With Multiple Data    Change Commitment Fee Expiry Date    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment

Reverse the Payment and Send to SPAP
    Set Test Variable    ${rowid}    14
    Mx Execute Template With Multiple Data    Create Reversal Payment for New Life Bilat    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment

Create New Fee Notebook for Fee Period 14May20 to 16Jun20, Due Date 19Jun20
    Set Test Variable    ${rowid}    15
    Mx Execute Template With Multiple Data    Create New Fee for New Life Bilat    ${ExcelPath}    ${rowid}    SERV29_CommitmentFeePayment