*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Validate GL Application Column in Party Database
    [Documentation]    This test case is used to validate if only COMRLENDING and PARTY are available in GL Application Column of Party Database. 
    ...    @author: javinzon    29OCT2020    - initial create
    [Arguments]    ${ExcelPath}    
    
    Validate GL Application Column in GLTB_CROSSREFERENCE table if Correct    &{ExcelPath}[Party_ID]    &{ExcelPath}[Valid_GLApplication]
     