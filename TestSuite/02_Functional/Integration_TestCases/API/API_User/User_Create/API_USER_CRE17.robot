*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
API_SSO_CRE13
    [Documentation]    Create User using Demographic Fields only with minimum field lengths and no error in CCB
    ...    @author: xmiranda    26JUL2019
   
    ${rowid}    Set Variable    17
    Mx Execute Template With Multiple Data    Create User Using Demographic Fields only with Minimum Field Lengths    ${APIDataSet}    ${rowid}    Users_Fields