*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
API_SSO_CRE13
    [Documentation]    This Test Case is used to create user using Demographic Fields only without contactNumber2 and verify that User is created in AD without contactNumber2 and SSO is created
    ...    @author: xmiranda    25JUL2019    - initial create

    
    ${rowid}    Set Variable    15
    Mx Execute Template With Multiple Data    Create User Using Demographic Fields only without Contact Number 2    ${APIDataSet}    ${rowid}    Users_Fields