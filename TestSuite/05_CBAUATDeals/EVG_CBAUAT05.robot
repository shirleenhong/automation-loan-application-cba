*** Settings ***
Resource    ../../Configurations/LoanIQ_Import_File.robot
*** Variables ***
${rowid}    1
${Facility_A}    1
${Facility_B}    2
${Facility_C}    3
${Facility_A-Outstanding_A}    1
${Facility_A-Outstanding_B}    2
${Facility_B-Outstanding_A}    3
${Facility_C-Outstanding_A}    4
*** Test Cases ***
Create Quick Party Onboarding for CBA UAT Deal 5 - PTY001
    [Tags]    01 Create Party within Essence - PTY001
    Mx Execute Template With Multiple Data    Create Deal Borrower initial details in Quick Party Onboarding for UAT Deal Five    ${CBAUAT_ExcelPath}    1    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Populate Quick Enterprise Party with Approval    ${CBAUAT_ExcelPath}    1    PTY001_QuickPartyOnboarding

Deal Setup
    [Tags]    02 Deal Setup   
    Mx Execute Template With Multiple Data    Setup Deal D00001151    ${CBAUAT_ExcelPath}    ${rowid}    CRED01_DealSetup 
    
    Mx Execute Template With Multiple Data    Setup Facility Template D00001151    ${CBAUAT_ExcelPath}    ${Facility_A}    CRED02_FacilitySetup 
    Mx Execute Template With Multiple Data    Setup Facility Fees D00001151    ${CBAUAT_ExcelPath}    ${Facility_A}    CRED08_FacilityFeeSetup
    Mx Execute Template With Multiple Data    Setup MIS Code D00001151    ${CBAUAT_ExcelPath}    ${Facility_A}    CRED08_FacilityFeeSetup
    
    Mx Execute Template With Multiple Data    Setup Facility Template D00001151    ${CBAUAT_ExcelPath}    ${Facility_B}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Setup Facility Fees D00001151    ${CBAUAT_ExcelPath}    ${Facility_B}    CRED08_FacilityFeeSetup
    Mx Execute Template With Multiple Data    Setup MIS Code D00001151    ${CBAUAT_ExcelPath}    ${Facility_B}    CRED08_FacilityFeeSetup
    
    Mx Execute Template With Multiple Data    Setup Facility Template D00001151    ${CBAUAT_ExcelPath}    ${Facility_C}    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Setup Facility Fees D00001151    ${CBAUAT_ExcelPath}    ${Facility_C}    CRED08_FacilityFeeSetup
    Mx Execute Template With Multiple Data    Setup MIS Code D00001151    ${CBAUAT_ExcelPath}    ${Facility_C}    CRED08_FacilityFeeSetup
    
    Mx Execute Template With Multiple Data    Setup Primaries for Deal D00001151    ${CBAUAT_ExcelPath}    ${rowid}    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Approve and Close Deal D00001151    ${CBAUAT_ExcelPath}    ${rowid}    CRED01_DealSetup
    
Facility Change Limit - A
    [Tags]    03 Facility Change Limit 
    Mx Execute Template With Multiple Data    Facility Limit Change    ${CBAUAT_ExcelPath}    ${Facility_A}    CRED02_FacilitySetup
    
Facility A - Outstandings
    [Tags]    04 Create Outstandings
    Mx Execute Template With Multiple Data    Facility Drawdown    ${CBAUAT_ExcelPath}    ${Facility_A-Outstanding_A}    SERV01_LoanDrawdown
    Mx Execute Template With Multiple Data    Facility Drawdown    ${CBAUAT_ExcelPath}    ${Facility_A-Outstanding_B}    SERV01_LoanDrawdown
    
Facility B - Outstandings
    [Tags]    05 Create Outstandings
    Mx Execute Template With Multiple Data    Facility Drawdown    ${CBAUAT_ExcelPath}    ${Facility_B-Outstanding_A}    SERV01_LoanDrawdown

Facility C - Outstandings
    [Tags]    06 Create Outstandings
    Mx Execute Template With Multiple Data    Facility Drawdown    ${CBAUAT_ExcelPath}    ${Facility_C-Outstanding_A}    SERV01_LoanDrawdown   
    
Comprehensive Repricings
    Pause Execution    # EOD 20-Dec-2018
    Mx Execute Template With Multiple Data    Comprehensive Repricing Principal and Interest Payment - 2 Cashflows    ${CBAUAT_ExcelPath}    ${Facility_A-Outstanding_A}    SERV08C_ComprehensiveRepricing
    Mx Execute Template With Multiple Data    Check Limit after Rollover/Repayment    ${CBAUAT_ExcelPath}    ${Facility_A-Outstanding_A}    SERV08C_ComprehensiveRepricing
    Mx Execute Template With Multiple Data    Comprehensive Repricing Interest Payment    ${CBAUAT_ExcelPath}    ${Facility_C-Outstanding_A}    SERV08C_ComprehensiveRepricing
    Mx Execute Template With Multiple Data    Check Limit after Rollover/Repayment    ${CBAUAT_ExcelPath}    ${Facility_C-Outstanding_A}    SERV08C_ComprehensiveRepricing
    Pause Execution    # EOD 21-Jan-2019
    Mx Execute Template With Multiple Data    Comprehensive Repricing Principal and Interest Payment - 1 Cashflow    ${CBAUAT_ExcelPath}    ${Facility_A-Outstanding_B}    SERV08C_ComprehensiveRepricing
    Mx Execute Template With Multiple Data    Check Limit after Rollover/Repayment    ${CBAUAT_ExcelPath}    ${Facility_A-Outstanding_B}    SERV08C_ComprehensiveRepricing
    Pause Execution    # EOD 20-Feb-2019
    Mx Execute Template With Multiple Data    Comprehensive Repricing Principal and Interest Payment - 1 Cashflow    ${CBAUAT_ExcelPath}    ${Facility_B-Outstanding_A}    SERV08C_ComprehensiveRepricing
    Mx Execute Template With Multiple Data    Check Limit after Rollover/Repayment    ${CBAUAT_ExcelPath}    ${Facility_B-Outstanding_A}    SERV08C_ComprehensiveRepricing
