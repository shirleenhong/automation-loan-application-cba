*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_CAL_17
    [Documentation]    Send same file (content and file name) from the previous file sent with no changes and verify that file will not be processed 
    ...    and verification is up until logs only.
    ...    @author: clanding    05AUG2019    - initial create
    
    Set Global Variable    ${rowid}    17
    Mx Execute Template With Multiple Data    Send Valid Copp Clark Files without Validation    ${ExcelPath}    ${rowid}    Calendar_Fields
    Mx Execute Template With Multiple Data    Send Copp Clark Files with No Changes in Holiday    ${ExcelPath}    ${rowid}    Calendar_Fields
