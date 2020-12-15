*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Update Adjusted Due Date for DNR
    [Documentation]    This keyword will update the existing commitment fee cycle in the created deal
    ...    @author: clanding    01DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    ###LoanIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Loan IQ Desktop###
    ${SystemDate}    Get System Date
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Deal Notebook - Summary Tab###  
    ${Fee_Alias}    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Fee_Type]
    
    ###Commitment Fee Notebook - General Tab###
    ${New_AdjustedDueDate}    Update Adjusted Due Date on Commitment Fee   &{ExcelPath}[Add_To_AdjustedDays]
    Write Data To Excel    SC1_PaymentFees    New_AdjustedDueDate    ${rowid}    ${New_AdjustedDueDate}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    SC1_PaymentFees    ScheduleActivity_FromDate    ${rowid}    &{ExcelPath}[Fee_EffectiveDate]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    SC1_PaymentFees    ScheduledActivity_ThruDate    ${rowid}    ${New_AdjustedDueDate}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    SC1_PaymentFees    ScheduledActivityReport_Date    ${rowid}    ${New_AdjustedDueDate}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    SC1_PaymentFees    FeePayment_EffectiveDate    ${rowid}    ${SystemDate}    ${DNR_DATASET}    bTestCaseColumn=True
        
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    
Get Fee Alias for Payment from Ongoing Fee Setup for DNR
    [Documentation]    This keyword is used to get details from Ongoing Fee Setup.
    ...    @author: clanding    01DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    Open Existing Deal    &{ExcelPath}[Deal_Name]
    ${Fee_Alias}    Get Facility Ongoing Fee Alias    &{ExcelPath}[Facility_Name]
    Open Facility Navigator from Deal Notebook
    Open Ongoing Fee List from Facility Navigator    &{ExcelPath}[Facility_Name]
    Open Ongoing Fee from Fee List    ${Fee_Alias}
    ${ActualDueDate}    ${AdjustedDueDate}    Get Actual and Adjusted Due Date

    Write Data To Excel    SC1_PaymentFees    Fee_Alias    ${TestCase_Name}    ${Fee_Alias}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    SC1_PaymentFees    ActualDueDate    ${TestCase_Name}    ${ActualDueDate}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    SC1_PaymentFees    AdjustedDueDate    ${TestCase_Name}    ${AdjustedDueDate}    ${DNR_DATASET}    bTestCaseColumn=True

    Close All Windows on LIQ