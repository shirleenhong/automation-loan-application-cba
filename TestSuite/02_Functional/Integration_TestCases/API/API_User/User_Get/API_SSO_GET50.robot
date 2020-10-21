*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET50
    [Documentation]    This test case is used to use Other Methods on Get API Endpoints - Response 405
    ...    @author: xmiranda    06NOV2019    - initial create

    ${rowid}    Set Variable    5050
    Mx Execute Template With Multiple Data    Use Other Methods on Get API Endpoints    ${APIDataSet}    ${rowid}    Users_Fields