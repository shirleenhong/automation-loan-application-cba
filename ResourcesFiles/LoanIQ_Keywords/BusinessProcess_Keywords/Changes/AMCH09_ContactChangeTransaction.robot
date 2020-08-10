*** Settings ***
Resource   ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Contact Change Transaction
    [Documentation]    This keyword will perform Contact change transaction
    ...    @author: Archana
    [Arguments]    ${ExcelPath}
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Loan IQ Desktop###   
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]
    Navigate to "Profiles" Tab
    Add Contacts in Customer    &{ExcelPath}[Borrower]
    Add ContactList    &{ExcelPath}[Short_Name]
    ContactDetails    &{ExcelPath}[Nickname]
    Amend Contact Details    &{ExcelPath}[Nickname]
    ChangeContactTransaction_Send to Approval
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Transaction in Process###
    Navigate Transaction in WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Approval]    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[LIQCustomer_ShortName]    
       
    ###Contact Change Transaction Notebook###
    Approve Contact Change Transaction
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Transaction In Process###
    Navigate Transaction in WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Release]    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[LIQCustomer_ShortName]
    
    ###Contact Change Transaction Notebook###
    Release Contact Change Transaction in Workflow
    
    ###Validation of Amended Value###
    ${Old_value}    ${New_value}    GetUIValue of ContactDetails      
    Validation of Amended ContactDetails    ${New_value}    &{ExcelPath}[Nickname]
    Close All Windows on LIQ    