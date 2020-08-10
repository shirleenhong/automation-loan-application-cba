*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1  
${ExcelPath}    C:\\fms_scotia\\DataSet\\LoanIQ_DataSet\\Miscellaneous\\SERV05_SBLCIssuance.xlsx

*** Test Cases ***

SBLC Issuance
    [Tags]    04 SBLC Issuance - SERV05 
    Mx Execute Template With Multiple Data    SBLC Guarantee Issuance    ${ExcelPath}    ${rowid}    SERV05_SBLCIssuance
    
SBLC Guarantee Issuance with Multiple Risk Types for Bilateral Deal
    [Tags]    05 Create SBLC Guarantee - DRAW_CRE01
    Mx Execute Template With Multiple Data    SBLC Guarantee Issuance for Bilateral Deal with Multiple Risk Types    ${ExcelPath}   ${rowid}    SERV05_SBLCIssuance    