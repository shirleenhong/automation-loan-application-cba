*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Pay Line Fee with Online Accrual for PT Health Syndicated Deal
    [Documentation]    This keyword will setup an online accrual and payment for Line Fee
    ...    @author: songchan    01FEB2021    - initial create
    [Arguments]    ${ExcelPath}
    
    ### LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Run Online Accrual###
    Search Existing Deal    &{ExcelPath}[Deal_Name]    
    Navigate Directly to Line Fee Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    Run Online Acrual to Line Fee

    ###Validate Online Accrual and Initiate Line Fee Payment###
    Navigate to Facility Notebook   &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[OngoingFee_Type]
    Verify Details in Accrual Tab for Line Fee    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[Cycle_StartDate]    &{ExcelPath}[Cycle_EndDate]
    ...    &{ExcelPath}[Cycle_DueDate]    &{ExcelPath}[Expected_CycleDueAmt]    &{ExcelPath}[ProjectedCycleDue]    

    Initiate Payment for Line Fee    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[RequestedAmount]    &{ExcelPath}[Effective_Date]
    
    ###Cashflow Notebook - Create Cashflows###
    Navigate to Payment Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Verify if Method has Remittance Instruction    &{ExcelPath}[Customer_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Set All Items to Do It
    
    ### Sending Payment For Approval ###
    Navigate to Payment Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}

    ###Approve Line Fee Payment###
    Navigate Work in Process for Ongoing Fee Payment Approval    &{ExcelPath}[Facility_Name]
    Approve Ongoing Fee Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Release Line Fee Payment###
    Navigate Work in Process for Ongoing Fee Payment Release    &{ExcelPath}[Facility_Name]
    Release Ongoing Fee Payment
    Close All Windows on LIQ
    
    ###Validate Released Line Fee Payment###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[OngoingFee_Type]
    Validate After Payment Details on Acrual Tab - Line Fee    &{ExcelPath}[Expected_PaidToDate]    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[ReleasedExpected_CycleDueAmt]
    Validate Release of Ongoing Line Fee Payment
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
Pay Line Fee without Online Accrual for PT Health Syndicated Deal
    [Documentation]    This keyword is for Line Fee Payment without Online Accrual
    ...    @author: songchan    03FEB2021    - initial create
    [Arguments]    ${ExcelPath}

    ###Initiate Line Fee Payment###
    Navigate to Facility Notebook   &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[OngoingFee_Type]
    
    Initiate Payment for Line Fee    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[RequestedAmount]    &{ExcelPath}[Effective_Date]
    
    ###Cashflow Notebook - Create Cashflows###
    Navigate to Payment Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Verify if Method has Remittance Instruction    &{ExcelPath}[Customer_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Set All Items to Do It
    
    ### Sending Payment For Approval ###
    Navigate to Payment Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}

    ###Approve Line Fee Payment###
    Navigate Work in Process for Ongoing Fee Payment Approval    &{ExcelPath}[Facility_Name]
    Approve Ongoing Fee Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Release Line Fee Payment###
    Navigate Work in Process for Ongoing Fee Payment Release    &{ExcelPath}[Facility_Name]
    Release Ongoing Fee Payment
    Close All Windows on LIQ
    
    ###Validate Released Line Fee Payment###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[OngoingFee_Type]
    Validate After Payment Details on Acrual Tab - Line Fee    &{ExcelPath}[Expected_PaidToDate]    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[ReleasedExpected_CycleDueAmt]
    Validate Release of Ongoing Line Fee Payment
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}