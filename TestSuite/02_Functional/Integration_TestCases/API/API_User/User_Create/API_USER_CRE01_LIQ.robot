*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_CRE01
    [Documentation]    This testcase is used to verify that user is able to This keyword is used to create User with Single LOB with ACTIVE status and LOCKED.
    ...    @author: clanding
    ...    @update: clanding    05APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    
    ${rowid}    Set Variable    1
    Set Global Variable    ${rowid}
    Mx Execute Template With Multiple Data    Create User for Single LOB with ACTIVE Status and UNLOCKED    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowID_Audit}    Set Variable    4
    Set Global Variable    ${rowID_Audit}
    Log    Waiting for Audit Log to reflect. Wait Time: 1 min
    Sleep    1m    #audit file is reflected in audit log every 5 mins
    Mx Execute Template With Multiple Data    API_LOG01_SSO01    ${APIDataSet}    ${rowID_Audit}    Audit_Log
    
    ${rowid}    Set Variable    1
    Set Global Variable    ${rowid}
    Mx Execute Template With Multiple Data    AUDIT_LOG_USER_SSO    ${APIDataSet}    ${rowid}    Users_Fields