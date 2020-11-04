*** Settings ***
Resource    ../../Configurations/LoanIQ_Import_File.robot
###Test Setup    Mx LoanIQ Launch    Processtimeout=600
###Test Teardown    Mx KillAllProcess    [chrome.exe, LoanIQJ.exe]

*** Variables ***
${rowid}    1
${SCENARIO}    3

*** Test Cases ***
# Create Customer within Loan IQ - ORIG03
#     [Documentation]    This keyword creates Customer within LoanIQ
#     ...    @author: ghabal
#     [Tags]    01 Create Customer within Loan IQ - ORIG03  
#     Mx Execute Template With Multiple Data    Create Customer within Loan IQ    ${ExcelPath}    ${rowid}    ORIG03_Customer

# Search Customer and Complete its Borrower Profile Creation - ORIG03        
#     [Documentation]    This keyword searches a customer and complete its Borrower Profile creation
#     ...    @author: ghabal
#     [Tags]    02 Complete Borrower's Profile - 0RIG03
#     Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile Creation with default values    ${ExcelPath}    ${rowid}    ORIG03_Customer
   
Deal Setup - CRED01
    [Tags]    03 Deal Setup - CRED01
    Mx Execute Template With Multiple Data    Create Deal - Baseline SBLC    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Setup Multi-Currency SBLC Facility    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
 
    Mx Execute Template With Multiple Data    Setup Fees for SBLC Facility     ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Setup a Primary Notebook - SBLC    ${ExcelPath}    ${rowid}    CRED01_DealSetup

SBLC Issuance
    [Tags]    04 SBLC Issuance - SERV05 
    Mx Execute Template With Multiple Data    SBLC Guarantee Issuance    ${ExcelPath}    ${rowid}    SERV05_SBLCIssuance
    Log to Console    Pause Execution - Run Daily EOD
    Pause Execution
        
SBLC Fee on Lender - CRE10       
    [Tags]    05 SBLC Fee on Lender - CRE10
    Mx Execute Template With Multiple Data    Initiate Fee On Lender Shares Payment    ${ExcelPath}    ${rowid}    SERV18_FeeOnLenderSharesPayment
       
Create Cashflow  
    [Tags]    06 Create Cashflow
    Mx Execute Template With Multiple Data    Create Issuance Payment Cashflow    ${ExcelPath}    ${rowid}    SERV24_CreateCashflow
    
Fee on Lender Payment
    [Tags]    07 Fee on Lender Shares
    Mx Execute Template With Multiple Data    Workflow Navigation For Fee On Lender Shares Payment     ${ExcelPath}    ${rowid}    SERV18_FeeOnLenderSharesPayment

Cycle Share Adjustment Setup - MTAM05A
    [Tags]    08 SBLC Fee on Lender - CRE10
    Mx Execute Template With Multiple Data    Create Cycle Share Adjustment    ${ExcelPath}    ${rowid}    MTAM05A_CycleShareAdjustment  

Set Up SBLC Decrease - SERV05
    [Tags]    09 SBLC Decrease
    Mx Execute Template With Multiple Data    Set Up SLBC Decrease    ${ExcelPath}    ${rowid}    SERV05_SBLCDecrease
