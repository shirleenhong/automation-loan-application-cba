*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_26
    [Documentation]    Send GS File with ALL record have GS_VENDOR_PUBLISH_DATE greater than LIQ business date.
    ...    @author: jdelacru    14AUG2019    - initial create
    
    Set Global Variable    ${rowid}    26
    Mx Execute Template With Multiple Data    Send GS File Where All Publish Date are Greater Than LIQ Business Date    ${ExcelPath}    ${rowid}    BaseRate_Fields   
