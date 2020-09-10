*** Settings ***
Resource    ../../../../Configurations/Import_File.robot

*** Variables ***
${DealRowID}    1
${Facility_RowID}    18
${SAPWULRowID}    12
*** Test Cases ***
SAPWUL_UPD07
    [Tags]    SAPWUL_UPD07
	[Documentation]    Verify that user is able to Update Multiple fields on Facility Change Transaction and payload is generated successfully
    ...    @author: ehugo
    ...    @update: amansuet    30OCT2019    - Updated values in Variables 
    ### SAPWUL Data Clear ###
    Mx Execute Template With Multiple Data    Clear SAPWUL Data     ${SAPWUL_DATASET}    ${SAPWULRowID}    SAPWUL_Payload
    
    ### Facility Update ###
    Mx Execute Template With Multiple Data    Update Multiple Fields of Facility Then Approve and Release the Facility Change Transaction    ${SAPWUL_DATASET}    ${Facility_RowID}    FacilityData
    
    ### Map Payload Values in Reference to Table Maintenance ###
    Mx Execute Template With Multiple Data    Set Facility Data Payload Values in Reference to Table Maintenance     ${SAPWUL_DATASET}    ${Facility_RowID}    FacilityData
    
    ### SAPWUL Events Verification ###
    Mx Execute Template With Multiple Data    Create Payload Expected JSON Files     ${SAPWUL_DATASET}    ${SAPWULRowID}    SAPWUL_Payload
    Mx Execute Template With Multiple Data    Verify Facility Event XML     ${SAPWUL_DATASET}    ${Facility_RowID}    FacilityData
    Mx Execute Template With Multiple Data    Verify FFC SAPWUL Facility Payload     ${SAPWUL_DATASET}    ${SAPWULRowID}    SAPWUL_Payload   
