*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for CH EDU Bilateral Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    CH_EDU_BILAT    UAT_Deal_Scenarios

Refinance Revolver Facility for CH EDU Bilateral Deal
    Mx Execute Template With Multiple Data    Add Increase Schedule via Facility Change Transaction for CH EDu Bilateral Deal    ${ExcelPath}    ${rowid}    AMCH05_FacilityChangeTrans
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Increase Commitment for Revolver Facility for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    AMCH05_FacilityChangeTrans
    Set Test Variable    ${rowid}    1
    Mx Execute Template With Multiple Data    Update Ongoing Fee and Interest Fee Pricing for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    AMCH06_PricingChangeTransaction