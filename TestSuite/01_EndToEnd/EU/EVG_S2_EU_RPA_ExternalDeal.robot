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