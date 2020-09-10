*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Variables ***
${DealRowID}    6
${Facility_G}    30
${FacilityFees_G}    12
${SAPWULRowID}    24

*** Test Cases ***
SAPWUL_NEG01
    [Tags]    SAPWUL_NEG01
	[Documentation]     Verify that payload will not be triggered when facility amount is decreased
    ...    @author: hstone 
    ...    @update: amansuet    30OCT2019    - Updated values in Variables
    ### SAPWUL Data Clear ###
    Mx Execute Template With Multiple Data    Clear SAPWUL Data     ${SAPWUL_DATASET}    ${SAPWULRowID}    SAPWUL_Payload
    
    ### Deal Creation ###
    Mx Execute Template With Multiple Data    Deal Create    ${SAPWUL_DATASET}    ${DealRowID}    DealData
    
    ### Facility Creation ###
    Mx Execute Template With Multiple Data    Deal Facility Create    ${SAPWUL_DATASET}    ${Facility_G}    FacilityData
    Mx Execute Template With Multiple Data    Deal Facility Fee Setup     ${SAPWUL_DATASET}    ${FacilityFees_G}    FacilityFeeData
    Mx Execute Template With Multiple Data    Deal Facility Save     ${SAPWUL_DATASET}    ${FacilityFees_G}    FacilityFeeData
    
    ### Setting Up Deal Primaries and Deal Closing ###
    Mx Execute Template With Multiple Data    Deal Primaries Setup - Single Facility     ${SAPWUL_DATASET}    ${DealRowID}    DealData
    Mx Execute Template With Multiple Data    Deal Close     ${SAPWUL_DATASET}    ${DealRowID}    DealData
    
    ### Create Facility Ammendment ###
    Mx Execute Template With Multiple Data    Decrease Facility Commitment Amount    ${SAPWUL_DATASET}    ${Facility_G}    FacilityData
    
    ### SAPWUL Events Verification ###
    Mx Execute Template With Multiple Data    Verify Deal Event XML     ${SAPWUL_DATASET}    ${DealRowID}    DealData
