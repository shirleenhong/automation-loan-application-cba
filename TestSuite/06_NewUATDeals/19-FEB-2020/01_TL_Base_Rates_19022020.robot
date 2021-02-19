*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    23

*** Test Cases ***
Load Base Rate 
    [Tags]    01 Load Base Rates
    Mx Execute Template With Multiple Data    Load Base Rate for UAT Deal    ${NEWUAT_TL_DATASET}    ${rowid}    BaseRate_Fields