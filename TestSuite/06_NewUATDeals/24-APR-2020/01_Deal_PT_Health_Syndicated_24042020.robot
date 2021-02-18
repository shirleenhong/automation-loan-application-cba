*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for PT Health Syndicated Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    PT_Health_SYND    UAT_Deal_Scenarios
    
Accrual Adjustment for Fee Period 24/01/2020 to 24/04/2020 (Period 2)
    Mx Execute Template With Multiple Data    Cycle Shares Adjustment for PT Health    ${ExcelPath}    ${rowid}    MTAM06_AccrualsAdjustment