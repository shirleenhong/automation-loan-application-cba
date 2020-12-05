*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

CMMNT_010_Add
    [Documentation]    This test case is used to verify that the appropriate Comments are displayed in the report even when the customer is without deal & facility information.
    ...    @author: clanding    04DEC2020    - initial create
    
    Set Global Variable    ${rowid}    1
    Set Global Variable    ${TestCase_Name}    CMMNT_010
    Mx Execute Template With Multiple Data    Create Customer within Loan IQ for DNR   ${DNR_DATASET}    ${rowid}    SC1_Customer
    Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile Creation Until Location for DNR   ${DNR_DATASET}    ${rowid}    SC1_Customer
    Mx Execute Template With Multiple Data    Add Comments in Customer for DNR   ${DNR_DATASET}    ${rowid}    SC1_Customer
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Comments    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Comments Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Validate Comments Details for Customer are Correct from Comments Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    CMMNT

CMMNT_010_Update
    [Documentation]    This test case is used to verify that the appropriate Comments are displayed in the report even when the customer is without deal & facility information.
    ...    @author: clanding    04DEC2020    - initial create
    
    Set Global Variable    ${rowid}    1
    Set Global Variable    ${TestCase_Name}    CMMNT_010_Update
    Mx Execute Template With Multiple Data    Update Comments in Customer for DNR   ${DNR_DATASET}    ${rowid}    SC1_Customer
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Comments    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Comments Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Validate Comments Details for Customer are Correct from Comments Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    CMMNT