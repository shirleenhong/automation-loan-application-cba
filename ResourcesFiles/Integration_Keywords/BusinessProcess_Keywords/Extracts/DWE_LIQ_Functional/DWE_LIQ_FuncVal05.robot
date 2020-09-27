*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Variables ***
${rowid}    2

*** Keywords ***
Validate VLS_FACILITY_TYPE Extract
    [Documentation]    This keyword is used to validate the FAC_CDE_FAC_TYPE  field in CSV vs LIQ Screen  
    ...    @author: mgaling    02Sep2019    - Initial create
    [Arguments]    ${Excelpath}        
    
    ${CSV_Content}    Read Csv File To List    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[FACILITY_TYPE_CSV_FileName].csv    |
    
    ### Validate FAC_CDE_FAC_TYPE column ###
    ${DistinctData_List}    Get Distinct Column Data    ${CSV_Content}    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[FACILITY_TYPE_CSV_FileName].csv    FAT_CDE_FAC_TYPE
    Log    ${DistinctData_List}  
     
    Validate Facility Type Data from CSV in LIQ Screen    ${DistinctData_List} 
