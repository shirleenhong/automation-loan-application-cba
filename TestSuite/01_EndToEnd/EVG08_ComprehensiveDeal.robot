*** Settings ***
Resource    ../../Configurations/LoanIQ_Import_File.robot


*** Variables ***
${rowid}    1
${SCENARIO}    8


*** Test Cases ***
### DAY 1
Create Quick Party Onboarding - PTY001
    [Tags]    01 Create Party within Essence - PTY001
    Mx Execute Template With Multiple Data    Create Party in Quick Party Onboarding    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    
# Create Customer within Loan IQ - ORIG03 
    # [Documentation]    This keyword creates Customer within LoanIQ
    # ...    when using this, the following keywords(validations) should be disabled in the succeeding keyword 'Search Customer and Complete its Borrower Profile Creation - ORIG03'
    # ...    -> Read Excel Data and Validate Customer ID, Short Name and Legal Name fields
    # ...    -> Check Legal Address Details Under Profiles Tab
    # ...    @author: ghabal
    # [Tags]    01 Create Customer within Loan IQ - ORIG03
    # Mx Execute Template With Multiple Data    Create Customer within Loan IQ    ${ExcelPath}    ${rowid}    ORIG03_Customer
    
Search Customer and Complete its Borrower Profile Creation for Comprehensive Deal - ORIG03
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation for Comprehensive Deal
    ...    @author: ghabal
    [Tags]    02 Complete Borrower's Profile - 0RIG03
    Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile Creation for Comprehensive Deal    ${ExcelPath}    ${rowid}    ORIG03_Customer
    
Setup TL API
    Mx Execute Template With Multiple Data    Send a Valid GS File    ${ExcelPath}    1    BaseRate_Fields
    Mx Execute Template With Multiple Data    Send FXRates GS Group 1 File    ${ExcelPath}    1    FXRates_Fields
    
Deal, Facility, Fees Setup
    [Tags]    CRED01, CRED08
    Mx Execute Template With Multiple Data    Setup Comprehensive Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Setup Admin Fees for Comprehensive Deal    ${ExcelPath}    ${rowid}    CRED09_AdminFee
    Mx Execute Template With Multiple Data    Setup Financial Ratio, Fees and Pricing Options for Comprehensive Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Setup Term Facility for Comprehensive Deal    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Setup Fees and Interest for Term Facility    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Setup Revolver Facility for Comprehensive Deal    ${ExcelPath}    2    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Setup Fees and Interest for Revolver Facility    ${ExcelPath}    2    CRED08_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Setup Primary for Comprehensive Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Setup Ticking Fee    ${ExcelPath}    ${rowid}    CRED08_TickingFee
    Mx Execute Template With Multiple Data    Approve and Close Comprehensive Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    
## DAY 2
EOD Batch for Day 2
    Mx Execute Template With Multiple Data    Execute EOD - Daily   ${ExcelPath}    ${rowid}    Batch_EOD
    
Ticking Fee Payment
    [Tags]    04 Ticking Fee Payment - SYND04
    Mx Execute Template With Multiple Data    Create Payment For Ticking Fee    ${ExcelPath}    ${rowid}    SYND04_TickingFeePayment
    
Secondary Sale
    [Tags]    TRPO02
    Mx Execute Template With Multiple Data    Secondary Sale for Comprehensive Deal   ${ExcelPath}    ${rowid}    TRP002_SecondarySale
    
Portfolio Transfer
    [Tags]    TRPO11
    Mx Execute Template With Multiple Data    Portfolio Transfer    ${ExcelPath}    ${rowid}    PTRF_CRE01_PortfolioTransfer
    
First Term Facility Drawdown
    [Tags]    SERV01A
    Mx Execute Template With Multiple Data    Create First Term Facility Loan Drawdown    ${ExcelPath}    ${rowid}    SERV01_LoanDrawdown
    
Second Term Facility Drawdown
    [Tags]    SERV01A
    Mx Execute Template With Multiple Data    Send a Valid GS File    ${ExcelPath}    2    BaseRate_Fields
    Mx Execute Template With Multiple Data    Create Second Term Facility Loan Drawdown    ${ExcelPath}    2    SERV01_LoanDrawdown
    
Deal Change Transaction On Financial Ratio
    [Tags]    AMCH04
    Mx Execute Template With Multiple Data    Deal Change Transaction on Financial Ratio    ${ExcelPath}    ${rowid}    DLCH01_DealChangeTransaction
    
    
    
