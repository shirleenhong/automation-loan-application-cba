*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Extend Maturity and Limit for MOF
    [Documentation]    This Keyword modifies extends the Maturity Date of the specified Facility
    [Arguments]    ${ExcelPath}
    
    ###Loan IQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Facility Notebook###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    
    ###Facility Notebook###
    Add Facility Change Transaction
    
    ###Facility Change Transaction Notebook###
    Update Facility Details    &{ExcelPath}[Facility_Field]    &{ExcelPath}[Expiry_Date]
   
    Navigate to Facility Increase/Decrease Schedule
    
    ${SysDate}    Get System Date    
    Add Facility Schedule Item    &{ExcelPath}[Facility_Change_Type]    &{ExcelPath}[Increase_Amount]    ${SysDate}
    
    ###Facility Change Transaction Notebook###
    Send to Approval Facility Change Transaction
    
    ###Loan IQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###WIP - Facility Change Transaction Notebook###
    Approve Facility Change Transaction    &{ExcelPath}[Deal_Name]
    
    ###Loan IQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###WIP - Facility Change Transaction Notebook
    Release Facility Change Transaction    &{ExcelPath}[Deal_Name]
    
    ###Facility Notebook
    Validate Facility Change Transaction    &{ExcelPath}[Maturity_Date]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    
    ###Facility Notebook###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    
    ### Create Pending Transactions ###
    Create Pending Transaction in Facility Schedule    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[PendingTran_EffectiveDate]
    Enter Facility Schedule Commitment Details    Limit Increase
    
    ### Send to Approval
    Navigate Notebook Workflow    ${LIQ_ScheduledCommitment_Notebook}    ${LIQ_ScheduledCommitment_Tab}    ${LIQ_ScheduledCommitment_Workflow_JavaTree}    Send to Approval
    
    ###Loan IQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    Select Item in Work in Process    Facilities    Awaiting Approval    Scheduled Commitment Increase    &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_ScheduledCommitment_Notebook}    ${LIQ_ScheduledCommitment_Tab}    ${LIQ_ScheduledCommitment_Workflow_JavaTree}    Approval

    
    ###Loan IQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    Select Item in Work in Process    Facilities    Awaiting Release    Scheduled Commitment Increase    &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_ScheduledCommitment_Notebook}    ${LIQ_ScheduledCommitment_Tab}    ${LIQ_ScheduledCommitment_Workflow_JavaTree}    Release

Extend Maturity and Limit for FCAF
    [Documentation]    This Keyword modifies extends the Maturity Date of the specified Facility
    [Arguments]    ${ExcelPath}
    
    ###Loan IQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Facility Notebook###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    
    ###Facility Notebook###
    Add Facility Change Transaction
    
    ###Facility Change Transaction Notebook###
    Update Facility Details    &{ExcelPath}[Facility_Field]    &{ExcelPath}[Expiry_Date]
   
    
    ###Facility Change Transaction Notebook###
    Send to Approval Facility Change Transaction
    
    ###Loan IQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###WIP - Facility Change Transaction Notebook###
    Approve Facility Change Transaction    &{ExcelPath}[Deal_Name]
    
    ###Loan IQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###WIP - Facility Change Transaction Notebook
    Release Facility Change Transaction    &{ExcelPath}[Deal_Name]
    
    ###Facility Notebook
    Validate Facility Change Transaction    &{ExcelPath}[Maturity_Date]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    
    ###Facility Notebook###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    
    # ### Create Pending Transactions ###
    # Create Pending Transaction in Facility Schedule    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[PendingTran_EffectiveDate]
    # Enter Facility Schedule Commitment Details    Limit Increase
    
    # ### Send to Approval
    # Navigate Notebook Workflow    ${LIQ_ScheduledCommitment_Notebook}    ${LIQ_ScheduledCommitment_Tab}    ${LIQ_ScheduledCommitment_Workflow_JavaTree}    Send to Approval
    
    # ###Loan IQ Window###
    # Logout from LIQ
    # Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    # Select Item in Work in Process    Facilities    Awaiting Approval    Scheduled Commitment Increase    &{ExcelPath}[Facility_Name]
    # Navigate Notebook Workflow    ${LIQ_ScheduledCommitment_Notebook}    ${LIQ_ScheduledCommitment_Tab}    ${LIQ_ScheduledCommitment_Workflow_JavaTree}    Approval

    
    # ###Loan IQ Window###
    # Logout from LIQ
    # Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    # Select Item in Work in Process    Facilities    Awaiting Release    Scheduled Commitment Increase    &{ExcelPath}[Facility_Name]
    # Navigate Notebook Workflow    ${LIQ_ScheduledCommitment_Notebook}    ${LIQ_ScheduledCommitment_Tab}    ${LIQ_ScheduledCommitment_Workflow_JavaTree}    Release

