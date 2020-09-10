*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Variables ***
${DealRowID}    7
${Facility_M}    28 
   
*** Test Cases ***
SAPWUL_UPD18
    [Tags]    SAPWUL_UPD18
	[Documentation]    Verify that payload is not generated when the a new borrower is added and old borrower is removed (not the primary borrower)
    ...    @author: hstone    11DEC2019    - initial create
    ### Facility Update ###
    Mx Execute Template With Multiple Data    Replace Borrower Then Approve and Release the Facility Change Transaction    ${SAPWUL_DATASET}    ${Facility_M}    FacilityData
      
    ### SAPWUL Events Verification ###
    Mx Execute Template With Multiple Data    Verify Facility Event XML     ${SAPWUL_DATASET}    ${Facility_M}    FacilityData