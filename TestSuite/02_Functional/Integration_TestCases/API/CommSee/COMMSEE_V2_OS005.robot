**** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    3

*** Test Case ***


Verify Loan Outstanding for Zero Cycle Due and Accrual, PaidToDate
     [Documentation]    This ComSee test case verify paidtodate set to 0  
     ...    and verify paid to date values after EOD and Payment transaction
     ...    this also validates GET API for the updated values. pre-requisite for OS004 - Outsanding and verify Cycledue
     ...    author: sacuisia    02OCT2020

      Mx Execute Template with Multiple Data    Write Loan Outstanding Accrual Zero Cycle Due    ${ComSeeDataSet}     ${rowid}    ComSee_SC2_Loan
      Mx Execute Template with Multiple Data    Get and Validate API Outstanding Response   ${ComSeeDataSet}    ${rowid}    ComSee_SC2_Loan