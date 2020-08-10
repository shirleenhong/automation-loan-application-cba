*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    5

*** Test Cases ***
Create Comprehensive Repricing - SERV08
    [Tags]    05 Create a Comprehensive Repricing of a Loan apart of Interest Payment - SERV08 & SERV21
    Mx Execute Template With Multiple Data    Create Comprehensive Repricing for Syndicated Deal - Secondary Sale    ${ExcelPath}    ${rowid}    SERV08C_ComprehensiveRepricing

Ongoing Fee Payment for Bilateral Deal - SERV29
    [Tags]    06 Update and Pay the Commitment Fee - SERV29
    Mx Execute Template With Multiple Data    Update Commitment Fee Cycle    ${ExcelPath}    ${rowid}    SERV29_PaymentFees   
    Pause Execution    
