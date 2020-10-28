*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_CRE05
    [Documentation]    This keyword is used to verify that user is able to create user for multiple Line Of Business (LIQ, Party and Essence).
    ...    @author: clanding
    
    ${rowid_LIQ}    Set Variable    5
    Mx Execute Template With Multiple Data    Create User for Multiple LOB    ${APIDataSet}    ${rowid_LIQ}    Users_Fields