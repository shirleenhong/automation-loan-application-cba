*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Variables ***
${rowid}    1

*** Keywords ***
Validate VLS_GL_SHORT_NAME Extract
    [Documentation]    This keyword is used to validate the SNM_CDE_GL_SHTNAME field in CSV vs LIQ Screen  
    ...    @author: mgaling    23AUG2019    - Initial create
    [Arguments]    ${Excelpath}        
    
    ### Navigate to G/L Short Name Window in LIQ ###
    Select Actions    [Actions];Table Maintenance
    Search in Table Maintenance    G/L Short Name
    
      
    ### Validate the Short Name and Natural Balance in LIQ ###
    ${read_csv}    Read Csv File To List    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[GL_SHORT_NAME_CSV_FileName].csv    |
    
    ${header}    Get From List    ${read_csv}    0
    ${SNM_CDE_GL_SHTNAME_Index}    Get Index From List    ${header}    SNM_CDE_GL_SHTNAME
    ${SNM_DSC_GL_SHTNAME_Index}    Get Index From List    ${header}    SNM_DSC_GL_SHTNAME
    ${SNM_CDE_NATURL_BAL_Index}    Get Index From List    ${header}    SNM_CDE_NATURL_BAL
    
    
    Validate the Short Name Code and Natural Balance records in LIQ Screen    ${read_csv}    ${SNM_CDE_GL_SHTNAME_Index}    ${SNM_DSC_GL_SHTNAME_Index}    ${SNM_CDE_NATURL_BAL_Index} 
