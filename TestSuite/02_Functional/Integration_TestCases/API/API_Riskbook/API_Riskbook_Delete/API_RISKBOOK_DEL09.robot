*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_DEL09
    [Documentation]    This test case is used to validate that User is unable to delete using an Invalid Login ID - Response 404.
    ...    @author: dahijara    23OCT2019    - initial create

    ${rowid}    Set Variable    309
    Mx Execute Template With Multiple Data    Delete Risk Book Using an Invalid Login ID    ${APIDataSet}    ${rowid}    Riskbook