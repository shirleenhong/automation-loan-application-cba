*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
API_SSO_CRE13
        [Documentation]    This Test Case is used to create user using Demographic Fields only and verify that user is created in AD and SSO
    ...    @author: xmiranda    22JUL2019
    ...    @update: xmiranda    23JUL2019    - revisions made based on the review points given by clanding and jdelacru (20190722 - GDE-3263 - CRE13 - USERAPI.xlsx)
    ...    @update: xmiranda    24JUL2019    - revisions made based on the review points given by clanding and jdelacru (20190724 - GDE-3263 - CRE13 - USERAPI.xlsx)
    
    ${rowid}    Set Variable    13
    Mx Execute Template With Multiple Data    Create User Using Demographic Fields Only    ${APIDataSet}    ${rowid}    Users_Fields