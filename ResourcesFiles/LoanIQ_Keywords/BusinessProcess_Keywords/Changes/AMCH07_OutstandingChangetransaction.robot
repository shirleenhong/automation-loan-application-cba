*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Outstanding Change Transaction
    [Documentation]    This high-level keyword will Change the Outstanding Transaction
    ...    @author: Archana
    [Arguments]    ${ExcelPath}
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
   
    ###Outstanding  Notebook### 
    Open Existing Guarantee    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
        
    ###Existing Standby Letters of Credit###     
    Open Existing Loan    &{ExcelPath}[Alias]
    
    ###LoanChangeTransaction Notebook###
    ${Effective_Date}    Get System Date    
    Open Loan Change Transaction NoteBook
    Loan Change Transaction    ${Effective_Date}
    Select a Change Field    &{ExcelPath}[Change_Item]
    Add New Value On Loan Change Transaction    &{ExcelPath}[ContractID_Value]    &{ExcelPath}[New_ContractID]
    OutstandingChangeTransaction_Send to Approval
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Transaction in Process###
    Navigate Transaction in WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Approval]    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Deal_Name]    
    
    ###Loan Notebook###
    Approve Outstanding Change Transaction
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Outstanding  Notebook### 
    Open Existing Guarantee    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
        
    ###Existing Standby Letters of Credit###     
    Open Existing Loan    &{ExcelPath}[Alias]
    
    ###Loan Notebook###        
    Release Pending Oustanding Change Transaction
    ${OLD_ContractID}    ${NEW_ContractID}    Release Outstanding Change Transaction in Workflow 
   
    ###Validation of Outstanding chancge Transaction###
    Open Existing Guarantee    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Open Existing Loan    &{ExcelPath}[Alias]
    ${Contract_ID}    GetUIVlaue of Changed Outstanding Transaction
    Validation of Outstanding Change Transaction    ${NEW_ContractID}    ${Contract_ID}
    
    Close All Windows on LIQ       
    