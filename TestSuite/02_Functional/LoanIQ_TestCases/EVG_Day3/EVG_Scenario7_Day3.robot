*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    7

*** Test Cases ***
Terminate Facility - SERV35
    [Documentation]    This keyword is used to terminate a facility
    ...    There is a 1-day Batch EoD run inside the script
    [Tags]    08 Terminate Facility - AMCH02
    Mx Execute Template With Multiple Data    Terminate Facility - Change Expiry and Maturity Date    ${ExcelPath}    ${rowid}    SERV35_Terminate_FacilityDeal
    
Terminate Deal - SERV35
    [Documentation]    This keyword is used to terminate a deal
    [Tags]    09 Terminate Deal - AMCH02
    Mx Execute Template With Multiple Data    Terminate Deal    ${ExcelPath}    ${rowid}    SERV35_Terminate_FacilityDeal     
