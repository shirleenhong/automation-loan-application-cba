*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_19
    [Documentation]    Send GS File with removed Floating Rates (i.e. LIBOR-USD-BID) and verify if reflected in LoanIQ.
    ...    @author: jdelacru    22JUL2019    - initial create
    
    Set Global Variable    ${rowid}    19
    Mx Execute Template With Multiple Data    Send GS File with removed Floating Rates    ${ExcelPath}    ${rowid}    BaseRate_Fields
