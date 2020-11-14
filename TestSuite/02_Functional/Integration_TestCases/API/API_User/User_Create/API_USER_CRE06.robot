*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
API_SSO_CRE06
    [Documentation]    This keyword is used to verify that user for multiple LOB (LIQ, Essence, Party) using same request
    ...    with no configuration in the property file.
    ...    @author: clanding    22APR2019    - initial create
    
    ${rowid_LIQ}    Set Variable    6
    Mx Execute Template With Multiple Data    Create User for Multiple LOB with No Configuration    ${APIDataSet}    ${rowid_LIQ}    Users_Fields