*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
   
*** Keywords ***
Unscheduled Commitment Decrease
    [Documentation]    This high level keyword will be used to decrease Unscheduled Commitment
    ...    @author: Archana
    [Arguments]    ${ExcelPath}
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Facility Notebook###
    ${Effective_Date}    Get System Date    
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    
    Increase Or Decrease Schedule
    Amortization Schedule for Facility
    Add Schedule Item    ${ExcelPath}[ScheduleItem_Amount]    ${ExcelPath}[ScheduleItem_PercentofCurrent]    ${Effective_Date}
    Add Amortization Schedule Status    ${ExcelPath}[AmortizationScheduleStatus]    ${ExcelPath}[Schedule_Type]
    Modify Schedule
    Create Pending Transaction    ${ExcelPath}[Schedule_Type]
    Create Transaction Notice
    Update Lender Shares    ${ExcelPath}[HostBankShare]    ${ExcelPath}[Portfolio]    ${ExcelPath}[Actual_Amount]
    Send to Approval Unscheduled Commitment Decrease
    
    ##Loan IQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ##Transaction in Process###
     Navigate Transaction in WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Approval]    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Deal_Name]    
    
    ###Unscheduled Commitment Decrease Notebook###
    Approve Unscheduled Commitment Decrease
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    #Facility Notebook###
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    
    ###Unscheduled Commitment Decrease Notebook >> Workflow Tab (Transaction Release)###
    Release Pending Unscheduled Commitment Decrease in Workflow
    ${UnscheduledCommitmentType}    ${Decrease_Amount}    Release Unscheduled Commitment Decrease in Workflow
       
    ${Type}    Read Data From Excel    SERV16_UnSchComittmentDecrease    Facility_Type    &{ExcelPath}[rowid]    
    ${ScheduleItem_Amount}    Read Data From Excel    SERV16_UnSchComittmentDecrease    ScheduleItem_Amount    &{ExcelPath}[rowid]
    Validation on Commitment Decrease Schedule    ${UnscheduledCommitmentType}    ${Decrease_Amount}    ${Type}    ${ScheduleItem_Amount}
    Close All Windows on LIQ   