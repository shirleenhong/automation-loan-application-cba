*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOKS_UPD02
    [Documentation]    This test case is used to validate that user is able to update an existing risk book using User Id and response is 200
    ...    @author: dahijara    4SEP2019    - initial create

    ${rowid}    Set Variable    202
    Mx Execute Template With Multiple Data    Update an Existing Risk Book Using Login ID    ${APIDataSet}    ${rowid}    Riskbook