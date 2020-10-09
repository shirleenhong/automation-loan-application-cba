*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
 
*** Test Cases ***
TL_FXRATES_33
    [Documentation]     Send GS file with base and target currency equals to USD.
    ...    @author: dahijara    19FEB2010    - initial create
    ...    @update: clanding    01OCT0202    - changed ${ExcelPath} to ${TL_DATASET}

    Set Global Variable    ${rowid}    33
    Mx Execute Template With Multiple Data    Send GS file with Base and Target Currency Equals to USD    ${TL_DATASET}    ${rowid}    FXRates_Fields
    
   
