*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
   
Create Adjustments - Cashflows to SPAP
    [Documentation]    This keyword is for setting up a Recurring Event Fee after Deal Close and send the cashflows generated to SPAP
    ...    @author:     sahalder    23JUL2020    initial create
    [Arguments]    ${ExcelPath}
    ###login to LIQ with inputter user###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Navigate to Existing Facility###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Open Facility From Deal Notebook    &{ExcelPath}[Facility_Name]
    
    ###Navigate to event fee notebook and add details###
    ${System_Date}    Activate Facility Notebook and Select Event Fee
    Write Data To Excel    MTAM04_Adjustments    EventFee_EffectiveDate    &{ExcelPath}[rowid]    ${System_Date}
    Validate Event Fee Notebook General Tab Details    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_Name]
    Set Event Fee General Tab Details    &{ExcelPath}[EventFee]    &{ExcelPath}[RecurringEventFee_Amount]    &{ExcelPath}[EventFee_EffectiveDate]
    ...    &{ExcelPath}[EventFee_BillingDays]    &{ExcelPath}[EventFee_Comment]    ON    &{ExcelPath}[EventFee_NoRecurrencesAfterDate]
    Set Event Fee Frequency Tab Details    &{ExcelPath}[EventFee_EffectiveDate]    &{ExcelPath}[EventFee_Frequency]    &{ExcelPath}[EventFee_NonBusinessDayRule]
    Save Event Fee Window
    
    ###Create Cashflows and send to SPAP###
    Create Cashflow for Event Fee
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Set the Status to Send all to SPAP
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
        
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[GL_HostBank]    Debit Amt
    ${Lender1_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender_NonHostBank]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotaldebitAmt}    Get GL Entries Amount    Total For:    Debit Amt
    
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}    ${Lender1_Debit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotaldebitAmt}    &{ExcelPath}[RecurringEventFee_Amount]    
    Close GL Entries and Cashflow Window
    Send Event Fee to Approval
        
    ###Approve the Event Fee###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Open Event Fee Notebook via WIP - Awaiting Approval    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingApprovalStatus]    &{ExcelPath}[WIP_OutstandingType]    &{ExcelPath}[Facility_Name]
    Approve Event Fee
    Open Event Fee Notebook via WIP - Awaiting Release    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingReleaseStatus]    &{ExcelPath}[WIP_OutstandingType]    &{ExcelPath}[Facility_Name]
    Release Event Fee
    
    ###Loan IQ Desktop###    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}