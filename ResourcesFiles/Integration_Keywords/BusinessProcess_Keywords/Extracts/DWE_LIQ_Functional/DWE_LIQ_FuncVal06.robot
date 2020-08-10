*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Keywords ***
Validate VLS_GL_ENTRY Extract
    [Documentation]    This keyword is used to validate the GLE_CDE_PROC_AREA and GLE_CDE_FEE_TYPE  fields in CSV vs LIQ Screen  
    ...    @author: mgaling    29AUG2019    - Initial create
    [Arguments]    ${Excelpath}        
    
    ${CSV_Content}    Read Csv File To List    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[GL_ENTRY_CSV_FileName].csv    |
    
    ### Validate GLE_CDE_PROC_AREA column ###
    ${ProcArea_DistinctData_List}    Get Distinct Column Data    ${CSV_Content}    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[GL_ENTRY_CSV_FileName].csv    GLE_CDE_PROC_AREA
    
    Validate the Processing Area Code in LIQ    ${ProcArea_DistinctData_List}
           
    ### Validate GLE_CDE_FEE_TYPE column ###
    
    ${FeeType_DistinctData_List}    Get Distinct Column Data    ${CSV_Content}    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[GL_ENTRY_CSV_FileName].csv    GLE_CDE_FEE_TYPE
    
    Validate Fee Type Data from CSV in LIQ Screen    ${FeeType_DistinctData_List}
