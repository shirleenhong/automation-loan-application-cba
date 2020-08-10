*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***    
Setup Recurring Event Fee
    [Documentation]    This keyword is for setting up a Recurring Event Fee after Deal Close.
    ...    @author: bernchua
    [Arguments]    ${ExcelPath}
    ###Re-login to original user, and opening the created Deal###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Open Facility From Deal Notebook    &{ExcelPath}[Facility_Name]
    Activate Facility Notebook and Select Event Fee 
    Validate Event Fee Notebook General Tab Details    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_Name]
    Set Event Fee General Tab Details    &{ExcelPath}[EventFee]    &{ExcelPath}[RecurringEventFee_Amount]    &{ExcelPath}[EventFee_EffectiveDate]
    ...    &{ExcelPath}[EventFee_BillingDays]    &{ExcelPath}[EventFee_Comment]    ON    &{ExcelPath}[EventFee_NoRecurrencesAfterDate]
    # Write Data To Excel    SERV33_RecurringFee    EventFee_RequestedAmount    ${rowid}    ${RequestedAmount}
    Set Event Fee Frequency Tab Details    &{ExcelPath}[EventFee_EffectiveDate]    &{ExcelPath}[EventFee_Frequency]    &{ExcelPath}[EventFee_NonBusinessDayRule]
    Save and Close Event Fee Window and Exit from Facility Window    
