*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for PDS Syndicate Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    PDS_SYND    UAT_Deal_Scenarios

Rollover Outstanding A1 - Repayment as Per Schedule
    Mx Execute Template With Multiple Data    Rollover Outstanding A1 for PDS Syndicate Deal    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing

Rollover Outstanding B1 - Repayment as Per Schedule
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Rollover Outstanding B1 for PDS Syndicate Deal    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing
