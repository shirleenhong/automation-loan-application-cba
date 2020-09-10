*** Settings ***
Resource    ../../../../Configurations/Import_File.robot

*** Variables ***
${Facility_RowID}    13
${SAPWULRowID}    7
*** Test Cases ***
SAPWUL_UPD02
    [Tags]    SAPWUL_UPD02
	[Documentation]    Verify that user is able to update Facility name once Deal is closed and payload is generated successfully
    ...    @author: hstone
    ...    @update: amansuet    30OCT2019    - Updated values in Variables
    ### SAPWUL Data Clear ###
    Mx Execute Template With Multiple Data    Clear SAPWUL Data     ${SAPWUL_DATASET}    ${SAPWULRowID}    SAPWUL_Payload
    
    ### Facility Update ###
    Mx Execute Template With Multiple Data    Update Facility Name    ${SAPWUL_DATASET}    ${Facility_RowID}    FacilityData
    
    ### Map Payload Values in Reference to Table Maintenance ###
    Mx Execute Template With Multiple Data    Set Facility Data Payload Values in Reference to Table Maintenance     ${SAPWUL_DATASET}    ${Facility_RowID}    FacilityData
    
    ### SAPWUL Events Verification ###
    Mx Execute Template With Multiple Data    Create Payload Expected JSON Files     ${SAPWUL_DATASET}    ${SAPWULRowID}    SAPWUL_Payload
    Mx Execute Template With Multiple Data    Verify Facility Event XML     ${SAPWUL_DATASET}    ${Facility_RowID}    FacilityData
    Mx Execute Template With Multiple Data    Verify FFC SAPWUL Facility Payload     ${SAPWUL_DATASET}    ${SAPWULRowID}    SAPWUL_Payload   
