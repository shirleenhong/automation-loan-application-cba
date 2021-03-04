*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for LBT BILAT
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    LBT_BILAT    UAT_Deal_Scenarios
	
Create Reverse Payment with SPAP
    Set Test Variable    ${rowid}    3    
    Mx Execute Template With Multiple Data    Create Reversal Payment for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    SERV21_FeePayment 
    
Complete Cycle Shares Adjustment $5,589,974.67 after Reverse Payment
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Complete Cycle Shares Adjustment to Correct Annual Fee Notebook for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    MTAM06_AccrualsAdjustment 

Update Commitment Fee Expiry Date then Perform Online Accrual (4/3/2019)
    Set Test Variable    ${rowid}    4
    Mx Execute Template With Multiple Data    Change Commitment Fee Expiry Date for LBT Bilateral Deal (4/3/2019)   ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup 
    
Create New Ongoing Fee and Check Line Items for LBT Bilateral Deal
    Set Test Variable    ${rowid}    5
    Mx Execute Template With Multiple Data    Create New Ongoing Fee and Check Line Items for LBT Bilateral Deal    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup 
    
Update Commitment Fee Expiry Date for LBT Bilateral Deal (4/3/2020) 
    Set Test Variable    ${rowid}    6
    Mx Execute Template With Multiple Data    Change Commitment Fee Expiry Date for LBT Bilateral Deal (4/3/2020)   ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup 