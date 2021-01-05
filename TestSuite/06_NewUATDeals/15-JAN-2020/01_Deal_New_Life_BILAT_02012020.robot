*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***

Add False Condition for New Life Bilateral Deal Effective at 15JAN2020
    Mx Execute Template With Multiple Data    Add False Outside Condition Deal Change    ${CBAUAT_ExcelPath}    ${rowid}    CRED01_DealSetup
   
