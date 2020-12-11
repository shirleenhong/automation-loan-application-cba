*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***

Create Deal Borrower Initial Details in Quick Party Onboarding for New Life Bilateral Deal
    Mx Execute Template With Multiple Data    Create Deal Borrower Initial Details in Quick Party Onboarding for New Life Bilateral Deal    ${CBAUAT_ExcelPath}    ${rowid}   PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Search Customer and Complete Borrower Profile Creation with Default Values for New Life Bilateral Deal    ${CBAUAT_ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding

Establish Deal - CRED01
    Mx Execute Template With Multiple Data    Setup Deal for New Life BILAT    ${CBAUAT_ExcelPath}    ${rowid}    CRED01_DealSetup

Establish Facility - CRED01
    Mx Execute Template With Multiple Data    Create Facility for New Life BILAT    ${CBAUAT_ExcelPath}     ${rowid}    CRED02_FacilitySetup
	Mx Execute Template With Multiple Data    Setup Facility Ongoing Fee for New Life BILAT    ${CBAUAT_ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup

