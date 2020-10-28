*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    2

*** Test Cases ***
Deal Setup and Facilities - CRED01
    [Tags]    01 Deal Setup and Facilities - CRED01
    Mx Execute Template With Multiple Data    Setup RPA Internal Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Setup Deal Upfront Fees    ${ExcelPath}    ${rowid}    CRED07_UpfrontFeeSetup
    Mx Execute Template With Multiple Data    Create Facility for RPA Deal    ${ExcelPath}    1    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Ongoing Fee Setup     ${ExcelPath}    1    CRED08_OngoingFeeSetup
    Set Test Variable    ${rowid}    2    
    Mx Execute Template With Multiple Data    Create Facility for RPA Deal    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Ongoing Fee Setup     ${ExcelPath}    2    CRED08_OngoingFeeSetup
    Set Test Variable    ${rowid}    3
    Mx Execute Template With Multiple Data    Create Facility for RPA Deal    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Ongoing Fee Setup     ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup

Complete Primaries - CRED01
    [Tags]  02  Complete Primaries - CRED01
    Set Test Variable    ${rowid}    1
    Mx Execute Template With Multiple Data    Setup Initial Primary Details    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Set Facility Sell Amounts    ${ExcelPath}    1-3    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Add Contact in Primaries    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Setup Circle Notebook Allocation    ${ExcelPath}    1-3    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    Complete Circle Notebook Portfolio    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation

# Close Deal - CRED01
#     [Tags]  Close Deal - CRED01
#     Mx Execute Template With Multiple Data    Approve and Close Deal with Single Primary Lender    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
