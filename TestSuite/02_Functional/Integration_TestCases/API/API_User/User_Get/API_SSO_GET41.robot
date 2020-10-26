*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET41
    [Documentation]    This Testcase is used to verify that an error will occur if the User GET API
    ...    has an invalid LOB as part of the endpoint
    ...    @author: jloretiz    13JAN2020    - initial create

    ${rowid}    Set Variable    5041
    Mx Execute Template With Multiple Data    GET User API with Invalid LOB on Endpoint    ${APIDataSet}    ${rowid}    Users_Fields