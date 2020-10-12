*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Variables ***
${DealRowID}    2
${Facility_B}    2
${Facility_C}    3
${Facility_D}    4
${SAPWULRowID}    2

*** Test Cases ***
SAPWUL_CRE02
    [Tags]    SAPWUL_CRE02
	[Documentation]    Verify that user is able to create deal with more than 1 Facility and payload is generated successfully
    ...    @author: hstone 
    ### SAPWUL Data Clear ###
    Mx Execute Template With Multiple Data    Clear SAPWUL Data     ${SAPWUL_DATASET}    ${SAPWULRowID}    SAPWUL_Payload
    
    ### Deal Creation ###
    Mx Execute Template With Multiple Data    Deal Create    ${SAPWUL_DATASET}    ${DealRowID}    DealData
    
    ### Facility Creation ###
    Mx Execute Template With Multiple Data    Deal Facility Create    ${SAPWUL_DATASET}    ${Facility_B}    FacilityData
    Mx Execute Template With Multiple Data    Deal Facility Fee Setup     ${SAPWUL_DATASET}    ${Facility_B}    FacilityFeeData
    Mx Execute Template With Multiple Data    Deal Facility Save     ${SAPWUL_DATASET}    ${Facility_B}    FacilityFeeData
    
    ### Facility Creation ###
    Mx Execute Template With Multiple Data    Deal Facility Create    ${SAPWUL_DATASET}    ${Facility_C}    FacilityData
    Mx Execute Template With Multiple Data    Deal Facility Fee Setup     ${SAPWUL_DATASET}    ${Facility_C}    FacilityFeeData
    Mx Execute Template With Multiple Data    Deal Facility Save     ${SAPWUL_DATASET}    ${Facility_C}    FacilityFeeData
    
    ### Facility Creation ###
    Mx Execute Template With Multiple Data    Deal Facility Create    ${SAPWUL_DATASET}    ${Facility_D}    FacilityData
    Mx Execute Template With Multiple Data    Deal Facility Fee Setup     ${SAPWUL_DATASET}    ${Facility_D}    FacilityFeeData
    Mx Execute Template With Multiple Data    Deal Facility Save     ${SAPWUL_DATASET}    ${Facility_D}    FacilityFeeData
    
    ### Setting Up Deal Primaries and Deal Closing
    Mx Execute Template With Multiple Data    Deal Primaries Setup - Multiple Facilities     ${SAPWUL_DATASET}    ${DealRowID}    DealData
    Mx Execute Template With Multiple Data    Deal Close     ${SAPWUL_DATASET}    ${DealRowID}    DealData
    
    ### Map Payload Values in Reference to Table Maintenance ###
    Mx Execute Template With Multiple Data    Set Facility Data Payload Values in Reference to Table Maintenance     ${SAPWUL_DATASET}    ${Facility_B}    FacilityData
    Mx Execute Template With Multiple Data    Set Facility Data Payload Values in Reference to Table Maintenance     ${SAPWUL_DATASET}    ${Facility_C}    FacilityData
    Mx Execute Template With Multiple Data    Set Facility Data Payload Values in Reference to Table Maintenance     ${SAPWUL_DATASET}    ${Facility_D}    FacilityData
    
    ## SAPWUL Events Verification ###
    Mx Execute Template With Multiple Data    Create Payload Expected JSON Files     ${SAPWUL_DATASET}    ${SAPWULRowID}    SAPWUL_Payload
    Mx Execute Template With Multiple Data    Verify Deal Event XML     ${SAPWUL_DATASET}    ${DealRowID}    DealData
    Mx Execute Template With Multiple Data    Verify FFC SAPWUL Facility Payload     ${SAPWUL_DATASET}    ${SAPWULRowID}    SAPWUL_Payload
    
