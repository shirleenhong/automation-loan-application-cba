*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
   
Create Cycle Share Adjustment for Fee Accrual
    [Documentation]    This keyword is for creating cycle share adjustment for Bilateral Deal (MTAM06B).
    ...    @author:mgaling
    ...    @update: dahijara    15JUL2020    - Added keyword for WIP navigation; Removed unnecessary codes.
    ...    @updater: dahijara    16JUL2020    - Added excel writing for Accrual Tab data.
    ...                                       - Added variable to handle return value for 'Navigate and Verify Accrual Tab'
    [Arguments]    ${ExcelPath}  
   
    #Launch Commitment Fee Notebook###
    ${SystemDate}    Get System Date
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type]
    
    ${StartDate}    ${EndDate}    ${DueDate}    ${CycleDue}    ${ProjectedCycleDue}    ${Orig_TotalCycleDue}    ${Orig_TotalManualAdjustment}    ${Orig_TotalProjectedEOCAccrual}    Navigate and Verify Accrual Tab    ${rowid}    &{ExcelPath}[CycleNo]
    Write Data To Excel    MTAM06B_CycleShareAdjustment    StartDate_Value    ${rowid}    ${StartDate}
    Write Data To Excel    MTAM06B_CycleShareAdjustment    EndDate_Value    ${rowid}    ${EndDate}
    Write Data To Excel    MTAM06B_CycleShareAdjustment    DueDate_Value    ${rowid}    ${DueDate}
    Write Data To Excel    MTAM06B_CycleShareAdjustment    CurrentCycleDue_Value    ${rowid}    ${CycleDue}
    Write Data To Excel    MTAM06B_CycleShareAdjustment    ProjectedCycleDue_Value    ${rowid}    ${ProjectedCycleDue}
    Write Data To Excel    MTAM06B_CycleShareAdjustment    Orig_TotalCycleDue    ${rowid}    ${Orig_TotalCycleDue}
    Write Data To Excel    MTAM06B_CycleShareAdjustment    Orig_TotalManualAdjustment    ${rowid}    ${Orig_TotalManualAdjustment}
    Write Data To Excel    MTAM06B_CycleShareAdjustment    Orig_TotalProjectedEOCAccrual    ${rowid}    ${Orig_TotalProjectedEOCAccrual}
    
    ###Accrual Share Adjustment Notebook###
    Navigate and Verify Accrual Share Adjustment Notebook    ${StartDate}    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Deal_Borrower]    &{ExcelPath}[OngoingFee_Type]    ${CycleDue}
    ...    &{ExcelPath}[ProjectedCycleDue_Value]    
    Input Requested Amount, Effective Date, and Comment    &{ExcelPath}[Requested_Amount]    ${StartDate}     &{ExcelPath}[Accrual_Comment]
    Save the Requested Amount, Effective Date, and Comment    &{ExcelPath}[Requested_Amount]    ${StartDate}     &{ExcelPath}[Accrual_Comment]
    
    ###Accrual Share Adjustment Notebook - Workflow Items (INPUTTER)###
    Send Adjustment to Approval
    Logout from Loan IQ
    
    ###Accrual Share Adjustment Notebook - Workflow Items (APPROVER)###
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    &{ExcelPath}[WIPTransaction_Type]    Awaiting Approval    &{ExcelPath}[FacilitiesTransaction_Type]     &{ExcelPath}[Deal_Name]
    Approve Fee Accrual Shares Adjustment
    Logout from Loan IQ
    
    ###Accrual Share Adjustment Notebook - Workflow Items (APPROVER2)###
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    &{ExcelPath}[WIPTransaction_Type]    Awaiting Release    &{ExcelPath}[FacilitiesTransaction_Type]     &{ExcelPath}[Deal_Name]
    Release Fee Accrual Shares Adjustment
    Close Accrual Shares Adjustment Window
    Logout from Loan IQ
    
    ###Verify the Updates in Accrual Tab###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type]
    
    Validate Manual Adjustment Value    &{ExcelPath}[CycleNo]    &{ExcelPath}[Requested_Amount] 
    Validate Cycle Due New Value    &{ExcelPath}[CycleNo]    ${CycleDue}     &{ExcelPath}[Requested_Amount]
    Validate Projected EOC Due New Value    &{ExcelPath}[CycleNo]    ${ProjectedCycleDue}     &{ExcelPath}[Requested_Amount]        
    Validate Manual Adjustment Total Value    ${rowid}    &{ExcelPath}[Requested_Amount]
    Validate Cycle Due Total Value    ${rowid}    &{ExcelPath}[Requested_Amount]
    Close All Windows on LIQ 
    
