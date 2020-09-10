*** Settings ***
Resource    ../../../../Configurations/Import_File.robot

*** Variables ***
${DealRowID}    5
${Facility_I}    23
${Facility_J}    24
${Facility_K}    25
${FacilityFees_I}    9
${FacilityFees_J}    10
${FacilityFees_K}    11
${SAPWULRowID}    19
*** Test Cases ***
SAPWUL_CRE05
    [Tags]    SAPWUL_CRE05
	[Documentation]    Deal with Multiple Facility where combination of current and future effective date (ie. 3 Facilities – 1 Current and 2 Future effective date)
    ...    @author: hstone 
    ### SAPWUL Data Clear ###
    Mx Execute Template With Multiple Data    Clear SAPWUL Data     ${SAPWUL_DATASET}    ${SAPWULRowID}    SAPWUL_Payload
    
    ### Deal Creation ###
    Mx Execute Template With Multiple Data    Deal Create    ${SAPWUL_DATASET}    ${DealRowID}    DealData
    
    ### Facility Creation ###
    Mx Execute Template With Multiple Data    Deal Facility Create    ${SAPWUL_DATASET}    ${Facility_I}    FacilityData
    Mx Execute Template With Multiple Data    Deal Facility Fee Setup     ${SAPWUL_DATASET}    ${FacilityFees_I}    FacilityFeeData
    Mx Execute Template With Multiple Data    Deal Facility Save     ${SAPWUL_DATASET}    ${FacilityFees_I}    FacilityFeeData
    
    ### Facility Creation ###
    Mx Execute Template With Multiple Data    Deal Facility Create    ${SAPWUL_DATASET}    ${Facility_J}    FacilityData
    Mx Execute Template With Multiple Data    Deal Facility Fee Setup     ${SAPWUL_DATASET}    ${FacilityFees_J}    FacilityFeeData
    Mx Execute Template With Multiple Data    Deal Facility Save     ${SAPWUL_DATASET}    ${FacilityFees_J}    FacilityFeeData
    
    ### Facility Creation ###
    Mx Execute Template With Multiple Data    Deal Facility Create    ${SAPWUL_DATASET}    ${Facility_K}    FacilityData
    Mx Execute Template With Multiple Data    Deal Facility Fee Setup     ${SAPWUL_DATASET}    ${FacilityFees_K}    FacilityFeeData
    Mx Execute Template With Multiple Data    Deal Facility Save     ${SAPWUL_DATASET}    ${FacilityFees_K}    FacilityFeeData
    
    ### Setting Up Deal Primaries and Deal Closing
    Mx Execute Template With Multiple Data    Deal Primaries Setup - Multiple Facilities     ${SAPWUL_DATASET}    ${DealRowID}    DealData
    Mx Execute Template With Multiple Data    Deal Close     ${SAPWUL_DATASET}    ${DealRowID}    DealData
    
    ### Map Payload Values in Reference to Table Maintenance ###
    Mx Execute Template With Multiple Data    Set Facility Data Payload Values in Reference to Table Maintenance     ${SAPWUL_DATASET}    ${Facility_I}    FacilityData
    
    ### SAPWUL Events Verification ###
    Mx Execute Template With Multiple Data    Create Payload Expected JSON Files     ${SAPWUL_DATASET}    ${SAPWULRowID}    SAPWUL_Payload
    Mx Execute Template With Multiple Data    Verify Deal Event XML     ${SAPWUL_DATASET}    ${DealRowID}    DealData
    Mx Execute Template With Multiple Data    Verify FFC SAPWUL Facility Payload     ${SAPWUL_DATASET}    ${SAPWULRowID}    SAPWUL_Payload