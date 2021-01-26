*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    5

*** Test Cases ***
Get Dataset for New Life BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    New_Life_BILAT    UAT_Deal_Scenarios

Rollover and Principle Repayment for New Life BILAT - $2,860,426.18 
    Mx Execute Template With Multiple Data    Rollover and Principle Repayment    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing

