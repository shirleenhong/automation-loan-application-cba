*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Verify Guarantor Cannot be Marked as Primary
    [Documentation]    This keyword verifies if guarantor list has no primary guarantor indicator at the deal notebook and facility change transaction.
    ...    @author: hstone    08JAN2020    Initial create
    [Arguments]    ${FacilityDataSet}
    
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityRowID}    Read Data From Excel    DealData    Deal_FacilityRowID1   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   ${sFacilityRowID}    ${SAPWUL_DATASET}
    ${sPrimaryIndicatorHeaders}    Read Data From Excel    FacilityData    Primary_Headers   ${sFacilityRowID}    ${SAPWUL_DATASET}
    ${sPrimaryIndicatorHeader_List}    Extract List from a Delimited String    ${sPrimaryIndicatorHeaders}
    
    ### Deal Notebook Primary Guarantor Indicator Verification ###
    Open Existing Deal    ${sDealName}
    Validate Deal Notebook Guarantor Primary Indicator Does Not Exist    ${sPrimaryIndicatorHeader_List}
    Validate Deal Notebook Guarantor Make Primary Button Does Not Exist
    
    ### Facility Change Transaction Primary Guarantor Indicator Verification ###
    Navigate to Facility Notebook from Deal Notebook    ${sFacilityName}
    Add Facility Change Transaction
    Validate Facility Change Transaction Guarantor Primary Indicator Does Not Exist    ${sPrimaryIndicatorHeader_List}
    Validate Facility Change Transaction Guarantor Make Primary Button Does Not Exist
    
    Close All Windows on LIQ