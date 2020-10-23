*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_DEL07
    [Documentation]    This test case is used to validate that user is able to delete risk book via UI (Loan IQ).
    ...    @author: dahijara    17SEP2019    - initial create

    ${rowid}    Set Variable    307
    Mx Execute Template With Multiple Data    Delete Risk Book Via UI-LIQ    ${APIDataSet}    ${rowid}    Riskbook