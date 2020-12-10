*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot
*** Variables ***
${rowid}    1-6

*** Test Cases ***
Load Base Rate 
    Mx Execute Template With Multiple Data    Load Base Rate for UAT Deal    ${NEWUAT_TL_DATASET}    ${rowid}    BaseRate_Fields