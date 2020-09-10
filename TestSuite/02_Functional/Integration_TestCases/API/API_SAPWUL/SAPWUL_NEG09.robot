*** Settings ***
Resource    ../../../../Configurations/Import_File.robot

*** Variables ***
${SAPWULNEG09_DEAL}    7
${SAPWULNEG09_FACILITY-A}    26
${SAPWULNEG09_FACILITYFEE-A}    13
*** Test Cases ***
SAPWUL_NEG09
    [Tags]    SAPWUL_NEG09
	[Documentation]     Verify that user is able to create a Deal amendment aside from Adding facility and will not trigger a payload
    ...    @author: hstone     11DEC2019
    ### Deal Creation ###
    Mx Execute Template With Multiple Data    Deal Create    ${SAPWUL_DATASET}    ${SAPWULNEG09_DEAL}    DealData
    
    ## Facility Creation ###
    Mx Execute Template With Multiple Data    Deal Facility Create    ${SAPWUL_DATASET}    ${SAPWULNEG09_FACILITY-A}   FacilityData
    Mx Execute Template With Multiple Data    Deal Facility Fee Setup     ${SAPWUL_DATASET}    ${SAPWULNEG09_FACILITYFEE-A}    FacilityFeeData
    Mx Execute Template With Multiple Data    Deal Facility Save     ${SAPWUL_DATASET}    ${SAPWULNEG09_FACILITYFEE-A}    FacilityFeeData
    
    ### Setting Up Deal Primaries and Deal Closing ###
    Mx Execute Template With Multiple Data    Deal Primaries Setup - Single Facility     ${SAPWUL_DATASET}    ${SAPWULNEG09_DEAL}    DealData
    Mx Execute Template With Multiple Data    Deal Close     ${SAPWUL_DATASET}    ${SAPWULNEG09_DEAL}    DealData
    
    ### Create Facility Ammendment ###
    Mx Execute Template With Multiple Data    Create Deal Amendment - Unscheduled Commitment Increase    ${SAPWUL_DATASET}    ${SAPWULNEG09_FACILITY-A}    FacilityData
    
    ### SAPWUL Events Verification ###
    Mx Execute Template With Multiple Data    Verify Deal Event XML     ${SAPWUL_DATASET}    ${SAPWULNEG09_DEAL}    DealData