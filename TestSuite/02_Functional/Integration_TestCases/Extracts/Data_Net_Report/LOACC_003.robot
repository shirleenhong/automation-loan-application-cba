*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
LOACC_003
    [Documentation]    This test case is used to verify following date fields in the report.
    ...    Fields to Validate in Facilities and Outstandings sheets: Business Date, Facility Start Date, Facility Maturity Date, Outstanding Start, 
    ...    Repricing Date, Outstanding Cycle Start Date, Outstanding Cycle End Date, Outstanding Cycle Due Date
    ...    NOTE: Loans and Accruals Report should be available already in the report path.
    ...    @author: ccarriedo    14DEC2020    - initial create

    Set Global Variable    ${rowid}    1
    Set Global Variable    ${TestCase_Name_Facilities}    LOACC_003_Facilities
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Loans and Accruals    ${DNR_DATASET}    Test_Case    ${TestCase_Name_Facilities}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Loans and Accruals Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name_Facilities}    DNR
    Mx Execute Template With Specific Test Case Name    Validate Date Fields from Loans and Accruals Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name_Facilities}    LOACC
    
    Set Global Variable    ${TestCase_Name_Outstandings}    LOACC_003_Outstandings    
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Loans and Accruals    ${DNR_DATASET}    Test_Case    ${TestCase_Name_Outstandings}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Loans and Accruals Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name_Outstandings}    DNR  
    Mx Execute Template With Specific Test Case Name    Validate Date Fields from Loans and Accruals Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name_Outstandings}    LOACC
