*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_CRE25
    [Documentation]    This keyword is used to verify that user is created in different Line Of Business (LIQ, Party and Essence)
    ...    with valid and maximum field lengths.
    ...    @author: jloretiz    30JUL2019    - initial create
    
    ${rowid_ess}    Set Variable    252
    Mx Execute Template With Multiple Data    Create User for Essence with Valid and Maximum Field Length      ${APIDataSet}    ${rowid_ess}    Users_Fields
    
    ${rowid_par}    Set Variable    253
    Mx Execute Template With Multiple Data    Create User for Party with Valid and Maximum Field Length        ${APIDataSet}    ${rowid_par}    Users_Fields
    
    ${rowid_liq}    Set Variable    251
    Mx Execute Template With Multiple Data    Create User for LIQ with Valid and Maximum Field Length  	       ${APIDataSet}    ${rowid_liq}    Users_Fields