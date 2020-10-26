*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG28_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE if Status is invalid.
    ...    @author: jloretiz    13JAN2020    - initial create
    
    ${rowid}    Set Variable    42801
    Mx Execute Template With Multiple Data    CREATE User API with Invalid Status    ${APIDataSet}    ${rowid}    Users_Fields
    
API_SSO_NEG28_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE if Status is invalid. 
    ...    @author: jloretiz    13JAN2020    - initial create
    
    ${rowid}    Set Variable    42802    
    Mx Execute Template With Multiple Data    UPDATE User API with Invalid Status    ${APIDataSet}    ${rowid}    Users_Fields