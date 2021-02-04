*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for LBT BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    LBT_BILAT    UAT_Deal_Scenarios
	
Complete Cycle Shares Adjustment $5,589,974.67
    Mx Execute Template With Multiple Data    Complete Cycle Shares Adjustment for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    MTAM06_AccrualsAdjustment   
    
Charge annual commitment fee (3/4/2019 - 3/4/2020)
    Mx Execute Template With Multiple Data    Fee Payment for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    SERV21_FeePayment