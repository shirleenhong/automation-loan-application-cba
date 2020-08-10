*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Validate VLS_FAC_PORT_POS Extract
    [Documentation]    This keyword is used to validate the FPP_CDE_PORTFOLIO  field in CSV vs LIQ Screen - Table Maintenance and in Transaction.  
    ...    @author: mgaling    03Sep2019    - initial create
    [Arguments]    ${Excelpath}
    
    ${CSV_Content}    Read Csv File To List    &{ExcelPath}[CSV_FilePath]    |
    Log List    ${CSV_Content}
    
    ### Validate the values under FPP_CDE_PORTFOLIO column in LIQ - Portfolio Table ###
    ${DistinctData_List}    Get Distinct Column Data    ${CSV_Content}    &{ExcelPath}[CSV_FilePath]    FPP_CDE_PORTFOLIO
    Log    ${DistinctData_List}    
    
    Validate Portfolio Code Data from CSV in LIQ Screen    ${DistinctData_List}
    
    ### Validate the value under FPP_CDE_PORTFOLIO column in LIQ Transaction ###
    
    ${FPP_PID_FACILITY_Value}    Get Row Data    ${CSV_Content}    FPP_PID_FACILITY    &{Excelpath}[Row_No]
    ${FPP_CDE_PORTFOLIO_Value}    Get Row Data    ${CSV_Content}    FPP_CDE_PORTFOLIO    &{Excelpath}[Row_No]
    
    Write Data To Excel    DWH_TC13    FPP_PID_FACILITY    ${rowid}    ${FPP_PID_FACILITY_Value}    ${DWHExcelPath}    
    Write Data To Excel    DWH_TC13    FPP_CDE_PORTFOLIO    ${rowid}    ${FPP_CDE_PORTFOLIO_Value}    ${DWHExcelPath}
          
    Validate the Portfolio in LIQ Facility Transaction    ${FPP_CDE_PORTFOLIO_Value}    ${FPP_PID_FACILITY_Value}
