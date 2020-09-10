*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Variables ***
${DealRowID}    3
${Facility_E}    5
${SAPWULRowID}    3

*** Test Cases ***
SAPWUL_CRE03
    [Tags]    SAPWUL_CRE03
	[Documentation]    Verify that user is unable to generate payload when facility is in pending state
    ...    @author: hstone 
    ### SAPWUL Data Clear ###
    Mx Execute Template With Multiple Data    Clear SAPWUL Data     ${SAPWUL_DATASET}    ${SAPWULRowID}    SAPWUL_Payload
    
    ### Deal Creation ###
    Mx Execute Template With Multiple Data    Deal Create    ${SAPWUL_DATASET}    ${DealRowID}    DealData
    
    ### Facility Creation ###
    Mx Execute Template With Multiple Data    Deal Facility Create    ${SAPWUL_DATASET}    ${Facility_E}    FacilityData
    Mx Execute Template With Multiple Data    Deal Facility Save     ${SAPWUL_DATASET}    ${Facility_E}    FacilityFeeData
    
    ### SAPWUL Events Verification ###
    Mx Execute Template With Multiple Data    Verify Deal Event XML     ${SAPWUL_DATASET}    ${DealRowID}    DealData
    Mx Execute Template With Multiple Data    Verify Facility Event XML    ${SAPWUL_DATASET}    ${Facility_E}    FacilityData
