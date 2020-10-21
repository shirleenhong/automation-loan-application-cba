*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG37_DELETE
    [Documentation]    This Testcase is used to verify that when deleting multiple LOB while LIQ User Profile is displayed
    ...    will only delete the Party and Essence User.
    ...    and will not delete AD and SSO since LIQ is still active.
    ...    Then verify that SSO and LIQ can still be GET with API.
    ...    @author: jloretiz    21JAN2020    - initial create
    
    ${rowid}    Set Variable    43701
    Mx Execute Template With Multiple Data    Create User with Multiple LOBs without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields

    ${rowid}    Set Variable    43702
    Mx Execute Template With Multiple Data    DELETE User API with Multiple LOB    ${APIDataSet}    ${rowid}    Users_Fields