*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    2

*** Test Cases ***
Get Dataset for PIM Future BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    PIM_Future_BILAT    UAT_Deal_Scenarios

Combined rollover $2,229,484.90 from 31/03/2020 to 30/06/2020
    [Tags]  01 Combine Loans
    Mx Execute Template With Multiple Data    Combine All Loans and Capitalize Interest for PIM Future BILAT    ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing