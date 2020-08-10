*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
#Test Teardown    Test Suite Tear Down

*** Variables ***
${rowid}    1
${SCENARIO}    3

*** Test Cases ***
#___Start of Day 1
Create Quick Party Onboarding - PTY001
    [Tags]    01 Create Party within Essence - PTY001
    Mx Execute Template With Multiple Data    Create Party in Quick Party Onboarding    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding

# Create Customer within Loan IQ - ORIG03
    # [Documentation]    This keyword creates Customer within LoanIQ
    # ...    @author: ghabal
    # [Tags]    01 Create Customer within Loan IQ - ORIG03  
    # Mx Execute Template With Multiple Data    Create Customer within Loan IQ    ${ExcelPath}    ${rowid}    ORIG03_Customer

Search Customer and Complete its Borrower Profile Creation - ORIG03
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation
    ...    @author: ghabal
    [Tags]    02 Complete Borrower's Profile - 0RIG03
    Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile Creation with default values    ${ExcelPath}    ${rowid}    ORIG03_Customer
   
Deal Setup - CRED01
    [Tags]    03 Deal Setup - CRED01        
    Mx Execute Template With Multiple Data    Create Deal - Baseline SBLC    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Setup Multi-Currency SBLC Facility    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Setup Fees for SBLC Facility     ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Setup a Primary Notebook - SBLC    ${ExcelPath}    ${rowid}    CRED01_DealSetup

SBLC Issuance
    [Tags]    04 SBLC Issuance - SERV05 
    Mx Execute Template With Multiple Data    SBLC Guarantee Issuance    ${ExcelPath}    ${rowid}    SERV05_SBLCIssuance
#___End of Day 1
