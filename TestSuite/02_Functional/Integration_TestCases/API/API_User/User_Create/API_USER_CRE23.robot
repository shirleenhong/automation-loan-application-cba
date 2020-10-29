*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
API_SSO_CRE23
    [Documentation]    Create User using Demporaphic Fields only with maximum field lengths with valid fields and verify user is created in AD and SSO
    ...    @author: xmiranda    29JUL2019    - initial create

    
    ${rowid}    Set Variable    23
    Mx Execute Template With Multiple Data    Create User Using Demographic Fields only with Maximum Field Lengths with Valid Inputs    ${APIDataSet}    ${rowid}    Users_Fields