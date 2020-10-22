*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Validate VLS_FAC_PORT_POS Extract
    [Documentation]    This keyword is used to validate the FPP_CDE_PORTFOLIO  field in CSV vs LIQ Screen - Table Maintenance and in Portfolio Allocation Screen.  
    ...    @author: mgaling    03SEP2019    - initial create
    ...    @update: mgalling    14OCT2020    - updated documentation, added new keywords and removed keywords for reading and getting data from CSV file
    [Arguments]    ${Excelpath}
    
    ### Validate the values under FPP_CDE_PORTFOLIO column in LIQ - Portfolio Table ###
    Login to Loan IQ    ${Excelpath}[LIQ_Username]    ${Excelpath}[LIQ_Password]   
    Validate Portfolio Code Data from CSV in LIQ Screen    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[VLS_FAC_PORT_POS_CSV_FileName]&{ExcelPath}[Business_Date].csv
    
    ### Validate the value under FPP_CDE_PORTFOLIO column in LIQ Transaction ###
          
    Validate FPP_CDE_PORTFOLIO in LIQ Facility Portfolio Allocation    &{ExcelPath}[CSV_FilePath]&{ExcelPath}[Business_Date]\\&{ExcelPath}[VLS_FAC_PORT_POS_CSV_FileName]&{ExcelPath}[Business_Date].csv
    Logout From Loan IQ