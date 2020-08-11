*** Settings ***
Resource    ../../Configurations/Import_File.robot
#Suite Setup    Launch LoanIQ Application    ${LoanIQPath}
#Suite Teardown    Close Application Via CMD   ${LoanIQ}
# Test Setup    Fail if Previous Test Case Failed


*** Variables ***
${rowid}    1


*** Test Cases ***   
Create Quick Party Onboarding for CBA UAT Deal 2 - PTY001    
    [Tags]    01 Create Party within Essence - PTY001
    Mx Execute Template With Multiple Data    Create Deal Borrower initial details in Quick Party Onboarding for BEPTYLTDATF    ${CBAUAT_ExcelPath}    1    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Populate Quick Enterprise Party with Approval for BEPTYLTDATF    ${CBAUAT_ExcelPath}    1    PTY001_QuickPartyOnboarding    

Search Customer and Complete its Borrower Profile Creation - ORIG03
    [Tags]    02 Complete Borrower's Profile - 0RIG03
    Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile Creation with default values for Deal Template Two    ${CBAUAT_ExcelPath}    ${rowid}    ORIG03_Customer
    
Setup Deal
    [Tags]    03 Deal Setup - CRED01
    Mx Execute Template With Multiple Data    Setup Deal D00001053    ${CBAUAT_ExcelPath}    1    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Setup Facility Template D00001053    ${CBAUAT_ExcelPath}    1    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Setup Facility Fees D00001053    ${CBAUAT_ExcelPath}    1    CRED08_FacilityFeeSetup
    Mx Execute Template With Multiple Data    Setup Facility Template D00001053    ${CBAUAT_ExcelPath}    2    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Setup Facility Fees D00001053    ${CBAUAT_ExcelPath}    2    CRED08_FacilityFeeSetup
    Mx Execute Template With Multiple Data    Setup Facility Template D00001053    ${CBAUAT_ExcelPath}    3    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Setup Facility Fees D00001053    ${CBAUAT_ExcelPath}    3    CRED08_FacilityFeeSetup
    Mx Execute Template With Multiple Data    Setup Primaries for Deal D00001053    ${CBAUAT_ExcelPath}    1    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Approve and Close UAT Deal    ${CBAUAT_ExcelPath}    1    CRED01_DealSetup
    
Create Outstandings
    Mx Execute Template With Multiple Data    Setup Deal D00001053 Outstandings    ${CBAUAT_ExcelPath}    1-3    SERV01_LoanDrawdown
    
Initiate Runbook Transactions
    Mx Execute Template With Multiple Data    Setup Repayment Schedule for Loans in Deal D00001053    ${CBAUAT_ExcelPath}    1-3    UAT02_Runbook
    Pause Execution    ### eod to 27-Dec-2018
    Mx Execute Template With Multiple Data    Create Scheduled Repayment for Loans in Deal D00001053    ${CBAUAT_ExcelPath}    1-3    UAT02_Runbook
    Pause Execution    ### eod to 01-Feb-2019
    Mx Execute Template With Multiple Data    Unscheduled Full Prepayment for Loans in Deal D00001053    ${CBAUAT_ExcelPath}    1    UAT02_Runbook
    Pause Execution    ### eod to 04-Feb-2019
    Mx Execute Template With Multiple Data    Unscheduled Full Prepayment for Loans in Deal D00001053    ${CBAUAT_ExcelPath}    2    UAT02_Runbook
    

    
