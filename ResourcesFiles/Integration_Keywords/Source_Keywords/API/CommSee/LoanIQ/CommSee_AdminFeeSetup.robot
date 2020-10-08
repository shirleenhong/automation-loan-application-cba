*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Setup Deal Administrative Fees - ComSee
    [Documentation]    This keyword is for adding Administrative Fees from the Deal Notebook's Admin/Event Fees tab.
    ...    @author: rtarayao    26AUG2019    - initial create
    [Arguments]    ${ExcelPath}
    
    ###Deal Notebook###
    ${AdminFee_EffectiveDate}    Get System Date
    Write Data To Excel    ComSee_SC2_AdminFee    AdminFee_EffectiveDate    ${rowid}    ${AdminFee_EffectiveDate}    ${ComSeeDataSet}
    
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    Add Admin Fee in Deal Notebook    &{ExcelPath}[AdminFee_IncomeMethod]
    Set General Tab Details in Admin Fee Notebook    &{ExcelPath}[AdminFee_FlatAmount]    ${AdminFee_EffectiveDate}    &{ExcelPath}[AdminFee_PeriodFrequency]
    ...    &{ExcelPath}[AdminFee_ActualDueDate]    &{ExcelPath}[AdminFee_BillNoOfDays]
    Set Distribution Details in Admin Fee Notebook    &{ExcelPath}[Primary_Lender1]    &{ExcelPath}[AdminFee_CustomerLocation]    &{ExcelPath}[AdminFee_ExpenseCode]    &{ExcelPath}[AdminFee_PercentOfFee]
    
    ${AdminFee_Alias}    Copy Alias To Clipboard and Get Data    ${LIQ_AdminFeeNotebook_Window}
    ${AdminFee_DueDate}    Get Admin Fee Due Date
    Write Data To Excel    ComSee_SC2_AdminFee    AdminFee_Alias    ${rowid}    ${AdminFee_Alias}    ${ComSeeDataSet}
    
    ###Send to Approval###
    Navigate Notebook Workflow    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFeeNotebook_JavaTab}    ${LIQ_AdminFeeNotebook_Workflow_JavaTree}    Send to Approval
    mx LoanIQ close window    ${LIQ_AdminFeeNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_File_Save}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
       
    ###Approve Admin Fee###
    Logout from LoanIQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Deals    Awaiting Approval    Amortizing Admin Fee    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFeeNotebook_JavaTab}    ${LIQ_AdminFeeNotebook_Workflow_JavaTree}    Approval
    
    ###Verify Admin Fee if successfully Added###
    Logout from LoanIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ${AdminFee_Alias}    Read Data From Excel    ComSee_SC2_AdminFee    AdminFee_Alias    ${rowid}    ${ComSeeDataSet}
    Validate Admin Fee If Added    ${AdminFee_Alias}
    
    mx LoanIQ select    ${LIQ_DealNotebook_File_Save}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
