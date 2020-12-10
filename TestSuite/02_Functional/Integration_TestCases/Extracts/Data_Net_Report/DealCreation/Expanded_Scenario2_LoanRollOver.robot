*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    4

*** Test Cases ***
# Create Syndicated Deal for Loan Rollover for Expanded Scenario 2 Loan Roll Over
    # [Documentation]   This DNR test case is used to create a Syndicated Deal for Loan Rollover Report
    # [Tags]    01 Create Syndicated Deal for Loan Rollover for Expanded Scenario 2 Loan Roll Over
    # ...    author: makcamps    03DEC2020    - Initial Create
    # Mx Execute Template With Multiple Data    Setup Syndicated Deal for DNR    ${DNR_DATASET}    ${rowid}    SC2_DealSetup
    # Mx Execute Template With Multiple Data    Setup Deal Administrative Fees for DNR    ${DNR_DATASET}	${rowid}    SC2_AdminFee
    # Mx Execute Template With Multiple Data    Setup Deal Event Fees for DNR    ${DNR_DATASET}    ${rowid}    SC2_EventFee	
    # Mx Execute Template With Multiple Data    Setup Term Facility for Syndicated Deal for DNR    ${DNR_DATASET}    ${rowid}    SC2_FacilitySetup
    # Mx Execute Template With Multiple Data    Setup Fees for Term Facility for DNR    ${DNR_DATASET}    ${rowid}    SC2_OngoingFeeSetup
    # Mx Execute Template With Multiple Data    Setup Primaries for Syndicated Deal for DNR    ${DNR_DATASET}    ${rowid}    SC2_PrimaryAllocation        
    # Mx Execute Template With Multiple Data    Syndicated Deal Approval and Close for DNR    ${DNR_DATASET}    ${rowid}    SC2_PrimaryAllocation        

# Create Initial Loan Drawdown for Agency Syndication for Expanded Scenario 2 Loan Roll Over
    # [Documentation]   This DNR test case is used to create initial loan drawdown for Loan Rollover Report
    # ...    Prerequisite: complete run of Create Syndicated Deal for Loan Rollover for Expanded Scenario 2 Loan Roll Over
    # [Tags]    02 Create Initial Loan Drawdown for Agency Syndication for Expanded Scenario 2 Loan Roll Over
    # Mx Execute Template With Multiple Data    Create Initial Loan Drawdown for Agency Syndication for DNR    ${DNR_DATASET}   ${rowid}    SC2_LoanDrawdownNonAgent
    # Log To Console    Run 1 Month EOD
    # Pause Execution
    
Create Comprehensive Repricing for Syndicated Deal for Expanded Scenario 2 Loan Roll Over
    [Documentation]   This DNR test case is used to create comprehensive loan repricing for Loan Rollover Report
    ...    Prerequisite: Create Initial Loan Drawdown for Agency Syndication for Expanded Scenario 2 Loan Roll Over and 1 month EOD
    [Tags]    02 Create Initial Loan Drawdown for Agency Syndication for Expanded Scenario 2 Loan Roll Over
    Mx Execute Template With Multiple Data    Create Comprehensive Repricing for Agency Syndicated Deal for DNR    ${DNR_DATASET}   ${rowid}    SC2_ComprehensiveRepricing
    # Mx Execute Template With Multiple Data    Write Cashflow ID for Agency DE Report    ${DNR_DATASET}    ${rowid}    SC2_ComprehensiveRepricing
    
    # Set Global Variable    ${TestCase_Name}    AHBDE_003
    # Mx Execute Template With Specific Test Case Name    Write Filter Details for Agency Host Bank DE Extract Report in DNR Data Set    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    # Mx Execute Template With Specific Test Case Name    Generate DNR Report for Payment    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR