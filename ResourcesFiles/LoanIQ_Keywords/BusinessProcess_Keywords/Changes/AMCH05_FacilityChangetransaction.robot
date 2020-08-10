*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Extend Maturity Date
    [Documentation]    This Keyword modifies extends the Maturity Date of the specified Facility
    ...    @author: amansuet    24JUN2020    - updated and used 'Navigate to Facility Notebook' keyword
    [Arguments]    ${ExcelPath}
    
    ###Facility Notebook###
    Verify If Facility Window Does Not Exist
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    
    ###Facility Notebook###
    Add Facility Change Transaction
    
    ###Facility Change Transaction Notebook###
    ${MaturityDate}    Modify Maturity Date in Facility Change Transaction
    Write Data To Excel    AMCH05_ExtendMaturityDate    Maturity_Date    ${rowid}    ${MaturityDate}
    
    ###Facility Change Transaction Notebook###
    Send to Approval Facility Change Transaction
    
    ###Loan IQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###WIP - Facility Change Transaction Notebook###
    Approve Facility Change Transaction    &{ExcelPath}[Deal_Name]
    
    ###Loan IQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    #WIP - Facility Change Transaction Notebook
    Release Facility Change Transaction    &{ExcelPath}[Deal_Name]
    
    #Facility Notebook
    Validate Facility Change Transaction    ${MaturityDate}    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
