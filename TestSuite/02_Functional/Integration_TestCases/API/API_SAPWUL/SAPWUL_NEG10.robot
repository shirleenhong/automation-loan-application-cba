*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Variables ***
${SAPWULNEG10_DEAL}    8
${SAPWULNEG10_FACILITY}    29
${SAPWULNEG09_FACILITYFEE}    14

*** Test Cases ***
SAPWUL_NEG10
    [Tags]    SAPWUL_NEG10
	[Documentation]     Verify that user is not able to update guarantor to Primary
    ...    @author: hstone     08JAN2020
    ### Deal Creation ###
    Mx Execute Template With Multiple Data    Deal Create    ${SAPWUL_DATASET}    ${SAPWULNEG10_DEAL}    DealData
    
    ## Facility Creation ###
    Mx Execute Template With Multiple Data    Deal Facility Create    ${SAPWUL_DATASET}    ${SAPWULNEG10_FACILITY}   FacilityData
    Mx Execute Template With Multiple Data    Deal Facility Fee Setup     ${SAPWUL_DATASET}    ${SAPWULNEG09_FACILITYFEE}    FacilityFeeData
    Mx Execute Template With Multiple Data    Deal Facility Save     ${SAPWUL_DATASET}    ${SAPWULNEG09_FACILITYFEE}    FacilityFeeData
    
    ### Setting Up Deal Primaries and Deal Closing ###
    Mx Execute Template With Multiple Data    Deal Primaries Setup - Single Facility     ${SAPWUL_DATASET}    ${SAPWULNEG10_DEAL}    DealData
    Mx Execute Template With Multiple Data    Deal Close     ${SAPWUL_DATASET}    ${SAPWULNEG10_DEAL}    DealData
    
    ### Add Guarantor ###
    Mx Execute Template With Multiple Data    Add Guarantor Then Approve and Release the Facility Change Transaction    ${SAPWUL_DATASET}    ${SAPWULNEG10_FACILITY}    FacilityData
    
    ### Guarantor Primary Indicator Not Exsisting Verification ###
    Mx Execute Template With Multiple Data    Verify Guarantor Cannot be Marked as Primary    ${SAPWUL_DATASET}    ${SAPWULNEG10_FACILITY}    FacilityData