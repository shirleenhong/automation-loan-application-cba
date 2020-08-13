*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_CAL_16
    [Documentation]    Send a single update file from the previous file sent (i.e. update in Event Name) and verify if update will be processed successfully.
    ...    Manual change of XLS files - have 1 file from set 1 files to have the same data except for 1 difference on Event Name.
    ...    @author: clanding    01AUG2019    - initial create
    
    Set Global Variable    ${rowid}    161    ### Create File
    Mx Execute Template With Multiple Data    Send Valid Copp Clark Files without Validation    ${ExcelPath}    ${rowid}    Calendar_Fields
    
    Set Global Variable    ${rowid}    162    ### Update File
    Mx Execute Template With Multiple Data    Send a Single Update File    ${ExcelPath}    ${rowid}    Calendar_Fields
