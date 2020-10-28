*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET45
    [Documentation]    This test case is used to get Single User with invalid DataSource - Response 400
    ...    @author: xmiranda    29OCT2019    - initial create

    ${rowid}    Set Variable    5045
    Mx Execute Template With Multiple Data    Get Single User with Invalid DataSource Value    ${APIDataSet}    ${rowid}    Users_Fields