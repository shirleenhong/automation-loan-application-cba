*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_GET07
    [Documentation]    This test case is used to verify that user is able to get RiskBook Collection for a newly created RiskBook code using User Id
    ...    @author: xmiranda    19SEP2019    - initial create

    ${rowid}    Set Variable    7
    Mx Execute Template With Multiple Data    Add New Risk Book and Validate Risk Book Collection     ${APIDataSet}    ${rowid}    Riskbook