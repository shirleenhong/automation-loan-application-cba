*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1    
${ExcelPath}    C:\\fms_scotia\\DataSet\\StandAlone_DataSet\\TRPO13_PortfolioTradeDateDiscountChange.xlsx

*** Test Cases ***

Portfolio Trade Date Discount Change - TRPO13
    [Tags]    Inclusion In a MassSale in LIQ   
    Mx Execute Template With Multiple Data    Portfolio Trade Date Discount Change    ${ExcelPath}    ${rowid}    TRPO13_PortfolioTradeDiscChange