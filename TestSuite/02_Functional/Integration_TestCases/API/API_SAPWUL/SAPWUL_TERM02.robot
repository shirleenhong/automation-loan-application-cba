*** Settings ***
Resource    ../../../../Configurations/Import_File.robot

*** Variables ***
${Facility_A}    1

*** Test Cases ***
SAPWUL_TERM02
    [Tags]    SAPWUL_TERM02
	[Documentation]     Verify that user is NOT allowed to Terminate facility that is future dated
    ...    @author: fmamaril    30OCT19    Initial Create 

    ### Terminate Facility - Negative###
    Mx Execute Template With Multiple Data    Terminate future dated facility     ${SAPWUL_DATASET}    ${Facility_A}    FacilityData
  
