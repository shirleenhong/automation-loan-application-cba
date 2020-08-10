*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    1

*** Test Cases ***
Deal Setup - CRED01
    [Tags]    01 Deal Setup - CRED01
    Mx Execute Template With Multiple Data    Setup RPA Internal Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup

Upfront Fee Setup - CRED07
    [Tags]    02 Upfront Fee Setup - CRED07
    Mx Execute Template With Multiple Data    Setup Deal Upfront Fees    ${ExcelPath}    ${rowid}    CRED07_UpfrontFeeSetup

Create Facility - CRED02
    [Tags]    03 Create Facility - CRED02
    Mx Execute Template With Multiple Data    Create Facility for RPA Deal    ${ExcelPath}    1    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Ongoing Fee Setup     ${ExcelPath}    1    CRED08_OngoingFeeSetup
    Set Test Variable    ${rowid}    2    
    Mx Execute Template With Multiple Data    Create Facility for RPA Deal    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Ongoing Fee Setup     ${ExcelPath}    2    CRED08_OngoingFeeSetup
    Set Test Variable    ${rowid}    3
    Mx Execute Template With Multiple Data    Create Facility for RPA Deal    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Ongoing Fee Setup     ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    
Primary Allocation - SYND02
    [Tags]    04 Primary Allocation - SYND02
    Set Test Variable    ${rowid}    1
    Mx Execute Template With Multiple Data    Setup Initial Primary Details    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Set Facility Sell Amounts    ${ExcelPath}    1-3    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Add Contact in Primaries    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Setup Circle Notebook Allocation    ${ExcelPath}    1-3    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Complete Circle Notebook Portfolio    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Approve and Close Deal with Single Primary Lender    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation      