*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for LBT BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    LBT_BILAT    UAT_Deal_Scenarios
    
Full Preprayment for LBT Bilateral Deal
    Mx Execute Template With Multiple Data    Collect Full Prepayment via Paper Clip for LBT Bilateral Deal - Outstanding Z    ${ExcelPath}    ${rowid}    SERV23_LoanPaperClip  
    Mx Execute Template With Multiple Data    Send Paperclip Intent Notice for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    Correspondence
    
Charge $800 Breakcost for Full Prepayment for LBT Bilateral Deal
    Mx Execute Template With Multiple Data    Break Cost for Full Prepayment for LBT Bilateral Deal - Outstanding Z    ${ExcelPath}    ${rowid}     SERV40_BreakFunding
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Send Event Fee Payment Notice without FFC Validation    ${ExcelPath}    ${rowid}    Correspondence