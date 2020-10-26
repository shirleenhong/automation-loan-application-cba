*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_UPD06
    [Documentation]    This test case is used to validate that user is able to Update a new Riskbook created via UI using Login Id
    ...    @author: dahijara    12SEP2019    - initial create

    ${rowid}    Set Variable    206
    Mx Execute Template With Multiple Data    Update New Riskbook Created Via UI Using Login ID    ${APIDataSet}    ${rowid}    Riskbook