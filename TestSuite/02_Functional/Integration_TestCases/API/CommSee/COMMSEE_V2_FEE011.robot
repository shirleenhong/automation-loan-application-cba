*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    2

*** Test Cases ***
   
Get Outstanding and Fee Details Before Payment for SBLC Guarantee
    [Documentation]   This ComSee test case is used to get and validate Customer's Outstanding and Outstanding Fee Details before Issuance payment is made. 
    ...    Pre-requisite test case needed is COMMSEE_V2_OS003 and then EOD to be performed if you want cycle due amount to be non zero
    ...    author: cfrancis   16SEP2020    - Initial Create
    Mx Execute Template With Multiple Data    Update SBLC Guarantee Issuance - ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC3_Issuance
    Mx Execute Template With Multiple Data    Get and Validate API Fee Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC3_Issuance    