*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Validate VLS_BAL_SUBLEDGER Extract
    [Documentation]    This keyword is used to validate BSG_CDE_GL_ACCOUNT, BSG_CDE_GL_SHTNAME, BSG_CDE_BRANCH, BSG_CDE_EXPENSE, BSG_CDE_PORTFOLIO, BSG_CDE_CURRENCY for VLS_BAL_SUBLEDGER.
    ...    @author: ehugo    29AUG2019    - initial create
    ...    @update: mgaling    13OCT2020    - updated csv path variables
    [Arguments]    ${ExcelPath}        
    
    ###Validate ACN_CDE_ACCT_NUM in GL_Account_Num Table vs BSG_CDE_GL_ACCOUNT in Bal_Subledger Table###
    Validate Records Exist Between 2 CSV Files    ACN_CDE_ACCT_NUM    GL_Account_Num    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[GL_Account_Num_CSV_FileName]&{ExcelPath}[Business_Date].csv    
    ...    BSG_CDE_GL_ACCOUNT    Bal_Subledger    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Bal_Subledger_CSV_FileName]&{ExcelPath}[Business_Date].csv    
    
    ###Validate BSG_CDE_GL_ACCOUNT in LIQ###
    Validate BSG_CDE_GL_ACCOUNT in LIQ for VLS_Bal_Subledger    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Bal_Subledger_CSV_FileName]&{ExcelPath}[Business_Date].csv    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[GL_Account_Num_CSV_FileName]&{ExcelPath}[Business_Date].csv
    
    ###################################################
    
    ###Validate SNM_CDE_GL_SHTNAME in GL_Short_Name Table vs BSG_CDE_GL_SHTNAME in Bal_Subledger Table###
    Validate Records Exist Between 2 CSV Files    SNM_CDE_GL_SHTNAME    GL_Short_Name    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[GL_Short_Name_CSV_FileName]&{ExcelPath}[Business_Date].csv    
    ...    BSG_CDE_GL_SHTNAME    Bal_Subledger    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Bal_Subledger_CSV_FileName]&{ExcelPath}[Business_Date].csv    
    
    ###Validate BSG_CDE_GL_SHTNAME in LIQ###
    Validate BSG_CDE_GL_SHTNAME in LIQ for VLS_Bal_Subledger    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Bal_Subledger_CSV_FileName]&{ExcelPath}[Business_Date].csv    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[GL_Short_Name_CSV_FileName]&{ExcelPath}[Business_Date].csv
    
    ##################################################
    
    ###Validate BRN_CDE_BRANCH in Branch Table vs BSG_CDE_BRANCH in Bal_Subledger Table###
    Validate Records Exist Between 2 CSV Files    BRN_CDE_BRANCH    Branch    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Branch_CSV_FileName]&{ExcelPath}[Business_Date].csv    
    ...    BSG_CDE_BRANCH    Bal_Subledger    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Bal_Subledger_CSV_FileName]&{ExcelPath}[Business_Date].csv    
    
    ###Validate BSG_CDE_BRANCH in LIQ###
    Validate BSG_CDE_BRANCH in LIQ for VLS_Bal_Subledger    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Bal_Subledger_CSV_FileName]&{ExcelPath}[Business_Date].csv    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Branch_CSV_FileName]&{ExcelPath}[Business_Date].csv
    
    ###################################################
    
    ###Validate EXP_CDE_EXPENSE in Expense Table vs BSG_CDE_EXPENSE in Bal_Subledger Table###
    Validate Records Exist Between 2 CSV Files    EXP_CDE_EXPENSE    Expense    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Expense_CSV_FileName]&{ExcelPath}[Business_Date].csv    
    ...    BSG_CDE_EXPENSE    Bal_Subledger    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Bal_Subledger_CSV_FileName]&{ExcelPath}[Business_Date].csv    
    
    ###Validate BSG_CDE_EXPENSE in LIQ###
    Validate BSG_CDE_EXPENSE in LIQ for VLS_Bal_Subledger    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Bal_Subledger_CSV_FileName]&{ExcelPath}[Business_Date].csv    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Expense_CSV_FileName]&{ExcelPath}[Business_Date].csv
    
    ###################################################
    
    ###Validate PTF_CDE_PORTFOLIO in Portfolio Table vs BSG_CDE_PORTFOLIO in Bal_Subledger Table###
    Validate Records Exist Between 2 CSV Files - with None value in Source Table    PTF_CDE_PORTFOLIO    Portfolio    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Portfolio_CSV_FileName]&{ExcelPath}[Business_Date].csv    
    ...    BSG_CDE_PORTFOLIO    Bal_Subledger    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Bal_Subledger_CSV_FileName]&{ExcelPath}[Business_Date].csv    
    
    ###Validate BSG_CDE_PORTFOLIO in LIQ###
    Validate BSG_CDE_PORTFOLIO in LIQ for VLS_Bal_Subledger    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Bal_Subledger_CSV_FileName]&{ExcelPath}[Business_Date].csv    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Portfolio_CSV_FileName]&{ExcelPath}[Business_Date].csv
    
    ####################################################
    
    ###Validate BSG_CDE_CURRENCY in LIQ###
    Validate BSG_CDE_CURRENCY in LIQ for VLS_Bal_Subledger    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[Bal_Subledger_CSV_FileName]&{ExcelPath}[Business_Date].csv