*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1 

*** Test Case ***

Create Syndicated Deal for Agent Host Bank Cashout Report
    [Documentation]   This DNR test case is used to create a Syndicated Deal for creation of initial Loan Drawdown and Agent Host Bank Cashout Report generation
    ...    author: shirhong    24NOV2020    - Initial Create

    Mx Execute Template With Multiple Data    Setup Syndicated Deal for DNR    ${DNR_DATASET}    ${rowid}    SC2_DealSetup
    Mx Execute Template With Multiple Data    Setup Deal Administrative Fees for DNR    ${DNR_DATASET}	${rowid}    SC2_AdminFee
    Mx Execute Template With Multiple Data    Setup Deal Event Fees for DNR    ${DNR_DATASET}    ${rowid}    SC2_EventFee	
    Mx Execute Template With Multiple Data    Setup Term Facility for Syndicated Deal for DNR    ${DNR_DATASET}    ${rowid}    SC2_FacilitySetup
    Mx Execute Template With Multiple Data    Setup Fees for Term Facility for DNR    ${DNR_DATASET}    ${rowid}    SC2_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Setup Primaries for Syndicated Deal for DNR    ${DNR_DATASET}    ${rowid}    SC2_PrimaryAllocation        
    Mx Execute Template With Multiple Data    Syndicated Deal Approval and Close for DNR    ${DNR_DATASET}    ${rowid}    SC2_PrimaryAllocation        
