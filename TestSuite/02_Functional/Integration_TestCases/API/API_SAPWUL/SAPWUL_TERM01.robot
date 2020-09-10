*** Settings ***
Resource    ../../../../Configurations/Import_File.robot

*** Variables ***
${SAPWULTERM01_FACILITY}    32
${SAPWULTERM01_PAYLOAD}     20

*** Test Cases ***
SAPWUL_TERM01
    [Tags]    SAPWUL_TERM01
	[Documentation]     Verify that user is able to Terminate a Facility by User and payload is generated successfully
    ...    @precondition: Execute EVG07_BilateralFacilityTermination.robot to have a terminated facility
    ...    @author: hstone    14JAN2020    Initial Create 
    ### SAPWUL Data Clear ###
    Mx Execute Template With Multiple Data    Clear SAPWUL Data     ${SAPWUL_DATASET}    ${SAPWULTERM01_PAYLOAD}    SAPWUL_Payload
    
    ### Get Facility Payload Data ###
    Mx Execute Template With Multiple Data    Get SAPWUL Facility Payload Data     ${SAPWUL_DATASET}    ${SAPWULTERM01_FACILITY}    FacilityData

    ### Map Payload Values in Reference to Table Maintenance ###
    Mx Execute Template With Multiple Data    Set Facility Data Payload Values in Reference to Table Maintenance     ${SAPWUL_DATASET}    ${SAPWULTERM01_FACILITY}    FacilityData
    
    ### SAPWUL Events Verification ###
    Mx Execute Template With Multiple Data    Create Payload Expected JSON Files     ${SAPWUL_DATASET}    ${SAPWULTERM01_PAYLOAD}    SAPWUL_Payload
    Mx Execute Template With Multiple Data    Verify Facility Event XML     ${SAPWUL_DATASET}    ${SAPWULTERM01_FACILITY}    FacilityData
    Mx Execute Template With Multiple Data    Verify FFC SAPWUL Facility Payload     ${SAPWUL_DATASET}    ${SAPWULTERM01_PAYLOAD}    SAPWUL_Payload   