*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${row_id}    2

*** Test Cases ***

Initiate Agency Fee Payment for AHBDE
    [Documentation]    This test case will pay the Admin Fee Payment for Agency DE after 1 day EOD
    ...    @author: songchan    - Initial Create
    ...    NOTE: Pre-requisite to run DealCreation/Expanded_Scenario2_FromBorrower.robot for deal creation and 1 day EOD
    
    Mx Execute Template With Multiple Data    Admin Fee Payment for DNR    ${DNR_DATASET}    ${rowid}    SC2_AdminFeePayment