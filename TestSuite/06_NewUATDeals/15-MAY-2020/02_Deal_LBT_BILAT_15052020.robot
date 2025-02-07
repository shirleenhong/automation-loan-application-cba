*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for LBT BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    LBT_BILAT    UAT_Deal_Scenarios

Combine ABCDEF & G, Partial Repayment $357.540M and Rollover
    Set Test Variable    ${rowid}    5
    Mx Execute Template With Multiple Data    Combine Drawdown ABCDEFG and Make Partial Repayment for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    SERV11_LoanMerge
    
Update Commitment Fee Expiry Date then Perform Online Accrual
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Change Commitment Fee Expiry Date for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
   
Update As of Accrual Date in Facility then Perform Online Accrual
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Update As of Accrual Date in Facility for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    CRED01_FacilitySetup
    
Create Ongoing Fee Payment then Perform Online Accrual
    Set Test Variable    ${rowid}    3
    Mx Execute Template With Multiple Data    Create New Ongoing Fee for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    
Charge monthly commitment fee (3/4/2020 - 15/5/2020)
	Set Test Variable    ${rowid}    2
	Mx Execute Template With Multiple Data    Charge Monthly Commitment Fee for LBT Bilateral Deal (3/4/2020 to 15/5/2020)    ${ExcelPath}    ${rowid}    SERV21_FeePayment
    