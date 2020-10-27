*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_DEL08
    [Documentation]    This test case is used to validate that User is unable to delete using an Invalid User ID - Response 404.
    ...    @author: dahijara    23OCT2019    - initial create

    ${rowid}    Set Variable    308
    Mx Execute Template With Multiple Data    Delete Risk Book Using an Invalid User ID    ${APIDataSet}    ${rowid}    Riskbook