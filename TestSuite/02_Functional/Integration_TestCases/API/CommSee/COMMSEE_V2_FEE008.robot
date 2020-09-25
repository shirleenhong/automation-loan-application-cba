*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    2

*** Test Cases ***

Get Fee Details for Non-Zero Accrued to Date and Paid to Date for Single Accrual
    [Documentation]   This CommSee test case is used to get the Customer's Ongoing Fee details that has Bilateral Deal with One Borrower and One Facility in it.
    ...    Pre-requisite test case is COMMSEE_V2_FEE01 and then run EOD to get a single accrual cycle item
    ...    @author: cfrancis    21SEP2020    - Initial Create
    Mx Execute Template With Multiple Data    Write Facility Ongoing Fee Details - Scenario 7 ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup 
    Mx Execute Template With Multiple Data    Get and Validate API Fee Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC7_FacFeeSetup