*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_CRE18
    [Documentation]    This testcase is used to validate user creation using demographic fields only with maximum field lengths
    ...    and verify that the POST method will success but user will not be created in the application.
    ...    @author: dahijara    31JUL2019    - Initial Create
    
    ${rowid}    Set Variable    18
    Mx Execute Template With Multiple Data    Create User Using Demporaphic Fields Only with Maximum Field Lengths and No Error in CCB    ${APIDataSet}    ${rowid}    Users_Fields 