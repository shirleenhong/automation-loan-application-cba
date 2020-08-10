*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Generate and Verify LIQ Extract for Specific Zone
    [Documentation]    This keyword is used to verify that the User is able to generate and verify the extracted data from LIQ for specific ZONE with FULL batch load type.
    ...    @author: clanding    09JUL2020    - initial create
    [Arguments]    ${DWE_DATASET}

    # Mx Launch UFT    Visibility=True    UFTAddins=Java
    Login to Loan IQ    ${DWE_LIQ_USER}    ${DWE_LIQ_PASSWORD}
    ${LIQ_Zone_BusDate}    Get LoanIQ Business Date per Zone and Return    &{DWE_DATASET}[Zone]
    ${LIQ_Zone_BusDate_Converted}    Convert Date    ${LIQ_Zone_BusDate}    date_format=%d-%b-%Y    result_format=%Y-%m-%d
    Write Data to Excel    DWE    Business_Date    ${TestCase_Name}    ${LIQ_Zone_BusDate_Converted}    ${DWE_EXCEL_DATASET}    bTestCaseColumn=True
    Set To Dictionary    ${DWE_DATASET}    Business_Date=${LIQ_Zone_BusDate_Converted}
    Validate Execution Journal for DWE LIQ Extract    &{DWE_DATASET}[Zone]    &{DWE_DATASET}[Job_Name]    &{DWE_DATASET}[BPR_Name]
    
    Open Connection and Login    ${DWE_SERVER}    ${DWE_PORT}    ${DWE_SERVER_USER}    ${DWE_SERVER_PASSWORD}
    ${sAlphanumericFolder_Name}    Validate Alphanumeric Folder from Landing Area    &{DWE_DATASET}[Zone]    &{DWE_DATASET}[Extract_Files_Path]
    Validate Manifest File from Landing Area    &{DWE_DATASET}[Zone]    &{DWE_DATASET}[Extract_Files_Path]    ${sAlphanumericFolder_Name}    &{DWE_DATASET}[Status]
    ...    &{DWE_DATASET}[Business_Date]    &{DWE_DATASET}[Load_Type]
    Validate DWH Folder from Landing Area    &{DWE_DATASET}[Zone]    &{DWE_DATASET}[Extract_Files_Path]    ${sAlphanumericFolder_Name}
    Close All Connections