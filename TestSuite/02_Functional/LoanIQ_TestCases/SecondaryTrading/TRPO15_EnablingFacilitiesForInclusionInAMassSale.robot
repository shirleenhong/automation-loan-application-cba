*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1    
${ExcelPath}    C:\\fms_scotia\\DataSet\\StandAlone_DataSet\\TRPO15_EnablingMassSale.xlsx

*** Test Cases ***

TRPO15_Enabling Facilities For Inclusion In a MassSale
    [Tags]    Inclusion In a MassSale in LIQ   
    Mx Execute Template With Multiple Data    Enable MassSale    ${ExcelPath}    ${rowid}    TRPO15_EnablingMassSale