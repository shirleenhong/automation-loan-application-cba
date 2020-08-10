*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Change Agency Fee
    [Documentation]    This keyword does an Admin Fee Change Transaction for the Expiry Date.
    ...    @author: bernchua
    ...    @update: ritragel    28FEB2019    - Conform with Automation Standards
    ...    @update: hstone      11JUN2020    - Removed 'mx LoanIQ click element if present    ${LIQ_DealNotebook_InquiryMode_Button}'
    ...    @update: hstone      15JUN2020    - Removed 'Navigate WIP for Admin Fee Change Transaction    Awaiting Approval    &{ExcelPath}[Deal_Name]'
    [Arguments]    ${ExcelPath}
    
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Opens the Admin Fee from the Deal Notebook's Admin/Event Fees tab###
    Open Admin Fee From Deal Notebook    &{ExcelPath}[AdminFee_Alias]
    
    ###Creates an Admin Fee Change Transaction from the Admin Fee Notebook's Options menu###
    Create Admin Fee Change Transaction
    
    ###Validation of the the Deal Name and entering of details in the Admin Fee Change Transaction Notebook's General Tab###
    ${SysDate}    Get System Date
    ${AdminFee_NewExpiryDate}    Add Time from From Date and Returns Weekday    ${SysDate}    365
    Write Data To Excel    AMCH10_ChangeAgencyFee    AdminFee_NewExpiryDate    ${rowid}    ${AdminFee_NewExpiryDate}    
    Set Admin Fee Change Transaction General Tab Details    &{ExcelPath}[Deal_Name]    &{ExcelPath}[AdminFeeChange_EffectiveDate]    Expiry Date    ${AdminFee_NewExpiryDate}
    
    ###Transaction Approval, Release, and Status validation###
    Navigate to Admin Fee Change Workflow and Proceed With Transaction    Send to Approval
    Validate Window Title Status    Admin Fee Change Transaction    Awaiting Approval
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Deals    Awaiting Approval    Admin Fee Change Transaction    &{ExcelPath}[Deal_Name]
    Navigate to Admin Fee Change Workflow and Proceed With Transaction    Approval
    Validate Window Title Status    Admin Fee Change Transaction    Awaiting Release
    Navigate to Admin Fee Change Workflow and Proceed With Transaction    Release
    Validate Window Title Status    Admin Fee Change Transaction    Released
    
    ###Validate if new Expiry Date is reflected after Admin Fee Change Transaction###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Validate Admin Fee New Data    &{ExcelPath}[AdminFee_Alias]    Expiry Date    &{ExcelPath}[AdminFee_NewExpiryDate]
    
    Close All Windows on LIQ
