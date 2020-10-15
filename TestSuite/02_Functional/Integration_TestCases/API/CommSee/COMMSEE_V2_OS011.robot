**** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    107

*** Test Case ***


Verify Loan Outstanding for Zero Cycle Due - Overpayment
     [Documentation]    This ComSee test case verify Loan overPayment transaction. 
     ...    Pre-requisite: COMMSEE_V2_OS004 and  validates GET API for the updated values. 
     ...    author: sacuisia    02OCT2020
     
      Mx Execute Template with Multiple Data    Pay Loan Outstanding Accrual Zero Cycle Due    ${ComSeeDataSet}     ${rowid}    ComSee_SC2_Loan
      Mx Execute Template with Multiple Data    Get and Validate API Outstanding Response   ${ComSeeDataSet}    ${rowid}    ComSee_SC2_Loan