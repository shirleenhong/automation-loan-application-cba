*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    5

*** Test Cases ***
Ongoing Fee Payment for Bilateral Deal - SERV29
    [Tags]    06 Update and Pay the Commitment Fee - SERV29   
    Mx Execute Template With Multiple Data    Pay Commitment Fee Amount - Syndicated with Secondary Sale    ${ExcelPath}    ${rowid}    SERV29_PaymentFees

### Start of Day 3 ###
Create Agency Fee Payment - CRED11
    [Tags]    07 Create Agency Fee Payment - CRED11
    Mx Execute Template With Multiple Data    Admin Fee Payment for Secondary Sale    ${ExcelPath}    ${rowid}    SERV30_AdminFeePayment 

Create Secondary Sale for Agency - TRP002
    [Tags]    08 Create a Secondary Sale for Loan and Commitment Fee Payment - TRP002
    Mx Execute Template With Multiple Data    Set up Secondary Sale for Agency    ${ExcelPath}    ${rowid}    TRP002_SecondarySale

Create Loan Share Adjustment - MTAM08
    [Tags]    09 Create Share Adjustment for a Loan within Lenders - MTAM08
    Mx Execute Template With Multiple Data    Loan Share Adjustment   ${ExcelPath}    ${rowid}    MTAM08_LoanShareAdjustment        

Create Term Loan Drawdown for Syndicated Deal in USD - SERV01
    [Tags]    10 Create Term Loan Drawdown for SYNDICATED deal in USD - SERV01
    Mx Execute Template With Multiple Data    Create Term Loan Drawdown for SYNDICATED deal in USD    ${ExcelPath}    ${rowid}    SERV01_TermLoanDrawdowninUSD
### End of Day 3 ###  
