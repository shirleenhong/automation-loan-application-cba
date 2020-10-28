*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG36_DELETE
    [Documentation]    This Testcase is used to Verify that an error will occur
    ...    if the loginId in the endpoint of Delete User does not meet the required number of characters.
    ...    @author: jloretiz    17JAN2020    - initial create
    
    ${rowid}    Set Variable    43601
    Mx Execute Template With Multiple Data    DELETE User API with Incorrect URL    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable    43602
    Mx Execute Template With Multiple Data    DELETE User API with Incorrect URL    ${APIDataSet}    ${rowid}    Users_Fields