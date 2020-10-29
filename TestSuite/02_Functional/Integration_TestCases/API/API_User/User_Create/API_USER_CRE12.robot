*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_CRE12
    [Documentation]    This test case is used to verify that user is able to create user for multiple Line Of Business (LIQ, Party and Essence)
    ...    without centraUser and userType.
    ...    @author: jloretiz    19JUL2019    - initial create
    
    ${rowid_mul}    Set Variable    12
    Mx Execute Template With Multiple Data    Create User for Multiple LOB with No CentralUserType and UserType    ${APIDataSet}    ${rowid_mul}    Users_Fields