*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_CRE09
    [Documentation]    This testcase is used to verify that user is created with single LOB and INACTIVE status and UNLOCKED for LIQ.
    ...    @author: clanding    15APR2019    - initial create
    
    ${rowid}    Set Variable    9
    Mx Execute Template With Multiple Data    Create User for Single LOB with INACTIVE Status and UNLOCKED    ${APIDataSet}    ${rowid}    Users_Fields