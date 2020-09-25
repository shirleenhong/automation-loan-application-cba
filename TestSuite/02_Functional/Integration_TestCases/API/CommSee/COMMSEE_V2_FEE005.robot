*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    2

*** Test Cases ***
   
Get Fee Details for SBLC Guarantee Cycle Start and End Dates for Single Accrual
    [Documentation]   This ComSee test case is used to get and validate Customer's Outstanding Fee Details before Issuance payment is made. 
    ...    Pre-requisite test case needed is COMMSEE_V2_OS003 and then single EOD for singe Accrual
    ...    author: cfrancis   22SEP2020    - Initial Create
    Mx Execute Template With Multiple Data    Update SBLC Guarantee Issuance - ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC3_Issuance
    Mx Execute Template With Multiple Data    Get and Validate API Fee Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC3_Issuance    