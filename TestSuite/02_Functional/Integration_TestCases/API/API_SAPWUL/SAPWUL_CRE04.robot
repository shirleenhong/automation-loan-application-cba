*** Settings ***
Resource    ../../../../Configurations/Import_File.robot

*** Variables ***
${DealRowID}    4
${Facility_F}    6
${Facility_G}    7
${Facility_H}    8
${SAPWULRowID}    4
*** Test Cases ***
SAPWUL_CRE04
    [Tags]    SAPWUL_CRE04
	[Documentation]    Deal with Multiple Facility where ALL effective date is in the future
    ...    @author: hstone 
    ### SAPWUL Data Clear ###
    Mx Execute Template With Multiple Data    Clear SAPWUL Data     ${SAPWUL_DATASET}    ${SAPWULRowID}    SAPWUL_Payload
    
    ### Deal Creation ###
    Mx Execute Template With Multiple Data    Deal Create    ${SAPWUL_DATASET}    ${DealRowID}    DealData
    
    ### Facility Creation ###
    Mx Execute Template With Multiple Data    Deal Facility Create    ${SAPWUL_DATASET}    ${Facility_F}    FacilityData
    Mx Execute Template With Multiple Data    Deal Facility Save     ${SAPWUL_DATASET}    ${Facility_F}    FacilityFeeData
    
    ### Facility Creation ###
    Mx Execute Template With Multiple Data    Deal Facility Create    ${SAPWUL_DATASET}    ${Facility_G}    FacilityData
    Mx Execute Template With Multiple Data    Deal Facility Save     ${SAPWUL_DATASET}    ${Facility_G}    FacilityFeeData
    
    ### Facility Creation ###
    Mx Execute Template With Multiple Data    Deal Facility Create    ${SAPWUL_DATASET}    ${Facility_H}    FacilityData
    Mx Execute Template With Multiple Data    Deal Facility Save     ${SAPWUL_DATASET}    ${Facility_H}    FacilityFeeData
     
    ### SAPWUL Events Verification ###
    Mx Execute Template With Multiple Data    Verify Deal Event XML     ${SAPWUL_DATASET}    ${DealRowID}    DealData
    Mx Execute Template With Multiple Data    Verify Facility Event XML    ${SAPWUL_DATASET}    ${Facility_F}    FacilityData
    Mx Execute Template With Multiple Data    Verify Facility Event XML    ${SAPWUL_DATASET}    ${Facility_G}    FacilityData
    Mx Execute Template With Multiple Data    Verify Facility Event XML    ${SAPWUL_DATASET}    ${Facility_H}    FacilityData
