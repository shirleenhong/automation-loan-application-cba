*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***

Portfolio Settled Discount Change - TRPO12
    [Tags]    Adjustment to Balance of Discount / Premium on settled Portfolio Position   
    Mx Execute Template With Multiple Data    Portfolio Settled Discount Changes    ${ExcelPath}    ${rowid}    TRPO12_PortfolioPositions