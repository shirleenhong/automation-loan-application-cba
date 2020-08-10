*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***

SERV46 - Reschedule A Temporary Payment Plan
    [Tags]    Reschedule Temporary Payment Plan - SERV46
    Mx Execute Template With Multiple Data    Reschedule a Temporary Payment Plan    ${ExcelPath}    ${rowid}    SERV46_ReschTempPaymentPlan