*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_CRE14
    [Documentation]    This testcase is used to validate user creation using demographic fields only without locale 
    ...    and verify that User is created in SSO and locale is defaulted to EN
    ...    @author: dahijara    26JUL2019    - Initial Create
    
    ${rowid}    Set Variable    14
    Mx Execute Template With Multiple Data    Create User Using Demporaphic Fields Only Without Locale    ${APIDataSet}    ${rowid}    Users_Fields