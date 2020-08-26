*** Settings ***
Resource    ../../Configurations/LoanIQ_Import_File.robot
# Suite Setup    Launch LoanIQ Application    ${LoanIQPath}
# Suite Teardown    Close Application Via CMD   ${LoanIQ}
# Test Setup    Fail if Previous Test Case Failed


*** Variables ***
${rowid}    1

*** Test Cases ***
###Pre-requisuites####
#   a. Two Lenders are created
#   b. Remittance Description for Two Lenders are updated on data set    
  
# Create Quick Party Onboarding for CBA UAT Deal 1 - PTY001
    # [Tags]    01 Create Party within Essence - PTY001
    # Mx Execute Template With Multiple Data    Create Deal Borrower initial details in Quick Party Onboarding for D00000454    ${CBAUAT_ExcelPath}    1    PTY001_QuickPartyOnboarding
    # Mx Execute Template With Multiple Data    Populate Quick Enterprise Party with Approval    ${CBAUAT_ExcelPath}    1    PTY001_QuickPartyOnboarding

# Search Customer and Complete its Borrower Profile Creation - ORIG03
    # [Tags]    02 Complete Borrower's Profile - 0RIG03
    # Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile Creation with default values for Deal Template One    ${CBAUAT_ExcelPath}    1    ORIG03_Customer

Deal Template D00000454
    [Tags]    03 Deal Setup - CRED01
    Mx Execute Template With Multiple Data    Setup Deal D00000454    ${CBAUAT_ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Setup Deal D00000454 Interest Pricing Options    ${CBAUAT_ExcelPath}    1-2    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Setup Deal Amortizing Admin Fee    ${CBAUAT_ExcelPath}    1    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Setup Facility Template D00000454-1    ${CBAUAT_ExcelPath}    1    CRED02_FacilitySetup
    Navigate to Interest Pricing
    Mx Execute Template With Multiple Data    Add Interest Pricing Matrix Facility D00000454    ${CBAUAT_ExcelPath}    3-7    CRED08_FacilityFeeSetup
    Navigate to Ongoing Fees
    Mx Execute Template With Multiple Data    Setup Ongoing Fees for Facility D00000454    ${CBAUAT_ExcelPath}    3    CRED08_FacilityFeeSetup
    Mx Execute Template With Multiple Data    Add Multiple Ratio for Facility D00000454    ${CBAUAT_ExcelPath}    4-7    CRED08_FacilityFeeSetup
    Mx Execute Template With Multiple Data    Validate Interest Pricing    ${CBAUAT_ExcelPath}    7    CRED08_FacilityFeeSetup
    Mx Execute Template With Multiple Data    Setup Facility Fees D00000454    ${CBAUAT_ExcelPath}    1    CRED08_FacilityFeeSetup
    Mx Execute Template With Multiple Data    Setup Facility Template D00000454-1    ${CBAUAT_ExcelPath}    2    CRED02_FacilitySetup
    Navigate to Interest Pricing
    Mx Execute Template With Multiple Data    Add Interest Pricing Matrix Facility D00000454    ${CBAUAT_ExcelPath}    8-12    CRED08_FacilityFeeSetup
    Navigate to Ongoing Fees
    Mx Execute Template With Multiple Data    Setup Ongoing Fees for Facility D00000454    ${CBAUAT_ExcelPath}    8    CRED08_FacilityFeeSetup
    Mx Execute Template With Multiple Data    Add Multiple Ratio for Facility D00000454    ${CBAUAT_ExcelPath}    9-12    CRED08_FacilityFeeSetup
    Mx Execute Template With Multiple Data    Setup Additional Ongoing Fee    ${CBAUAT_ExcelPath}    13    CRED08_FacilityFeeSetup
    Mx Execute Template With Multiple Data    Setup Facility Fees D00000454    ${CBAUAT_ExcelPath}    2    CRED08_FacilityFeeSetup
    Mx Execute Template With Multiple Data    Setup Initial Primary Details for D00000454    ${CBAUAT_ExcelPath}    1    CRED01_Primaries
    Mx Execute Template With Multiple Data    Setup Multiple Facility Sell Amounts for D00000454    ${CBAUAT_ExcelPath}    1    CRED01_Primaries
    Mx Execute Template With Multiple Data    Complete Primaries for D00000454    ${CBAUAT_ExcelPath}    1    CRED01_Primaries
    Mx Execute Template With Multiple Data    Setup Initial Primary Details for D00000454    ${CBAUAT_ExcelPath}    2    CRED01_Primaries
    Mx Execute Template With Multiple Data    Setup Multiple Facility Sell Amounts for D00000454    ${CBAUAT_ExcelPath}    2    CRED01_Primaries
    Mx Execute Template With Multiple Data    Complete Primaries for D00000454    ${CBAUAT_ExcelPath}    2    CRED01_Primaries
    Mx Execute Template With Multiple Data    Setup Initial Primary Details for D00000454    ${CBAUAT_ExcelPath}    3    CRED01_Primaries
    Mx Execute Template With Multiple Data    Setup Multiple Facility Sell Amounts for D00000454    ${CBAUAT_ExcelPath}    3    CRED01_Primaries
    Mx Execute Template With Multiple Data    Complete Primaries for D00000454    ${CBAUAT_ExcelPath}    3    CRED01_Primaries
    Mx Execute Template With Multiple Data    Update Ongoing Fee Cycle for UAT Deal    ${CBAUAT_ExcelPath}    1-2    SERV29_CommitmentFeePayment
    Mx Execute Template With Multiple Data    Create Upfront Fee for D00000454    ${CBAUAT_ExcelPath}    1    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Settlement Approval for D00000454    ${CBAUAT_ExcelPath}    1    CRED01_Primaries
    Mx Execute Template With Multiple Data    Approve and Close UAT Deal    ${CBAUAT_ExcelPath}    1    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Commitment Fee Release for D00000454    ${CBAUAT_ExcelPath}    1    SERV29_CommitmentFeePayment
    Mx Execute Template With Multiple Data    Line Fee Release for D00000454    ${CBAUAT_ExcelPath}    2    SERV29_CommitmentFeePayment
    
Collect Commitment Fee for Facility A - D00000454 - 30NOV2018
    Pause Execution  # eod to 30NOV2018 #
    Mx Execute Template With Multiple Data    Commitment Fee Payment for D00000454    ${CBAUAT_ExcelPath}   1    SERV29_CommitmentFeePayment
  
Collect Line Fee for Facility B - D00000454 - 30NOV2018
    Mx Execute Template With Multiple Data    Line Fee Payment for D00000454    ${CBAUAT_ExcelPath}   2    SERV29_CommitmentFeePayment

Create Outstandings A1, A2 and B1
    Pause Execution  # eod to 12DEC2018 #
    Mx Execute Template With Multiple Data    Setup Deal D00000454 Outstandings with Multiple Lenders    ${CBAUAT_ExcelPath}    1,2    SERV01_LoanDrawdown     
    Pause Execution  # eod to 27DEC2018 #
    Mx Execute Template With Multiple Data    Setup Deal D00000454 Outstandings    ${CBAUAT_ExcelPath}    3    SERV01_LoanDrawdown
        
Collect Commitment Fee for Facility A - D00000454 - 31DEC2018
    Mx Execute Template With Multiple Data    Run Online Accrual for Commitment Fee    ${CBAUAT_ExcelPath}   3    SERV29_CommitmentFeePayment
    Mx Execute Template With Multiple Data    Run Online Accrual for Line Fee    ${CBAUAT_ExcelPath}   4    SERV29_CommitmentFeePayment
    Pause Execution  # eod to 31DEC2018 # 
