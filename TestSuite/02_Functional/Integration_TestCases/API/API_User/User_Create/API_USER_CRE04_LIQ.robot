*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_CRE04
    [Documentation]    This keyword is used to verify that user is able to CREATE a user for single LOB (LIQ) with INACTIVE status and LOCKED.
    ...    @author: clanding
    
    ${rowid}    Set Variable    4
    Mx Execute Template With Multiple Data    Create User for Single LOB with INACTIVE Status and LOCKED    ${APIDataSet}    ${rowid}    Users_Fields