### DAY 3
EOD Batch for Day 3
    Mx Execute Template With Multiple Data    Execute EOD - Daily   ${ExcelPath}    ${rowid}    Batch_EOD
    
Revolver Facility Drawdown
    [Tags]    SERV01A
    Mx Execute Template With Multiple Data    Create Revolver Facility Drawdown    ${ExcelPath}    3    SERV01_LoanDrawdown
    
Pricing Change Transaction
    [Tags]    AMCH06
    Mx Execute Template With Multiple Data    Facility Interest Pricing Change for Comprehensive Deal    ${ExcelPath}    ${rowid}    AMCH06_PricingChangeTransaction
    
    
    
### DAY 4
EOD Batch for Day 4
    Mx Execute Template With Multiple Data    Execute EOD - Daily   ${ExcelPath}    ${rowid}    Batch_EOD

Create Loan Split
    [Tags]    SERV12
    Mx Execute Template With Multiple Data    Send a Valid GS File    ${ExcelPath}    3    BaseRate_Fields
    Mx Execute Template With Multiple Data    Send FXRates GS Group 1 File    ${ExcelPath}    2    FXRates_Fields
    Mx Execute Template With Multiple Data    Create Loan Split    ${ExcelPath}   ${rowid}    SERV12_LoanSplit
    
Create Unscheduled Facility Increase
    [Tags]    AMCH03
    Mx Execute Template With Multiple Data    Create Unscheduled Facility Increase     ${ExcelPath}    ${rowid}    AMCH03_UnschedFacilityIncrease
    
           
    
### DAY 5
EOD Batch for Day 5
    Mx Execute Template With Multiple Data    Execute EOD - Daily   ${ExcelPath}    ${rowid}    Batch_EOD

Create Loan Merge - SERV11
    [Tags]    SERV11
    Mx Execute Template With Multiple Data    Send a Valid GS File    ${ExcelPath}    4    BaseRate_Fields
    Mx Execute Template With Multiple Data    Create Loan Merge    ${ExcelPath}   ${rowid}    SERV11_Loan Amalgamation
    
    
    
### DAY 6
EOD Batch for Day 6
    Mx Execute Template With Multiple Data    Execute EOD - Daily   ${ExcelPath}    ${rowid}    Batch_EOD
    
Create Interest Capitalisation Rule at Outstanding level (Advance Servicing) - CAP02
    [Documentation]    This keyword create Interest Capitalisation Rule at Outstanding level (Advance Servicing)
    ...    @author: ghabal
    [Tags]    Create Interest Capitalisation Rule at Outstanding level (Advance Servicing) - CAP02
    Mx Execute Template With Multiple Data    Create Interest Capitalisation Rule    ${ExcelPath}    ${rowid}    CAP02_InterestCapitalRule
    
Setup Ongoing Fee Capitalization Fee Level
    [Tags]    CAP03
    Mx Execute Template With Multiple Data    Setup Line Fee Capitalization    ${ExcelPath}    ${rowid}    CAP03_OngoingFeeCapitalization

Manual GL For Upfront Fee Payment
    [Tags]    MTAM01
    Mx Execute Template With Multiple Data    Manual GL Transaction for Fee Payment    ${ExcelPath}    ${rowid}    MTAM01_ManualGL
    
Manual Cashflow For Upfront Fee Payment
    [Tags]    MTAM02
    Mx Execute Template With Multiple Data    Manual Cashflow for Upfront Fee Payment     ${ExcelPath}    ${rowid}    MTAM02_ManualCashflow
    
    
    
### DAY 7
EOD Batch for Day 7
    Mx Execute Template With Multiple Data    Execute EOD - Daily   ${ExcelPath}    ${rowid}    Batch_EOD
    
Process Interest Payment for Capitalize Interest - CAP03
    [Documentation]    This keyword is used to process Interest Payment for Capitalize Interest (CAP03)
    ...    @author: ghabal
    [Tags]    Process Interest Payment for Capitalize Interest - CAP03
    Mx Execute Template With Multiple Data    Process Interest Payment for Capitalize Interest    ${ExcelPath}    ${rowid}    CAP03_InterestPayment
    
Capitalized Ongoing Fee Payment
    [Tags]    CAP02
    Mx Execute Template With Multiple Data    Capitalized Ongoing Fee Payment    ${ExcelPath}    ${rowid}    CAP02_CapitalizedFeePayment

Perform Principal Payment for Comprehensive Deal
    [Tags]    SERV18
    Mx Execute Template With Multiple Data    Principal Payment for Comprehensive Deal    ${ExcelPath}   ${rowid}    SERV18_Payments
 
    
    
    
