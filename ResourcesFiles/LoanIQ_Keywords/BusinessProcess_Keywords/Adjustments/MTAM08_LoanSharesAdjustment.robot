*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Loan Share Adjustment 
    [Documentation]    This keyword is for loan share adjustment for Syndicated Deal.
    ...    @author: mgaling
    ...    @update: sahalder    30JUN2020    Modified keyword as per new BNS framework
    [Arguments]    ${ExcelPath}    
    #Manual Share Adjustment Notebook###
    Launch Loan Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    Launch Manual Share Adjustment Notebook    &{ExcelPath}[Loan_PricingOption]
    Populate General Tab in Manual Share Adjustment     ${rowid}    &{ExcelPath}[ManualSharedAdj_Reason]  
    Update Host Bank Lender Share    ${rowid}    &{ExcelPath}[Lender_HostBank]    &{ExcelPath}[Adjustment]    
    Verify the New Balance in Servicing Group Share Window    ${rowid}    &{ExcelPath}[Lender_HostBank]    &{ExcelPath}[Adjustment]
    Update Host Bank Share Value - Host bank shares section    ${rowid}    &{ExcelPath}[Lender_HostBank]    &{ExcelPath}[Host_Bank]    &{ExcelPath}[Adjustment]        
    Verify the New Balance for Host Bank Share Value - Host bank shares section    ${rowid}    &{ExcelPath}[Host_Bank]    &{ExcelPath}[Adjustment]
    Update NonHost Bank Lender Share    ${rowid}    &{ExcelPath}[Lender_NonHostBank]    &{ExcelPath}[NHB_Adjustment]
    Verify the New Balance for NonHost Bank Share    ${rowid}    &{ExcelPath}[Lender_NonHostBank]
    
    ###Cashflows###  
    Navigate to Manual Share Adjustment Notebook Workflow    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender_NonHostBank]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Lender_NonHostBank]
    
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[GL_HostBank]    Credit Amt
    ${Lender1_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender_NonHostBank]    Debit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Debit Amt
    
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}    ${Lender1_Debit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalCreditAmt}    &{ExcelPath}[NHB_Adjustment]
    
    Adjustment Send to Approval
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Manual Share Adjustment - Workflow###
    Adjustment Approval    &{ExcelPath}[WIPTransaction_Type]    &{ExcelPath}[OustandingsTransaction_Type]    &{ExcelPath}[Deal_Name]    
    
    ###LIQ Window###
    Logout from Loan IQ
    login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ##Manual Share Adjustment Workflow Items###
    Adjustment Release    &{ExcelPath}[WIPTransaction_Type]    &{ExcelPath}[OustandingsTransaction_Type]    &{ExcelPath}[Deal_Name]    
    
