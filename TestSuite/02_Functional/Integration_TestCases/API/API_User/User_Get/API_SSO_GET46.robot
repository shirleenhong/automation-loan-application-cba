*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET46
    [Documentation]    This test case is used to get All Users with invalid offset value - Response 404
    ...    @author: xmiranda    29OCT2019    - initial create

    ${rowid}    Set Variable    5046
    Mx Execute Template With Multiple Data    Get All Users with Invalid Offset Value    ${APIDataSet}    ${rowid}    Users_Fields