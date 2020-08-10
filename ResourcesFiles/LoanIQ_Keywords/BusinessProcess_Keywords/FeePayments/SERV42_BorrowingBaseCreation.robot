*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

***Keyword***

Borrowing Base Creation
    [Documentation]    This keyword is used to Create a Borrowing Base
    ...    @ author:Archana
    [Arguments]    ${ExcelPath}
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Deal Notebook###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ${EffectiveDate}    Get System Date    
    
    ###Facility###
    Open Facility From Deal Notebook    &{ExcelPath}[Facility_Name]
    Add Facility Change Transaction
    Add Facility Borrower Base in Facility Change Transaction        
    Add Borrowing Base Deatils    &{ExcelPath}[Borrowing]    ${EffectiveDate}    &{ExcelPath}[Expiration_Date]    &{ExcelPath}[Grace_Period]    &{ExcelPath}[Collateral]    &{ExcelPath}[Ineligible_Value]    &{ExcelPath}[CapFlat_Amount]    &{ExcelPath}[Advance_Percentage]        
    
    Send to Approval Facility Change Transaction   
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Transaction in Process###
    Navigate Transaction in WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Approval]    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Deal_Name]    
    
    ###Facility Change Notebook###
    Approve Borrower BaseCreation
     
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Transaction In Process###
    Navigate Transaction in WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Release]    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Deal_Name]
    
    ###Facility Change  Notebook###
    Release Borrower BaseCreation in Workflow
    
    ###Verification on Facility Notebook###
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Verification of Borrower Base Created in Facility Change Transaction    &{ExcelPath}[Borrowing]
    
    ###Loan IQ Desktop###    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    