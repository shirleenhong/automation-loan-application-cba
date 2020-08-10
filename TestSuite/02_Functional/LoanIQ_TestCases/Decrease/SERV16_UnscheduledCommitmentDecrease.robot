*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1    
${ExcelPath}    C:\\fms_scotia\\DataSet\\StandAlone_DataSet\\SERV16_UnscheduledComittmentDecrease.xlsx

*** Test Cases ***

Unscheduled Commitment Decrease - SERV16
    [Tags]    Unscheduled Commitment Decrease in LIQ 
    ####As a pre-requisite Test Case Dealsetup TC of Scenario1 is executed and then before Release of the Unscheduled Commitment Transaction the Deal needs to be closed###  
    Mx Execute Template With Multiple Data    Unscheduled Commitment Decrease    ${ExcelPath}    ${rowid}    SERV16_UnSchComittmentDecrease