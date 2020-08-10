*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    6

*** Test Cases ***
Create Quick Party Onboarding - PTY001
    [Tags]    01 Create Party within Essence - PTY001                  
    Mx Execute Template With Multiple Data    Create Party in Quick Party Onboarding    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding

Create Customer within Loan IQ - ORIG03
    [Documentation]    This keyword creates Customer within LoanIQ
    ...    @author: ghabal
    [Tags]    01 Create Customer within Loan IQ - ORIG03
    Mx Execute Template With Multiple Data    Create Customer within Loan IQ    ${ExcelPath}    ${rowid}    ORIG03_Customer
    
Search Customer and Complete its Borrower Profile Creation - ORIG03
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation
    ...    @author: ghabal
    [Tags]    02 Complete Borrower's Profile - 0RIG03
    Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile Creation with default values    ${ExcelPath}    ${rowid}    ORIG03_Customer
       
Bilateral Deal with Multiple Risk Type        
    [Documentation]    This keyword will be used to create Bilateral deal for Scenario 6
    ...    @author: ritragel  
    [Tags]    03 Create Bilateral Deal with Multiple Risk Type - CRE06
    Mx Execute Template With Multiple Data    Setup Bilateral Deal with Multiple Risk Type    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Add Pricing Option for Bilateral Deal with MultiRisk Types    ${ExcelPath}    101-105    CRED01_PricingOption
    Mx Execute Template With Multiple Data    Setup Multi-Currency and Multi-Risk Revolver Facility    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Setup Interest Pricing Fees for Multi-Currency and Multi-Risk Revolver Facility    ${ExcelPath}    101-104    CRED08_RevFacilityInterestFee
    Mx Execute Template With Multiple Data    Setup Ongoing Fees for Multi-Currency and Multi-Risk Revolver Facility    ${ExcelPath}    ${rowid}    CRED08_RevFacilityOngoingFee
    Mx Execute Template With Multiple Data    Setup Multi-Currency and Multi-Risk Term Facility   ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Setup Interest Pricing Fees for Multi-Currency and Multi-Risk Term Facility   ${ExcelPath}    101-104    CRED08_TermFacilityInterestFee
    Mx Execute Template With Multiple Data    Setup Ongoing Fees for Multi-Currency and Multi-Risk Term Facility    ${ExcelPath}    ${rowid}    CRED08_TermFacilityOngoingFee
    Mx Execute Template With Multiple Data    Create Commitment Schedule in Facility    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Setup a Primary Notebook for Multiple Risk Types Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup 
       
Loan Drawdown with Flex Schedule for Fixed P&I Repayment
    [Tags]    04 Create Loan Drawdown with Flex Schedule - DRAW_CRE06
    Mx Execute Template With Multiple Data    Create Loan Drawdown with Flex Schedule for Fixed P&I Repayment    ${ExcelPath}   ${rowid}    SERV_47_FlexPISchedule   
     
SBLC Guarantee Issuance with Multiple Risk Types for Bilateral Deal
    [Tags]    05 Create SBLC Guarantee - DRAW_CRE01
    Mx Execute Template With Multiple Data    SBLC Guarantee Issuance for Bilateral Deal with Multiple Risk Types    ${ExcelPath}   ${rowid}    SERV05_SBLCIssuance
    
