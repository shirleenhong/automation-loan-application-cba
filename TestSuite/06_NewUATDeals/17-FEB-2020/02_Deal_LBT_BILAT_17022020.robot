*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for LBT BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    LBT_BILAT    UAT_Deal_Scenarios
	
Create Loan Drawdown for LBT Bilateral Deal 
    Set Test Variable    ${rowid}    6
    Mx Execute Template With Multiple Data    Create Loan Drawdown for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown 

Combine Drawdowns A+B&C&D, Partial repayment of $15.283M and rollover
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Combine Drawdown ABCD and Make Partial Repayment for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    SERV11_LoanMerge
      