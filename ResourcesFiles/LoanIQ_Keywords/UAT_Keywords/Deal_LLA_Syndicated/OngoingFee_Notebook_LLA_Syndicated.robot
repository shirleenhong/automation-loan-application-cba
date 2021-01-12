*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${SCENARIO}

*** Keywords ***

Release Ongoing Fee for LLA Syndicated Deal
    [Documentation]    This keyword will release the existing ongoing fee in the created deal
    ...    @author: makcamps    12JAN2021    - Initial Create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]
    ${Facility_Name}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name    &{ExcelPath}[rowid]

    Navigate to Facility Notebook    ${Deal_Name}    ${Facility_Name}
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    ### Ongoing Fee Notebook ###
    Release Ongoing Fee

    Save Facility Notebook Transaction
    Close All Windows on LIQ