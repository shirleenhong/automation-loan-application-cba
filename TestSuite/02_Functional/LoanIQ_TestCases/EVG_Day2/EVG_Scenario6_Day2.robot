*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    6

*** Test Cases ***
EVGLIQ_PAY_CRE01_Loan Paper Clip Repayment_SERV23
    [Documentation]    This keyword is used to do paper clip payment for fixed loan.
    ...    @author: rtarayao
    [Tags]    07 Perform Loan Repayment Paper Clip - PAY_CRE01
    Mx Execute Template With Multiple Data    Initiate Repayment Paper Clip for Bilateral Deal    ${ExcelPath}    ${rowid}    SERV23_LoanPaperClip

EVGLIQ_PAY_CRE04_OngoingFeePayment_SERV29 - Bilateral Deal with Multiple Risk Types
    [Documentation]    This testcase will perform Ongoing Fee Payment on Bilateral Deal with Multiple Risk Types.
    ...    @author: fmamaril  
    [Tags]    08 Perform Ongoing Fee Payment - PAY_CRE04
    Mx Execute Template With Multiple Data    Update Commitment Fee Cycle    ${ExcelPath}    1-2    SERV29_PaymentFees
    Log    Execution is paused. Need to run EoD.    
    Pause Execution
    Mx Execute Template With Multiple Data    Pay Commitment Fee Amount    ${ExcelPath}    1-2    SERV29_PaymentFees   
   
    
EVGLIQ_PAY_CRE02_ManualSchedulePrincipalPayment_SERV18 - Deal with Multiple Risk Type
    [Documentation]    This testcase will perform Manual Scheduled Principal Payment on Bilateral Deal.
    ...    @author: fmamaril
    [Tags]    09 Perform Loan Repayment Paper Clip - PAY_CRE02     
    Mx Execute Template With Multiple Data    Manual Schedule Principal Payment -Bilateral Deal with Multiple Risk    ${ExcelPath}    ${rowid}    SERV18_Payments 
    
EVGLIQ_PTRF_CRE01 - User is able to create a PORTFOLIO TRANSFER
    [Documentation]    This test suite will create a portfolio transfer for Scenario 6
    ...    @author: mnanquilada
    [Tags]    10 Perform Portfolio Transfer - PTRF_CRE01
    Mx Execute Template With Multiple Data    Portfolio Transfer    ${ExcelPath}    ${rowID}    PTRF_CRE01_PortfolioTransfer
    
Cycle Share Adjustment for Fee Accrual - Commitment Fee
    [Documentation]    This keyword is used to do a cycle share adjustment for fee accrual in Commitment Fee Notebook.
    [Tags]    11 Perform Fee Accrual for Commitment Fee - ADJ_ACC01
    Mx Execute Template With Multiple Data    Create Cycle Share Adjustment for Fee Accrual    ${ExcelPath}    ${rowid}    MTAM06B_CycleShareAdjustment
        
Cycle Share Adjustment for Fee Accrual
    [Documentation]    This keyword is used to do a cycle share adjustment for fee accrual-Payment Reversal. 
    [Tags]    12 Perform Reversal of Ongoing Fee Payment - ADJ_REV01  
    Mx Execute Template With Multiple Data    Create Cycle Share Adjustment for Fee Accrual- Payment Reversal    ${ExcelPath}    ${rowid}    MTAM05B_CycleShareAdjustment
