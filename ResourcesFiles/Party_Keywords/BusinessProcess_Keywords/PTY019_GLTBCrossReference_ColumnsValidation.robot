*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Validate Columns of GLTB_CROSSREFERENCE Table in GLOBALCBS Schema
    [Documentation]    This test case is used to validate values of the following columns in GLTB_CROSSREFENCE Table of GLOBALCBS Schema:
    ...    GLREFERNCEID, GLACTIVATED, GLSTATUS, GLENTITY
    ...    @author: javinzon    13NOV2020    - initial create
    [Arguments]    ${ExcelPath}    
    
    Validate Columns in GLTB_CROSSREFERENCE Table if Correct    &{ExcelPath}[Party_ID]    &{ExcelPath}[Default_GLActivated]    &{ExcelPath}[Default_GLStatus]    &{ExcelPath}[Expected_Entity]   