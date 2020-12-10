*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    4

*** Test Cases ***
Deal Setup for Expanded Scenario 1 - Payment Non Agency
    [Tags]    01 Deal Setup for Expanded Scenario 1 - Payment Non Agency
    Mx Execute Template With Multiple Data    Setup a Bilateral Deal for DNR    ${DNR_DATASET}    ${rowid}    SC1_DealSetup

    Set Global Variable    ${TestCase_Name}    Expanded_Scenario1_Payment_NonAgency
    Mx Execute Template With Multiple Data    Write Loan Details from Deal for DNR    ${DNR_DATASET}    ${rowid}    SC1_DealSetup

Facility Setup for Expanded Scenario 1 - Payment Non Agency
    [Tags]    02 Facility 1 Setup for Expanded Scenario 1 - Payment Non Agency
    Set Global Variable    ${rowid}    4
    Mx Execute Template With Multiple Data    Create Facility for DNR    ${DNR_DATASET}    ${rowid}    SC1_FacilitySetup
    Mx Execute Template With Multiple Data    Ongoing Fee Setup for DNR     ${DNR_DATASET}    ${rowid}    SC1_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Get Active Facility Details for Active Outstanding and Write in DNR Dataset    ${DNR_DATASET}    ${rowid}    SC1_FacilitySetup
    
    Set Global Variable    ${TestCase_Name}    Expanded_Scenario1_Payment_NonAgency
    Mx Execute Template With Multiple Data    Write Loan Details from Facility for DNR    ${DNR_DATASET}    ${rowid}    SC1_FacilitySetup

Primary Setup for Expanded Scenario 1 - Payment Non Agency
    [Tags]    03 Primary Setup for Expanded Scenario 1 - Payment Non Agency
    Set Global Variable    ${rowid}    4
    Mx Execute Template With Multiple Data    Setup a Primary Notebook for DNR    ${DNR_DATASET}    ${rowid}    SC1_PrimaryAllocation
    Mx Execute Template With Multiple Data    Close Deal for DNR    ${DNR_DATASET}    ${rowid}    SC1_PrimaryAllocation
    Mx Execute Template With Multiple Data    Get Deal Details and Write in DNR Dataset    ${DNR_DATASET}    ${rowid}    SC1_PrimaryAllocation
    
Create Initial Loan Drawdown for Active Facility Expanded Scenario 1 - Payment Non Agency
    [Tags]    04 Create Initial Loan Drawdown for Expanded Scenario 1 - Payment Non Agency
    # Set Global Variable    ${rowid}    4
    # Set Global Variable    ${TestCase_Name}    Expanded_Scenario1_Payment_NonAgency
    # Mx Execute Template With Multiple Data    Create Revolver Facility Drawdown for DNR Bilateral Deal until Awaiting Send to Rate Approval    ${DNR_DATASET}    ${rowid}    SC1_LoanDrawdown
    
    ### Generate Payment Non Agenecy Cash Out Report Approved Status ###
    Set Global Variable    ${TestCase_Name}    PAYNA_002
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Payment    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Facility Performance    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR

