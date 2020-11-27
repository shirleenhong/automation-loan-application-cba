**** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    4

*** Test Case ***


Verify Loan Outstanding of Zero Cycle Due and Accrual for 2 Cycles
     [Documentation]    This ComSee test case verify cycledue and paidtodate set to 0  
     ...    Pre-requisited is COMMSEE_V2_OS004 , execute Batch, then run multiple cycles.
     ...        
     ...    Pre-requisite: 
     ...    1. Run COMMSEE_V2_OS004, COMMSEE_V2_OS005
     ...    2. Run 1 month EOD (or duration depends on specified frequency)
     ...    
     ...    @author: sacuisia    02OCT2020
     ...    @update: nbautist    27NOV2020    - Updated prerequisites and added comments for clear execution flow

      # ### Run 1 month EOD before proceeding with "Write Loan Outstanding Accrual Non Zero Cycle" ###
      # Pause Execution
      
      Mx Execute Template with Multiple Data    Write Loan Outstanding Accrual Non Zero Cycle    ${ComSeeDataSet}     ${rowid}    ComSee_SC2_Loan
      Mx Execute Template with Multiple Data    Get and Validate API Outstanding Response   ${ComSeeDataSet}    ${rowid}    ComSee_SC2_Loan