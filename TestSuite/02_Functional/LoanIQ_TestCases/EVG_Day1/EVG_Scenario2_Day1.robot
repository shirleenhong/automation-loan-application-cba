*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
#Test Teardown    Test Suite Tear Down

*** Variables ***
${rowid}    1
${SCENARIO}    2

*** Test Cases ***
Create Quick Party Onboarding - PTY001
    [Tags]    01 Create Party within Essence - PTY001
    Mx Execute Template With Multiple Data    Create Party in Quick Party Onboarding    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
          
# Create Customer within Loan IQ - ORIG03
    # [Tags]    01 Create Customer within Loan IQ - ORIG03
    # Mx Execute Template With Multiple Data    Create Customer within Loan IQ    ${ExcelPath}    ${rowid}    ORIG03_Customer
    
# Search Customer and Complete its Borrower Profile Creation - ORIG03        
    # [Tags]    02 Complete Borrower's Profile - 0RIG03
    # Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile Creation with default values    ${ExcelPath}    ${rowid}    ORIG03_Customer
    
Create Syndicated Deal - CRED01
    [Tags]    03 Deal Setup (Syndicated)
    Mx Execute Template With Multiple Data    Setup Syndicated Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Setup Deal Administrative Fees    ${ExcelPath}	${rowid}    CRED09_AdminFee
    Mx Execute Template With Multiple Data    Setup Deal Event Fees    ${ExcelPath}    ${rowid}    CRED10_EventFee
    # Mx Execute Template With Multiple Data    Setup Deal Upfront Fees and Bank Role    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Setup Term Facility for Syndicated Deal    ${ExcelPath}    ${rowid}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Setup Fees for Term Facility    ${ExcelPath}    ${rowid}    CRED08_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Setup Primaries for Syndicated Deal    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Syndicated Deal Approval and Close    ${ExcelPath}    ${rowid}    CRED01_DealSetup
    
Change Agency Fee Transaction - AMHC10
    [Tags]    04 User is able to change AGENCY FEE transaction - AMCH10
    Mx Execute Template With Multiple Data    Change Agency Fee    ${ExcelPath}    ${rowid}    AMCH10_ChangeAgencyFee
    
Create Term and SBLC Loan Drawdown for Syndicated Deal - SERV01A
    [Tags]    05 User is able to create TERM and SBLC Loan Drawdown for SYNDICATED deal - SERV01A
    Mx Execute Template With Multiple Data    Create Loan Drawdown TERM and SBLC for Syndicated Deal    ${ExcelPath}    ${rowid}    SERV01A_LoanDrawdown  
      
Verify Facility Share Adjustments - MTAM07
    [Tags]    06 User is able to do Adjustments in the Facility Shares - MTAM07
    Mx Execute Template With Multiple Data    Adjust Facility Lender Shares For Syndicated Deal    ${ExcelPath}    ${rowid}    MTAM07_FacilityShareAdjustment
    
Initiate Ongoing Fee Payment - SERV29
    [Tags]    09 perform Ongoing Fee Payment on Syndicated Dea (SERV29)
    Mx Execute Template With Multiple Data    Update Commitment Fee Cycle    ${ExcelPath}    ${rowid}    SERV29_PaymentFees
    Mx Execute Template With Multiple Data    Update Indemnity Fee Cycle    ${ExcelPath}    ${rowid}    SERV29_PaymentFees
    Log to Console    Pause Execution - Run Daily EOD
