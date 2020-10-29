*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_UPD05
    [Documentation]    This test case is used to validate that user is able to Update a new Riskbook created via UI using User Id
    ...    @author: dahijara    12SEP2019    - initial create

    ${rowid}    Set Variable    205
    Mx Execute Template With Multiple Data    Update New Riskbook Created Via UI Using User ID    ${APIDataSet}    ${rowid}    Riskbook