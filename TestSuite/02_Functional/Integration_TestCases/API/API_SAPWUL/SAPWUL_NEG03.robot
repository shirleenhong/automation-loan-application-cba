*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Variables ***
${Facility_RowID_Preq}    33
${Facility_RowID}    34

*** Test Cases ***
SAPWUL_NEG03
    [Tags]    SAPWUL_NEG03
	[Documentation]     Verify that payload will not be triggered when Facilty Status is Matured and then Active
    ...    @author: amansuet    05NOV2019    - initial create
    
    ### Pre- Requisite ###
    Mx Execute Template With Multiple Data    Update Facility Status from Active to Matured Then Approve and Release the Facility Change Transaction    ${SAPWUL_DATASET}    ${Facility_RowID_Preq}    FacilityData
    
    ### Facility Update ###
    Mx Execute Template With Multiple Data    Update Facility Status from Matured to Active Then Approve and Release the Facility Change Transaction    ${SAPWUL_DATASET}    ${Facility_RowID}    FacilityData
    
    ### SAPWUL Events Verification ###
    Mx Execute Template With Multiple Data    Verify Facility Event XML     ${SAPWUL_DATASET}    ${Facility_RowID}    FacilityData
    
