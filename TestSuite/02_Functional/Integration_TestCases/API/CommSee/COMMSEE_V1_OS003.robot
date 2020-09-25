*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***

Create Deal for SBLC Issuance
    [Documentation]   This ComSee test case is used to create a Bilateral Deal specific to SBLC Outstanding.
    ...    author: rtarayao    21AUG2019    - Initial Create
    
    Mx Execute Template With Multiple Data    Create Deal Setup for SBLC - ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC3_Deal
    Mx Execute Template With Multiple Data    Setup Multi-Currency SBLC Facility - ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC3_FacSetup
    Mx Execute Template With Multiple Data    Setup Issuance Fee for Facility - ComSee     ${ComSeeDataSet}    ${rowid}    ComSee_SC3_FacFeeSetup
    Mx Execute Template With Multiple Data    Setup a Primary Notebook with SBLC - ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC3_Deal
    
Get Outstanding SBLC Guarantee using V1 Endpoint
    [Documentation]   This ComSee test case is used to get and validate Customer's Outstanding Details before Issuance payment is made. 
    ...    author: rtarayao    21AUG2019    - Initial Create
    Mx Execute Template With Multiple Data    Create SBLC Guarantee Issuance - ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC3_Issuance
    Mx Execute Template with Multiple Data    Get and Validate API Outstanding Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC3_Issuance
    # Mx Execute Template With Multiple Data    Get and Validate API Fee Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC3_Issuance    
    # Log to Console    Pause Execution - Run Daily EOD
    # Pause Execution
    
# Get Outstanding Fee Details After Payment for SBLC Guarantee
    # [Documentation]   This ComSee test case is used to get and validate Customer's Outstanding and Outstanding Fee Details after Issuance payment is made.  
    # ...    author: rtarayao    21AUG2019    - Initial Create
    # Mx Execute Template With Multiple Data    Pay SBLC Issuance - ComSee    ${ComSeeDataSet}    ${rowid}    ComSee_SC3_IssuanceFeePayment        
    # Mx Execute Template with Multiple Data    Get and Validate API Outstanding Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC3_IssuanceFeePayment
    # Mx Execute Template With Multiple Data    Get and Validate API Fee Response    ${ComSeeDataSet}    ${rowid}    ComSee_SC3_IssuanceFeePayment