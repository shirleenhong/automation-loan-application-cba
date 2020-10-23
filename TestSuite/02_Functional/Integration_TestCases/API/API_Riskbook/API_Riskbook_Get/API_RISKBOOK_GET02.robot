*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_GET02
    [Documentation]    This test case is used to verify that user is able to get an empty response for User Id with no riskbooks 
    ...    @author: xmiranda    05SEP2019    - initial create

    ${rowid}    Set Variable    2
    Mx Execute Template With Multiple Data    Validate Riskbook User with Empty Response    ${APIDataSet}    ${rowid}    Riskbook