*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Generate and Verify LIQ Extract for Specific Zone
    [Documentation]    This keyword is used to verify that the User is able to generate and verify the extracted data from LIQ for specific ZONE.
    ...    @author: clanding    09JUL2020    - initial create
    ...    @update: clanding    28AUG2020    - removed Mx Launch UFT and Login to Loan IQ and moved it to Test Setup; removed Close All Connections and moved to Test Teardown
    ...    @update: clanding    03SEP2020    - added &{DWE_DATASET}[Batch_Net] to make the validation dynamic
    [Arguments]    ${DWE_DATASET}

    ${LIQ_Zone_BusDate}    Get LoanIQ Business Date per Zone and Return    &{DWE_DATASET}[Zone]
    ${LIQ_Zone_BusDate_Converted}    Convert Date    ${LIQ_Zone_BusDate}    date_format=%d-%b-%Y    result_format=%Y-%m-%d
    Write Data to Excel    DWE    Business_Date    ${TestCase_Name}    ${LIQ_Zone_BusDate_Converted}    ${DWE_EXCEL_DATASET}    bTestCaseColumn=True
    Set To Dictionary    ${DWE_DATASET}    Business_Date=${LIQ_Zone_BusDate_Converted}
    Validate Execution Journal for DWE LIQ Extract    &{DWE_DATASET}[Zone]    &{DWE_DATASET}[Job_Name]    &{DWE_DATASET}[BPR_Name]    &{DWE_DATASET}[Batch_Net]

    Open Connection and Login    ${DWE_SERVER_LIQ}    ${DWE_PORT}    ${DWE_SERVER_USER}    ${DWE_SERVER_PASSWORD}
    ${sAlphanumericFolder_Name}    Validate Alphanumeric Folder from Landing Area    &{DWE_DATASET}[Zone]    &{DWE_DATASET}[Extract_Files_Path]
    Validate Manifest File from Landing Area    &{DWE_DATASET}[Zone]    &{DWE_DATASET}[Extract_Files_Path]    ${sAlphanumericFolder_Name}    &{DWE_DATASET}[Status]
    ...    &{DWE_DATASET}[Business_Date]    &{DWE_DATASET}[Load_Type]
    Validate DWH Folder from Landing Area    &{DWE_DATASET}[Zone]    &{DWE_DATASET}[Extract_Files_Path]    ${sAlphanumericFolder_Name}