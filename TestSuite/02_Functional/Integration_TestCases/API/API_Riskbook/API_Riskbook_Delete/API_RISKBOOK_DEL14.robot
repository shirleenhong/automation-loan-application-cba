*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_DEL14
    [Documentation]    This test case is used to validate that user is able to delete risk book that is added via API using user Id and response is 200
    ...    @author: dahijara    16SEP2019    - initial create

    ${rowid}    Set Variable    314
    Mx Execute Template With Multiple Data    Delete Risk Book Added Via API Using User Id    ${APIDataSet}    ${rowid}    Riskbook