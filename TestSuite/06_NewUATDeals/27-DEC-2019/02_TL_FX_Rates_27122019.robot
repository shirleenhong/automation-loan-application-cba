*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    1

*** Test Cases ***
Load FX Rate to Sydney Funding Desk 
    [Tags]    01 Load FX Rates
    Set Global Variable    ${rowid}    1
    Mx Execute Template With Multiple Data    Load FX Rates to Funding Desks for UAT Deals    ${NEWUAT_TL_DATASET}    ${rowid}    FXRates_Fields