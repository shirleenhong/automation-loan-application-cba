*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_CRE08
    [Documentation]    This testcase is used to verify that user is created with single LOB and ACTIVE status and LOCKED for LIQ.
    ...    @author: clanding    15APR2019    - initial create
    
    ${rowid}    Set Variable    8
    Mx Execute Template With Multiple Data    Create User for Single LOB with ACTIVE Status and LOCKED    ${APIDataSet}    ${rowid}    Users_Fields