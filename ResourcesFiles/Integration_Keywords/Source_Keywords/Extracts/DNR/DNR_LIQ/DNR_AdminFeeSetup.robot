*** Settings ***
Resource     ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup Deal Administrative Fees for DNR
    [Documentation]    This keyword is for adding Administrative Fees from the Deal Notebook's Admin/Event Fees tab.
    ...    @author: bernchua
    [Arguments]    ${ExcelPath}
        
    ###Deal Notebook###
    ${AdminFee_EffectiveDate}    Get System Date
    Write Data To Excel    SC2_AdminFee    AdminFee_EffectiveDate    ${rowid}    ${AdminFee_EffectiveDate}    ${DNR_DATASET}
        
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    Add Admin Fee in Deal Notebook    &{ExcelPath}[AdminFee_IncomeMethod]
    Set General Tab Details in Admin Fee Notebook    &{ExcelPath}[AdminFee_FlatAmount]    ${AdminFee_EffectiveDate}    &{ExcelPath}[AdminFee_PeriodFrequency]
    ...    &{ExcelPath}[AdminFee_ActualDueDate]    &{ExcelPath}[AdminFee_BillNoOfDays]
    Set Distribution Details in Admin Fee Notebook    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[AdminFee_CustomerLocation]    &{ExcelPath}[AdminFee_ExpenseCode]    &{ExcelPath}[AdminFee_PercentOfFee]
    
    ${AdminFee_Alias}    Copy Alias To Clipboard and Get Data    ${LIQ_AdminFeeNotebook_Window}
    ${AdminFee_DueDate}    Get Admin Fee Due Date
    Write Data To Excel    SC2_AdminFee    AdminFee_Alias    ${rowid}    ${AdminFee_Alias}    ${DNR_DATASET}

    
    ###Send to Approval###
    Navigate Notebook Workflow    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFeeNotebook_JavaTab}    ${LIQ_AdminFeeNotebook_Workflow_JavaTree}    Send to Approval
    mx LoanIQ close window    ${LIQ_AdminFeeNotebook_Window}
    Save Notebook Transaction    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_File_Save}
       
    ###Approve Admin Fee###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Deals    Awaiting Approval    Amortizing Admin Fee    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFeeNotebook_JavaTab}    ${LIQ_AdminFeeNotebook_Workflow_JavaTree}    Approval
    
    ###Verify Admin Fee if successfully Added###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    ${AdminFee_Alias}    Read Data From Excel    SC2_AdminFee    AdminFee_Alias    &{ExcelPath}[rowid]    ${DNR_DATASET}
    Validate Admin Fee If Added    ${AdminFee_Alias}
    Save Notebook Transaction    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_File_Save}