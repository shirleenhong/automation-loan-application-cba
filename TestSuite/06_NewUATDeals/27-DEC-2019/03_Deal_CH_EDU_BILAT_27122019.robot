*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Get Dataset for CH EDU Bilateral Deal
    Mx Execute Template With Specific Test Case Name    Get Correct Dataset From Dataset List    ${NEW_UAT_DEALS_ExcelPath}    UAT_Deal_Scenario_Name    CH_EDU_BILAT    UAT_Deal_Scenarios

Create Quick Party Onboarding for CH EDU Bilateral Deal - PTY001 
    Mx Execute Template With Multiple Data    Create Deal Borrower Initial Details in Quick Party Onboarding for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Search Customer and Complete Borrower Profile Creation with Default Values for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding

Establish Deal with LVR Effective 30/6/2019
    Mx Execute Template With Multiple Data    Setup Deal for CH EDU BILAT Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup

Establish Capitalisation Facility
    Mx Execute Template With Multiple Data    Create Capitalisation Facility for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup_A

Establish Commitment Fee
    Mx Execute Template With Multiple Data    Setup Commitment Fee for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup_A

Establish Cash Advance Facility
    Mx Execute Template With Multiple Data    Create Cash Advance Facility for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup_B

Establish Line Fee in Arrears
    Mx Execute Template With Multiple Data    Setup Line Fee in Arrears for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup_B

Setup Primaries and Close Deal
    Mx Execute Template With Multiple Data    Setup Primary for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Approve and Close CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Release Ongoing Fee for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup_A
    Mx Execute Template With Multiple Data    Release Ongoing Fee for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup_B

After Deal Close, Modify the Interest Matrix Application Method to Next Pepricing Date
    Mx Execute Template With Multiple Data    Update Pricing Rules via Deal Notebook for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    CRED01_DealPricingSetup

Charge Upfront Fee and Capitialise (Drawdown Back Date to 17/12/2019)
    Mx Execute Template With Multiple Data    Charge Upfront Fee for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    CRED07_UpfrontFee_Payment
    Mx Execute Template With Multiple Data    Send Upfront Fee Intent Notice for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    Correspondence
    Mx Execute Template With Multiple Data    Create Loan Drawdown for CH EDU Bilateral Deal - Outstanding Y    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown

Generate and Send Upfront Fee Payment Notice/Add comment About Upfront Fee Capitalisation
    Mx Execute Template With Multiple Data    Complete Upfront Fee Cashflow for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    CRED07_UpfrontFee_Payment
    Mx Execute Template With Multiple Data    Complete Portfolio Settled Discount for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    TRPO12_PortfolioSettledDisc

Drawdown and Back Date to 18/12/2019
    Set Test Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Create Loan Drawdown for CH EDU Bilateral Deal - Outstanding Z    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown

Generate and Send Drawdown Intent Notice
    Set Test Variable    ${rowid}    7
    Mx Execute Template With Multiple Data    Send a Drawdown Intent Notice for CH EDU Bilateral Deal    ${ExcelPath}    ${rowid}    Correspondence

Create Drawdown and Back Date to 4/12/2019
    Set Test Variable    ${rowid}    3
    Mx Execute Template With Multiple Data    Create Loan Drawdown for CH EDU Bilateral Deal - Outstanding A    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown

Create Drawdown and Back Date to 18/12/2019
    Set Test Variable    ${rowid}    4
    Mx Execute Template With Multiple Data    Create Loan Drawdown for CH EDU Bilateral Deal - Outstanding B    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown