*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG03_CREATE
    [Documentation]    This testcase is used to Verify that user is NOT allowed to CREATE if field is null for Mandatory 
    ...    on userID, jobTitle, firstName, surname, countryCode, roles, status
    ...    author:    jloretiz    12DEC2019    - initial create
    
    ${rowid}    Set Variable    4301
    Mx Execute Template With Multiple Data    CREATE User with Null Mandatory Fields    ${APIDataSet}    ${rowid}    Users_Fields

API_SSO_NEG03_UPDATE
    [Documentation]    This testcase is used to Verify that user is NOT allowed to UPDATE if field is null for Mandatory 
    ...    on userID, jobTitle, firstName, surname, countryCode, roles, status
    ...    author:    jloretiz    12DEC2019    - initial create
    
    ${rowid}    Set Variable    4302
    Mx Execute Template With Multiple Data    UPDATE User with Null Mandatory Fields    ${APIDataSet}    ${rowid}    Users_Fields