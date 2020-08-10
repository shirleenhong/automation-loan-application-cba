*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Remittance Instructions Change Transaction
    [Documentation]    This Keyword is used to Change Remittance instruction Details.
    ...  @author : Archana     
    [Arguments]    ${ExcelPath}
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Loan IQ Desktop###   
    ${Effective_date}    Get System Date    
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]
    Navigate to "Profiles" Tab
    Add Remittance Instruction    &{ExcelPath}[Borrower]
    Select Remittance Method    &{ExcelPath}[Remittance_Method]
    Update Remittance Instruction Details
    Remittance Instruction Change Details    ${Effective_date}    &{ExcelPath}[Account_Name]
    Remittance Instructions Change details for AccountName    &{ExcelPath}[NewAccount_Name]    &{ExcelPath}[Account_Number]    &{ExcelPath}[NewAccount_Number]
    ChangeRemittanceInstructionTransaction_Send to Approval
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Transaction in Process###
    Navigate Transaction in WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Approval]    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[LIQCustomer_ShortName]    
       
    ###Contact Change Transaction Notebook###
    Approve Remittance Instructions Change Transaction
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Transaction In Process###
    Navigate Transaction in WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Approval]    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[LIQCustomer_ShortName]
    
    ###Contact Change Transaction Notebook###
    Approve Remittance Instructions Change Transaction      
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]
    Navigate to "Profiles" Tab
    Add Remittance Instruction    &{ExcelPath}[Borrower]
    Select Remittance Method    &{ExcelPath}[Remittance_Method]
    Navigate to Pending Remittance Instructions Change Transaction
    Release Remittance Instructions Change Transaction in Workflow
    
    ###Validation of Changed Remittance Instructions###    
    ${Old_value}    ${New_value}    GetUIValue of Remittance Change Transaction Details
    Validation of Amended Remittance Change Transaction Details    ${New_value}    &{ExcelPath}[NewAccount_Name]
    Close All Windows on LIQ