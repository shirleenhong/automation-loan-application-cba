*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    5

*** Test Cases ***
### Start of Day 1 ###
Create Quick Party Onboarding - PTY001
    [Tags]    01 Create Party within Common Party - PTY001
    Mx Execute Template With Multiple Data    Create Party in Quick Party Onboarding    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    
### Create Customer within Loan IQ - ORIG03
    ### [Documentation]    This keyword creates Customer within LoanIQ
    ### ...    when using this, the following keywords(validations) should be disabled in the succeeding keyword 'Search Customer and Complete its Borrower Profile Creation - ORIG03'
    ### ...    -> Read Excel Data and Validate Customer ID, Short Name and Legal Name fields
    ### ...    -> Check Legal Address Details Under Profiles Tab
    ### ...    @author: ghabal
    ### [Tags]    01 Create Customer within Loan IQ - ORIG03
    ### Set Test Variable    ${rowid}    5
    ### Mx Execute Template With Multiple Data    Create Customer within Loan IQ    ${ExcelPath}    ${rowid}    ORIG03_Customer

Search Customer and Complete its Borrower Profile Creation - ORIG03
    [Tags]    02 Search customer and complete its Borrower Profile creatio - ORIG03
    Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile Creation with default values   ${ExcelPath}    ${rowid}    ORIG03_Customer  

Create Deal for Secondary Sale - CRED01
    [Tags]    03 Create Deal for Secondary Sale - CRED01
    Mx Execute Template With Multiple Data    Setup Syndicated Deal For Secondary Sale    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Setup Deal Agency Fee    ${ExcelPath}    ${rowid}    CRED09_AdminFee
    Mx Execute Template With Multiple Data    Setup Event Fee For Syndicated Deal With Secondary Sale    ${ExcelPath}    ${rowid}    CRED10_EventFee
    Mx Execute Template With Multiple Data    Setup Bank Role Syndicated Deal With Secondary Sale    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Setup Term Facility for Syndicated Deal    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Setup Fees for Term Facility    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Setup Primaries For Syndicated Deal With Secondary Sale    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Syndicated Deal Approval and Close    ${ExcelPath}    ${rowid}    CRED01_DealSetup

Setup Interest Capitalization - SERV13
    [Tags]    04 Setup Loan Drawdown with Interest Capitalization Rule - SERV13
    Mx Execute Template With Multiple Data    Setup Interest Capitalization    ${ExcelPath}    ${rowid}    SERV13_InterestCapitalization
