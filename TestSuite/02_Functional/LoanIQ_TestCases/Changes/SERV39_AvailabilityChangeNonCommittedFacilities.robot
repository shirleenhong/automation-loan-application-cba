*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1


*** Test Cases ***

Availability Change - Non Committed Facilities - SERV39
    [Tags]    01 Availability Change For Non Committed Facilities in LIQ   
    Mx Execute Template With Multiple Data    Availability Change for Non Committed Facilities    ${ExcelPath}    ${rowid}    SERV39_AvailabilityChange