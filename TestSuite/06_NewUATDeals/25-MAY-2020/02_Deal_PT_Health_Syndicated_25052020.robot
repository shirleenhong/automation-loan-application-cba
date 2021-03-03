*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    2

*** Test Cases ***
Get Dataset for PT Health Syndicated Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    PT_Health_SYND    UAT_Deal_Scenarios
    
Comprehensive Repricing with Principal Payment - $2,253,766,383.04
    Mx Execute Template With Multiple Data    Create Comprehensive Repricing for PT Health    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing