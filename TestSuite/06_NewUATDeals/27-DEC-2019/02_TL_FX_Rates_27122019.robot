*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    1

*** Test Cases ***
Load FX Rate To Sydney Funding Desk 
    [Tags]    01 Load FX Rates
    Set Global Variable    ${rowid}    1
    Mx Execute Template With Multiple Data    Load FX Rates To Funding Desks    ${NEWUAT_TL_DATASET}    ${rowid}    FXRates_Fields