**** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    3

*** Test Case ***


Verify Loan Outstanding for Zero Cycle Due and Accrual, PaidToDate
     [Documentation]    This ComSee test case verify paidtodate set to 0  
     ...    and verify paid to date values after EOD and Payment transaction
     ...    this also validates GET API for the updated values. 
     ...    
     ...    Pre-requisite: 
     ...    1. Run COMMSEE_V2_OS004
     ...    2. Run 1 month EOD (or duration depends on specified frequency)
     ...    
     ...    author: sacuisia    02OCT2020
     ...    update: shirhong    16NOV2020    - Updated the first test case keyword from 'Write Loan' to 'Pay Loan'
     ...    update: nbautist    27NOV2020    - Updated prerequisites and added comments for clear execution flow
         
     

      Mx Execute Template with Multiple Data    Pay Loan Outstanding Accrual Zero Cycle Due    ${ComSeeDataSet}     ${rowid}    ComSee_SC2_Loan
      Mx Execute Template with Multiple Data    Get and Validate API Outstanding Response   ${ComSeeDataSet}    ${rowid}    ComSee_SC2_Loan