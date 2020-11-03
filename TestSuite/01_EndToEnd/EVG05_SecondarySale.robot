*** Settings ***
Resource    ../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    5

*** Test Cases ***
Create Quick Party Onboarding - PTY001
    [Tags]    01 Create Party within Common Party - PTY001
    Mx Execute Template With Multiple Data    Create Party in Quick Party Onboarding    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    
# Create Customer within Loan IQ - ORIG03
    # [Documentation]    This keyword creates Customer within LoanIQ
    # ...    when using this, the following keywords(validations) should be disabled in the succeeding keyword 'Search Customer and Complete its Borrower Profile Creation - ORIG03'
    # ...    -> Read Excel Data and Validate Customer ID, Short Name and Legal Name fields
    # ...    -> Check Legal Address Details Under Profiles Tab
    # ...    @author: ghabal
    # [Tags]    01 Create Customer within Loan IQ - ORIG03
    # Set Test Variable    ${rowid}    1
    # Mx Execute Template With Multiple Data    Create Customer within Loan IQ    ${ExcelPath}    ${rowid}    ORIG03_Customer

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
    Log to Console    Pause Execution - Run Monthly EOD
    Pause Execution

Ongoing Fee Payment for Bilateral Deal - SERV29
    [Tags]    07 Update and Pay the Commitment Fee - SERV29
    Mx Execute Template With Multiple Data    Update Commitment Fee Cycle    ${ExcelPath}    ${rowid}    SERV29_PaymentFees   
    Log to Console    Pause Execution - Run Daily EOD
    Pause Execution    
    Mx Execute Template With Multiple Data    Pay Commitment Fee Amount - Syndicated with Secondary Sale    ${ExcelPath}    ${rowid}    SERV29_PaymentFees

Create Comprehensive Repricing - SERV08C
    [Tags]    05 Create a Comprehensive Repricing of a Loan apart of Interest Payment - SERV08 & SERV21
    Mx Execute Template With Multiple Data    Create Comprehensive Repricing for Syndicated Deal - Secondary Sale    ${ExcelPath}    ${rowid}    SERV08C_ComprehensiveRepricing

Create Agency Fee Payment - SERV30
    [Tags]    08 Create Agency Fee Payment - SERV30
    Mx Execute Template With Multiple Data    Admin Fee Payment for Secondary Sale    ${ExcelPath}    ${rowid}    SERV30_AdminFeePayment 

Create Secondary Sale for Agency - TRP002
    [Tags]    09 Create a Secondary Sale for Loan and Commitment Fee Payment - TRP002
    Mx Execute Template With Multiple Data    Set up Secondary Sale for Agency    ${ExcelPath}    ${rowid}    TRP002_SecondarySale

Create Loan Share Adjustment - MTAM08
    [Tags]    10 Create Share Adjustment for a Loan within Lenders - MTAM08
    Mx Execute Template With Multiple Data    Loan Share Adjustment   ${ExcelPath}    ${rowid}    MTAM08_LoanShareAdjustment        

Create Term Loan Drawdown for Syndicated Deal in USD - SERV01
    [Tags]    11 Create Term Loan Drawdown for SYNDICATED deal in USD - SERV01
    Mx Execute Template With Multiple Data    Create Term Loan Drawdown for SYNDICATED deal in USD    ${ExcelPath}    ${rowid}    SERV01_TermLoanDrawdowninUSD
    Log to Console    Pause Execution - Run Daily EOD
    Pause Execution    
    
Create Repricing for Conversion of Interest Type - SERV10
    [Tags]    12 Create a Comprehensive Repricing of a Loan for conversion of interest type - SERV10
    Mx Execute Template With Multiple Data    Create Repricing for Conversion of Interest Type    ${ExcelPath}    ${rowid}    SERV10_ConversionOfInterestType