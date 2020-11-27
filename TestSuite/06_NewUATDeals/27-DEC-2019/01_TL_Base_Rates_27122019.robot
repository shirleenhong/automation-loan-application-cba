*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot
*** Variables ***
${rowid}    1

*** Test Cases ***
Load Base Rate 
    Mx Execute Template With Multiple Data    Send a Valid GS File for Base Rates    ${NEWUAT_TL_DATASET}    1   BaseRate_Fields