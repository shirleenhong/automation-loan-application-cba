*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Variables ***
${Facility_RowID_Preq}    31
${Facility_RowID}    32

*** Test Cases ***
SAPWUL_NEG02
    [Tags]    SAPWUL_NEG02
	[Documentation]     Verify that payload will not be triggered when Facility Status is Expired and then Active
    ...    @author: amansuet    25OCT2019    - initial create
    ...    @update: amansuet    30OCT2019    - Updated values in Variables
    ...    @update: amansuet    05NOV2019    - Updated script to align with other negative test cases
    
    ### Pre- Requisite ###
    Mx Execute Template With Multiple Data    Update Facility Status from Active to Expired Then Approve and Release the Facility Change Transaction    ${SAPWUL_DATASET}    ${Facility_RowID_Preq}    FacilityData
    
    ### Facility Update ###
    Mx Execute Template With Multiple Data    Update Facility Status from Expired to Active Then Approve and Release the Facility Change Transaction    ${SAPWUL_DATASET}    ${Facility_RowID}    FacilityData
    
    ### SAPWUL Events Verification ###
    Mx Execute Template With Multiple Data    Verify Facility Event XML     ${SAPWUL_DATASET}    ${Facility_RowID}    FacilityData
    
