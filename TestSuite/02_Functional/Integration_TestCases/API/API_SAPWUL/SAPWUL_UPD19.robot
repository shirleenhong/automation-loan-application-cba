*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Variables ***
${DealRowID}    6
${Facility_L}    27
${FacilityFee_L}    12

*** Test Cases ***
SAPWUL_UPD19
    [Tags]    SAPWUL_UPD19
	[Documentation]    Verify that change in Pending Facility are accepted after Batch Processing
    ...    @author: hstone 
    ## Deal Creation ###
    Mx Execute Template With Multiple Data    Deal Create    ${SAPWUL_DATASET}    ${DealRowID}    DealData
    
    ### Facility Creation ###
    Mx Execute Template With Multiple Data    Deal Facility Create    ${SAPWUL_DATASET}    ${Facility_L}    FacilityData
    Mx Execute Template With Multiple Data    Deal Facility Save     ${SAPWUL_DATASET}    ${FacilityFee_L}    FacilityFeeData
    
    ### Perform 1 Day EOD ###
    Pause Execution    
    
    ### Facility Update ###
    Mx Execute Template With Multiple Data    Update Facility Name    ${SAPWUL_DATASET}    ${Facility_L}    FacilityData
    
    ### SAPWUL Events Verification ###
    Mx Execute Template With Multiple Data    Verify Facility Event XML    ${SAPWUL_DATASET}    ${Facility_L}    FacilityData