*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
    
${ExcelPath}    C:\\fms_scotia\\DataSet\\LoanIQ_DataSet\\Miscellaneous\\AMCH01_DealAmendment.xlsx


*** Test Cases ***

Deal Amendment
    [Tags]    02 Pending Deal amendment in LIQ   
    Mx Execute Template With Multiple Data    Deal Amendment    ${ExcelPath}    ${rowid}    AMCH01_DealAmendment