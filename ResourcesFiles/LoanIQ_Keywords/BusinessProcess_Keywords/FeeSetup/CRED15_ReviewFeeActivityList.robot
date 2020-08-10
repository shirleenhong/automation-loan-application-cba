*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***    
Review Fee Activity List
    [Documentation]    This keyword is for viewing Fee Activity List
    ...    @author: fmamaril
    [Arguments]    ${ExcelPath}

    ###Search for Existing Deal###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Search for Existing Outstanding###
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Open Existing Loan    &{ExcelPath}[Loan_Alias]
        
    ###Validation on Fee Activity List###
    Navigate to Fee Activity List from Loan
    Validate Ongoing Fee Income Tab
    Validate Ongoing Fee Expense Tab
    Validate Free Form Event Fee Income
    Validate Free Form Event Fee Expense
    Close All Windows on LIQ     