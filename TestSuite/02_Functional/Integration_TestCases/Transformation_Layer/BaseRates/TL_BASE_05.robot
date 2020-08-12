*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_05
    [Documentation]    Send Golden Source File to SFTP with rate of more than 6 decimal places.
    ...    Transformation Layer will automatically round off after the 6th decimal place.
    ...    @author: clanding    11MAR2019    - initial create
    
    Set Global Variable    ${rowid}    5
    Mx Execute Template With Multiple Data    Send Golden Source File with Rate of More Than 6 Decimal Places    ${ExcelPath}    ${rowid}    BaseRate_Fields
