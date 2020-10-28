*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_CRE24
    [Documentation]    This testcase is used to create user per LOB (LIQ, Essence, Party) using valid minimum field lengths.
    ...    And validate that the user is successfully created for each LOBs.
    ...    @author: dahijara    26JUL2019    - Initial Create
    
    ${rowid}    Set Variable    241
    Mx Execute Template With Multiple Data    Create User for LIQ with Valid Minimum Fields    ${APIDataSet}    ${rowid}    Users_Fields
  
    ${rowid}    Set Variable    242
    Mx Execute Template With Multiple Data    Create User for Essence with Valid Minimum Fields    ${APIDataSet}    ${rowid}    Users_Fields

    ${rowid}    Set Variable    243
    Mx Execute Template With Multiple Data    Create User for Party with Valid Minimum Fields    ${APIDataSet}    ${rowid}    Users_Fields