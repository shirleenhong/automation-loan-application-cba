*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Generate and Process LIQ Extracts for Zone 3
    [Documentation]    This keyword is used to verify that the User is able to generate and processed the Extracts from LIQ for Zone 3.
    ...    @author: clanding    10JUL2020    - initial create
    [Arguments]    ${DWE_DATASET}

    # Mx Launch UFT    Visibility=True    UFTAddins=Java
    Login to Loan IQ    ${DWE_LIQ_USER}    ${DWE_LIQ_PASSWORD}
    ${LIQ_Zone_BusDate}    Get Business Date by Batch Net for DWE    &{DWE_DATASET}[Zone]    &{DWE_DATASET}[Batch_Net]
    ${LIQ_Zone_BusDate_Converted}    Convert Date    ${LIQ_Zone_BusDate}    date_format=%d-%b-%Y    result_format=%Y-%m-%d
    Write Data to Excel    DWE    Business_Date    ${TestCase_Name}    ${LIQ_Zone_BusDate_Converted}    ${DWE_EXCEL_DATASET}    bTestCaseColumn=True
    Set To Dictionary    ${DWE_DATASET}    Business_Date=${LIQ_Zone_BusDate_Converted}

    Open Connection and Login    ${DWE_SERVER}    ${DWE_PORT}    ${DWE_SERVER_USER}    ${DWE_SERVER_PASSWORD}
    ${GPG_File}    ${GZ_File}    ${JSON_File}    Download Compressed and JSON File from Extraction Area    &{DWE_DATASET}[Zone]    &{DWE_DATASET}[Extract_Files_Path]    &{DWE_DATASET}[Business_Date]
    Write Data to Excel    DWE    GPG_File    ${TestCase_Name}    ${GPG_File}    ${DWE_EXCEL_DATASET}    bTestCaseColumn=True
    Write Data to Excel    DWE    GZ_File    ${TestCase_Name}    ${GZ_File}    ${DWE_EXCEL_DATASET}    bTestCaseColumn=True
    Write Data to Excel    DWE    JSON_File    ${TestCase_Name}    ${JSON_File}    ${DWE_EXCEL_DATASET}    bTestCaseColumn=True
    Set To Dictionary    ${DWE_DATASET}    GPG_File=${GPG_File}
    Set To Dictionary    ${DWE_DATASET}    GZ_File=${GZ_File}
    Set To Dictionary    ${DWE_DATASET}    JSON_File=${JSON_File}
    Validate JSON File from Extraction Area    &{DWE_DATASET}[JSON_File]    &{DWE_DATASET}[Extract_Files_Path]    &{DWE_DATASET}[Product_Name]    &{DWE_DATASET}[Product_Version]
    ...    &{DWE_DATASET}[GPG_File]    &{DWE_DATASET}[Element_Value]    &{DWE_DATASET}[Encrytion_Type]    &{DWE_DATASET}[Hashing_Algorithm]
    ...    &{DWE_DATASET}[Compression_Type]
    Decrypt Compressed File for DWE Extract    &{DWE_DATASET}[Extract_Files_Path]    &{DWE_DATASET}[GPG_File]    &{DWE_DATASET}[GZ_File]
    Validate Compressed File from Extraction Area    &{DWE_DATASET}[Extract_Files_Path]    &{DWE_DATASET}[GZ_File]    &{DWE_DATASET}[Element_Value]
    Close All Connections