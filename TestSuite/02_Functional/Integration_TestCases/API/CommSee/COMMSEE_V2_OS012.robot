**** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    108

*** Test Case ***


Verify Loan Outstanding Loan Outstanding - Manual Adjustment Transaction
     [Documentation]    This ComSee test case verify Loan overPayment transaction. 
     ...    Pre-requisite: COMMSEE_V2_OS004 and  validates GET API for the updated values. 
     ...    author: sacuisia    16OCT2020
     
      Mx Execute Template with Multiple Data    Pay Loan Outstanding Accrual Zero Cycle Due    ${ComSeeDataSet}     ${rowid}    ComSee_SC2_Loan
      Mx Execute Template with Multiple Data    Validate Payment Manual Adjustment Transaction    ${ComSeeDataSet}     ${rowid}    ComSee_SC2_Loan 
      Mx Execute Template with Multiple Data    Get and Validate API Outstanding Response   ${ComSeeDataSet}    ${rowid}    ComSee_SC2_Loan
      