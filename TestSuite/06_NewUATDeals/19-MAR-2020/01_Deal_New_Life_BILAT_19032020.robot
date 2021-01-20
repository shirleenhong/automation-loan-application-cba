*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    3

*** Test Cases ***
Get Dataset for New Life BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    New_Life_BILAT    UAT_Deal_Scenarios

Loan Combine and Rollover for New Life BILAT - $202,119,254.72
    Mx Execute Template With Multiple Data    Loan Combine and Rollover    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing
