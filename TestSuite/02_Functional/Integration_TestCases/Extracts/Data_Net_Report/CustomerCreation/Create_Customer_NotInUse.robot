*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***

Create Customer Not In Use
    [Documentation]    This test case is used to create Customer in LIQ with 'Not In Use' status.
    ...    @author: clanding    04DEC2020    - initial create
    
    Set Global Variable    ${rowid}    1
    Mx Execute Template With Multiple Data    Create Customer within Loan IQ for DNR   ${DNR_DATASET}    ${rowid}    SC1_Customer
    Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile Creation Until Location for DNR   ${DNR_DATASET}    ${rowid}    SC1_Customer