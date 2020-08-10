*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    1

*** Test Cases ***

Setup Caps and Floors - SERV14
    [Tags]    Create Temporary Payment Plan - SERV45
    Mx Execute Template With Multiple Data    Setup Caps and Floors    ${ExcelPath}    ${rowid}    SERV14_CapsAndFloorsSetup