*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
Create Syndicated Deal for LLA Syndicated Deal - CRED01
    Mx Execute Template With Multiple Data    Setup Syndicated Deal for PT Health Syndicated    ${ExcelPath}    ${rowid}    CRED01_DealSetup