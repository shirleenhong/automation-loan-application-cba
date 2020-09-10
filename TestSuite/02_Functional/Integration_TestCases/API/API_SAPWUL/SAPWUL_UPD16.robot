*** Settings ***
Resource    ../../../../Configurations/Import_File.robot

*** Variables ***
${SAPWULUPD16_DEAL}    10
${SAPWULUPD16_FACILITY}    31
${SAPWULUPD16_FACILITYFEE}    16

*** Test Cases ***
SAPWUL_UPD16
    [Tags]    SAPWUL_UPD16
	[Documentation]     Verify if user is able to update on Deal closed for CBA not a LENDER to CBA as a LENDER
    ...    @author: hstone     13JAN2020
    ### Deal Creation ###
    Mx Execute Template With Multiple Data    Deal Create    ${SAPWUL_DATASET}    ${SAPWULUPD16_DEAL}    DealData
    
    ## Facility Creation ###
    Mx Execute Template With Multiple Data    Deal Facility Create    ${SAPWUL_DATASET}    ${SAPWULUPD16_FACILITY}   FacilityData
    Mx Execute Template With Multiple Data    Deal Facility Fee Setup     ${SAPWUL_DATASET}    ${SAPWULUPD16_FACILITYFEE}    FacilityFeeData
    Mx Execute Template With Multiple Data    Deal Facility Save     ${SAPWUL_DATASET}    ${SAPWULUPD16_FACILITYFEE}    FacilityFeeData
    
    ### Setting Up Deal Primaries and Deal Closing ###
    Mx Execute Template With Multiple Data    Deal Primaries Setup - Non Host Bank     ${SAPWUL_DATASET}    ${SAPWULUPD16_DEAL}    DealData
    Mx Execute Template With Multiple Data    Deal Close     ${SAPWUL_DATASET}   ${SAPWULUPD16_DEAL}    DealData
    
    ### Deal Lender Update ###
    Mx Execute Template With Multiple Data    Update Deal Lender    ${SAPWUL_DATASET}    ${SAPWULUPD16_DEAL}   DealData

    ### Deal Primaries Event Verification ###
    Mx Execute Template With Multiple Data    Verify Deal Primaries Event XML    ${SAPWUL_DATASET}    ${SAPWULUPD16_DEAL}   DealData