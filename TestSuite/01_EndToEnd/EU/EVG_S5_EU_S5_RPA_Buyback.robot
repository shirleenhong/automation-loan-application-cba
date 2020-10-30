*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    5

*** Test Cases ***
Deal Setup - CRED01
    [Tags]    01 Deal Setup - CRED01
    Mx Execute Template With Multiple Data    Setup RPA Internal Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Setup Deal Upfront Fees    ${ExcelPath}    ${rowid}    CRED07_UpfrontFeeSetup
    Mx Execute Template With Multiple Data    Create Facility for RPA Deal    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Ongoing Fee Setup     ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    
Primary Allocation - SYND02
    [Tags]    02 Primary Allocation - SYND02
    Mx Execute Template With Multiple Data    Setup Primary for RPA Deal    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
    Mx Execute Template With Multiple Data    RPA Deal Approval and Close    ${ExcelPath}    ${rowid}    SYND02_PrimaryAllocation
