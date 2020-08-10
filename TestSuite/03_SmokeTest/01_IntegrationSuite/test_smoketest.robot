*** Settings ***
Library    GenericLib
Resource    ../03_Functional/01_test_PTY001.robot
Resource    ../04_Upstream/01_test_TL_BASE_01.robot
Resource    ../04_Upstream/01_test_TL_CAL_01.robot

*** Variable ***
${ExcelPath}    ..\\CBA_Evergreen\\TestSuite\\05_SmokeTest\\07_Configurations\\config_generic.py
${rowid}    1

*** Test Cases ***
Send a Valid Base Rates GS File - TL_BASE01
    [Tags]    Send a Valid Base Rates GS File - TL_BASE01
    Set Global Variable    ${rowid}    1
    Mx Execute Template With Multiple Data    Send a Valid Base Rates GS File    ${ExcelPath}    ${rowid}    BaseRate_Fields

Send Valid Calendar Copp Clark Files - TL_CAL01
     [Tags]    Send Valid Calendar Copp Clark Files - TL_CAL01
    Set Global Variable    ${rowid}    1
    Mx Execute Template With Multiple Data    Send Valid Calendar Copp Clark Files    ${ExcelPath}    ${rowid}    Calendar_Fields

Quick Party Onboarding
    [Tags]    Create Customer in Party
    Mx Execute Template With Multiple Data    Quick Party Onboarding    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    
Complete Borrower Profile
    [Tags]    Complete Borrower Profile in LIQ
    Mx Execute Template With Multiple Data    Complete Borrower Profile    ${ExcelPath}    ${rowid}    ORIG03_Customer