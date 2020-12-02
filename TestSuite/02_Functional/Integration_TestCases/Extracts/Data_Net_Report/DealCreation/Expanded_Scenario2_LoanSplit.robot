*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot
#Test Teardown    Test Suite Tear Down

*** Variables ***
${rowid}    3
${SCENARIO}    2

*** Test Cases ***
Expanded Scenario2 Loan Split
    [Documentation]    This keyword creates the Pre requisite of Data Net Report AHBDE_005
    ...    @author: fluberio    24NOV2020    - initial create
    # Mx Execute Template With Multiple Data    Setup Syndicated Deal for DNR    ${DNR_DATASET}    ${rowid}    SC2_DealSetup
    # Mx Execute Template With Multiple Data    Setup Deal Administrative Fees for DNR    ${DNR_DATASET}	${rowid}    SC2_AdminFee
    # Mx Execute Template With Multiple Data    Setup Deal Event Fees    ${DNR_DATASET}    ${rowid}    SC2_EventFee
    # Mx Execute Template With Multiple Data    Setup Term Facility for Syndicated Deal for DNR    ${DNR_DATASET}    ${rowid}    SC2_FacilitySetup
    # Mx Execute Template With Multiple Data    Setup Fees for Term Facility    ${DNR_DATASET}    ${rowid}    SC2_OngoingFeeSetup
    # Mx Execute Template With Multiple Data    Setup Primaries for Syndicated Deal for DNR    ${DNR_DATASET}    ${rowid}    SC2_PrimaryAllocation
    # Mx Execute Template With Multiple Data    Syndicated Deal Approval and Close    ${DNR_DATASET}    ${rowid}    SC2_PrimaryAllocation
    # Mx Execute Template With Multiple Data    Create Revolver Facility Drawdown for DNR    ${DNR_DATASET}    ${rowid}    SC2_LoanDrawdown
    Mx Execute Template With Multiple Data    Create Loan Split For DNR    ${DNR_DATASET}    ${rowid}    SC2_LoanSplit