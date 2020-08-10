*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords *** 

Open Event Fee Notebook
    [Documentation]    This keyword opens the Event Fee from Scheduled Activity Report window. 
    ...    @author: rtarayao
    [Arguments]    ${ScheduledActivityReport_Date}    ${ScheduledActivityReport_ActivityType}    ${Deal_Name}    ${Loan_Alias}
      
    mx LoanIQ activate window    ${LIQ_ScheduledActivityReport_Window}
    mx LoanIQ click   ${LIQ_ScheduledActivityReport_CollapseAll_Button}             
    Mx Loaniq Expand    ${LIQ_ScheduledActivityReport_List}    ${ScheduledActivityReport_Date}
    Mx Loaniq Expand    ${LIQ_ScheduledActivityReport_List}    ${ScheduledActivityReport_Date};${ScheduledActivityReport_ActivityType}  
    Mx LoanIQ Click Javatree Cell   ${LIQ_ScheduledActivityReport_List}    ${Loan_Alias}%${Loan_Alias}%Alias
    Mx Native Type    {ENTER}
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    



