*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_31
    [Documentation]    Send GS File (Any group) with GS_PROCESSING_DATE greater than LIQ business date and verify that GS_VENDOR_PUBLISH_DATE is still processed
    ...    @author: jdelacru    23AUG2019    - initial create
    
    Set Global Variable    ${rowid}    31
    Mx Execute Template With Multiple Data    Send GS File where Processing Date is Greater than LIQ Date and verify if Publish Date is still Processed    ${ExcelPath}    ${rowid}    BaseRate_Fields   
