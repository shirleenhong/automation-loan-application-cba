*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Variables ***
${SAPWULUPD15_DEAL}    9
${SAPWULUPD15_FACILITY}    30
${SAPWULUPD15_FACILITYFEE}    15

*** Test Cases ***
SAPWUL_UPD15
    [Tags]    SAPWUL_UPD15
	[Documentation]     Verify if user is able to update on Deal is closed for CBA as a LENDER to CBA  not a LENDER
    ...    @author: hstone     10JAN2020
    ### Deal Creation ###
    Mx Execute Template With Multiple Data    Deal Create    ${SAPWUL_DATASET}    ${SAPWULUPD15_DEAL}    DealData
    
    ## Facility Creation ###
    Mx Execute Template With Multiple Data    Deal Facility Create    ${SAPWUL_DATASET}    ${SAPWULUPD15_FACILITY}   FacilityData
    Mx Execute Template With Multiple Data    Deal Facility Fee Setup     ${SAPWUL_DATASET}    ${SAPWULUPD15_FACILITYFEE}    FacilityFeeData
    Mx Execute Template With Multiple Data    Deal Facility Save     ${SAPWUL_DATASET}    ${SAPWULUPD15_FACILITYFEE}    FacilityFeeData
    
    ### Setting Up Deal Primaries and Deal Closing ###
    Mx Execute Template With Multiple Data    Deal Primaries Setup - Single Facility     ${SAPWUL_DATASET}    ${SAPWULUPD15_DEAL}    DealData
    Mx Execute Template With Multiple Data    Deal Close     ${SAPWUL_DATASET}   ${SAPWULUPD15_DEAL}    DealData
    
    ### Deal Lender Update ###
    Mx Execute Template With Multiple Data    Update Deal Lender    ${SAPWUL_DATASET}    ${SAPWULUPD15_DEAL}   DealData

    ### Deal Primaries Event Verification ###
    Mx Execute Template With Multiple Data    Verify Deal Primaries Event XML    ${SAPWUL_DATASET}    ${SAPWULUPD15_DEAL}   DealData