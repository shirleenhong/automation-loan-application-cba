*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    2 

*** Test Cases ***
Get Dataset for PT Health Syndicated Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    PT_Health_SYND    UAT_Deal_Scenarios

Collection of Line Fee Period 2 for PT Health Syndicated Deal 
    Mx Execute Template With Multiple Data    Pay Line Fee without Online Accrual for PT Health Syndicated Deal    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup