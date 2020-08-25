*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
 
*** Test Cases ***
TL_FXRATES_33
    [Documentation]     Send GS file with base and target currency equals to USD.
    ...    @author: dahijara    19FEB2010    - initial create

    Set Global Variable    ${rowid}    33
    Mx Execute Template With Multiple Data    Send GS file with Base and Target Currency Equals to USD    ${ExcelPath}    ${rowid}    FXRates_Fields
    
   
