*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_DEL17
    [Documentation]    This test case is used to validate that user is able to delete risk book that is added via GUI using login Id and response is 200
    ...    @author: dahijara    17SEP2019    - initial create

    ${rowid}    Set Variable    317
    Mx Execute Template With Multiple Data    Delete Risk Book Added Via GUI Using Login Id    ${APIDataSet}    ${rowid}    Riskbook