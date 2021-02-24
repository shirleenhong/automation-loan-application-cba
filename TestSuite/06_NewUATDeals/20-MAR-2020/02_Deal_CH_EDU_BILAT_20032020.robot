*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for CH EDU Bilateral Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    CH_EDU_BILAT    UAT_Deal_Scenarios

# Refinance Revolver Facility for CH EDU Bilateral Deal
#     Mx Execute Template With Multiple Data    Add Increase Schedule via Facility Change Transaction for CH EDu Bilateral Deal    ${ExcelPath}    ${rowid}    AMCH05_FacilityChangeTrans
#     Set Test Variable    ${rowid}    2
#     Mx Execute Template With Multiple Data    Increase Commitment for Revolver Facility for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    AMCH05_FacilityChangeTrans
#     Set Test Variable    ${rowid}    1
#     Mx Execute Template With Multiple Data    Update Ongoing Fee and Interest Fee Pricing for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    AMCH06_PricingChangeTransaction

# Generate & Send Commitment Change (Increase) Notice
#     Set Test Variable    ${rowid}    9
#     Mx Execute Template With Multiple Data    Send Commitment Change Notice for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    Correspondence

# Rollover and Partial Repayment -$3.9M (NONE) [Net-Off with DEF(1)]
#     Set Test Variable    ${rowid}    6
#     Mx Execute Template With Multiple Data    Rollover Outstanding ABC with Partial Repayment for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    SERV11_LoanMerge

# Generate & Send Rate Setting Notice - Rollover with Facility Extension and Pricing Matrix Update
#     Set Test Variable    ${rowid}    12
#     Mx Execute Template With Multiple Data    Send Repricing Intent Notice for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    Correspondence

Generate & Send Rate Setting Notice - Rollover with Facility Extension and Pricing Matrix Update
    Set Test Variable    ${rowid}    13
    Mx Execute Template With Multiple Data    Send Repricing Rate Setting Notice for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    Correspondence