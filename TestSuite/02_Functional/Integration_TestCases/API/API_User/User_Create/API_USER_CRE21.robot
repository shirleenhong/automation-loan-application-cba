*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_CRE21
    [Documentation]    This testcase is used to validate user creation using demographic and per application fields with maximum field lengths
    ...    and and verify that the POST method will success but user will not be created in the application.
    ...    @author: dahijara    31JUL2019    - Initial Create
    

    ${rowid}    Set Variable    211
    Mx Execute Template With Multiple Data    Create LIQ User Using Maximum Field Lengths and No Error in CCB    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable    212
    Mx Execute Template With Multiple Data    Create Essence User Using Maximum Field Lengths and No Error in CCB    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable    213
    Mx Execute Template With Multiple Data    Create Party User Using Maximum Field Lengths and No Error in CCB    ${APIDataSet}    ${rowid}    Users_Fields