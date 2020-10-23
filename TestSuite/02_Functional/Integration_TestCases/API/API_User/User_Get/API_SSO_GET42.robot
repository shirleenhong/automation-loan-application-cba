*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET42
    [Documentation]    This Testcase is used to verify that an error will occur if the User GET API
    ...    has an invalid LoginID as part of the endpoint
    ...    @author: jloretiz    13JAN2020    - initial create

    ${rowid}    Set Variable    5042
    Mx Execute Template With Multiple Data    GET User API with Invalid LoginID    ${APIDataSet}    ${rowid}    Users_Fields