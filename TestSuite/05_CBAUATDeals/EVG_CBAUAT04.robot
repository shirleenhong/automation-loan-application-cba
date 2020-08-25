*** Settings ***
Resource    ../../Configurations/LOANIQ_Import_File.robot
#Suite Setup    Launch LoanIQ Application    ${LoanIQPath}
#Suite Teardown    Close Application Via CMD   ${LoanIQ}
# Test Setup    Fail if Previous Test Case Failed

*** Variables ***
${rowid}    1

*** Test Cases ***
Create Quick Party Onboarding for CBA UAT Deal 4 - PTY001
    [Tags]    01 Create Party within Essence - PTY001   
    Mx Execute Template With Multiple Data    Create Deal D00000963 Borrower initial details in Quick Party Onboarding    ${CBAUAT_ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    Mx Execute Template With Multiple Data    Populate Quick Enterprise Party with Approval    ${CBAUAT_ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding
    
Complete Customer Profile - ORIG03
    [Tags]    02 Complete Borrower's Profile - 0RIG03
    Mx Execute Template With Multiple Data    Search Customer and Complete its Borrower Profile Creation with default values for Deal Template Four    ${CBAUAT_ExcelPath}    1    ORIG03_Customer

    Mx Execute Template With Multiple Data    Add Remittance Instruction for D00000476    ${CBAUAT_ExcelPath}    1    ORIG03_Customer
    Mx Execute Template With Multiple Data    Add IMT message code for UAT Deal for D00000476   ${CBAUAT_ExcelPath}    1    ORIG03_Customer
    Mx Execute Template With Multiple Data    Add Swift Role in IMT message for UAT Deal for D00000476    ${CBAUAT_ExcelPath}    1    ORIG03_Customer
    Mx Execute Template With Multiple Data    Update Swift Role in IMT message for UAT Deal for D00000476    ${CBAUAT_ExcelPath}    2-3    ORIG03_Customer  
    Mx Execute Template With Multiple Data    Populate Details on IMT for UAT Deal for D00000476    ${CBAUAT_ExcelPath}    1    ORIG03_Customer
    Send Remittance Instruction to Approval and Close RI Notebook

    Mx Execute Template With Multiple Data    Add Remittance Instruction for D00000476    ${CBAUAT_ExcelPath}    4    ORIG03_Customer
    Mx Execute Template With Multiple Data    Add IMT message code for UAT Deal for D00000476   ${CBAUAT_ExcelPath}    4    ORIG03_Customer
    Mx Execute Template With Multiple Data    Add Swift Role in IMT message for UAT Deal for D00000476    ${CBAUAT_ExcelPath}    4    ORIG03_Customer
    Mx Execute Template With Multiple Data    Update Swift Role in IMT message for UAT Deal for D00000476    ${CBAUAT_ExcelPath}    5-6    ORIG03_Customer  
    Mx Execute Template With Multiple Data    Populate Details on IMT for UAT Deal for D00000476    ${CBAUAT_ExcelPath}    4    ORIG03_Customer
    Send Remittance Instruction to Approval and Close RI Notebook

    Mx Execute Template With Multiple Data    Complete Servicing Group Details    ${CBAUAT_ExcelPath}    1    ORIG03_Customer    
    Mx Execute Template With Multiple Data    Add Remittance Instruction to Servicing Group in UAT    ${CBAUAT_ExcelPath}    1,4    ORIG03_Customer    
    Mx Execute Template With Multiple Data    Logout and Search Customer in UAT - 1st Approver    ${CBAUAT_ExcelPath}    1    ORIG03_Customer
    Mx Execute Template With Multiple Data    Approve Remittance Instruction in UAT    ${CBAUAT_ExcelPath}    1,4    ORIG03_Customer
    Mx Execute Template With Multiple Data    Logout and Search Customer in UAT - 2nd Approver    ${CBAUAT_ExcelPath}    1    ORIG03_Customer
    Mx Execute Template With Multiple Data    Approve Remittance Instruction in UAT    ${CBAUAT_ExcelPath}    1,4    ORIG03_Customer
    Mx Execute Template With Multiple Data    Release Remittance Instruction in UAT    ${CBAUAT_ExcelPath}    1,4    ORIG03_Customer
    Mx Execute Template With Multiple Data    Logout and Search Customer in UAT - Inputter    ${CBAUAT_ExcelPath}    1    ORIG03_Customer
    
Deal Setup
    Mx Execute Template With Multiple Data    Setup Deal D00000963    ${CBAUAT_ExcelPath}    1    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Setup Facility for Deal D00000963    ${CBAUAT_ExcelPath}    1-2    CRED02_FacilitySetup
    Mx Execute Template With Multiple Data    Setup Primaries for Deal D00000963    ${CBAUAT_ExcelPath}    1    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Approve and Close UAT Deal D00000963    ${CBAUAT_ExcelPath}    1    CRED01_DealSetup
    Mx Execute Template With Multiple Data    Release Facility Ongoing Fee for Deal D00000963    ${CBAUAT_ExcelPath}    1-2    UAT04_Fees
    
Servicing Transactions - Initial Drawdown, Repricing & Partial Repayments
    Mx Execute Template With Multiple Data    Create Outstandings for Deal D00000963    ${CBAUAT_ExcelPath}    1-3    SERV01_LoanDrawdown
    # Pause Execution    ### EOD 30-Nov-2018
    # Mx Execute Template With Multiple Data    Create Repricing for Loan AA in Deal D00000963    ${CBAUAT_ExcelPath}    1    UAT04_Runbook
    # Pause Execution    ### EOD 07-Dec-2018
    # Mx Execute Template With Multiple Data    Create Payment for Ongoing Fees in Deal D00000963    ${CBAUAT_ExcelPath}    1-2    UAT04_Fees
    # Pause Execution    ### EOD 19-Dec-2018
    # Mx Execute Template With Multiple Data    Create Repricing for Loans in Deal D00000963    ${CBAUAT_ExcelPath}    5    UAT04_Runbook
    # Pause Execution    ### EOD 28-Dec-2018
    # Mx Execute Template With Multiple Data    Create Repricing for Loans in Deal D00000963    ${CBAUAT_ExcelPath}    8    UAT04_Runbook
    # Pause Execution    ### EOD 31-Dec-2018
    # Mx Execute Template With Multiple Data    Create Repricing and Partial Repayment for Loan AA    ${CBAUAT_ExcelPath}    2    UAT04_Runbook
    # Pause Execution    ### EOD 10-Jan-2019
    # Mx Execute Template With Multiple Data    Create Full Repayment for Loans in Deal D00000963    ${CBAUAT_ExcelPath}    9    UAT04_Runbook
    # Pause Execution    ### EOD 21-Jan-2019
    # Mx Execute Template With Multiple Data    Create Repricing for Loans in Deal D00000963    ${CBAUAT_ExcelPath}    6    UAT04_Runbook
    # Pause Execution    ### EOD 31-Jan-2019
    # Mx Execute Template With Multiple Data    Create Repricing and Partial Repayment for Loan AA    ${CBAUAT_ExcelPath}    3    UAT04_Runbook
    # Pause Execution    ### EOD 19-Feb-2019
    # Mx Execute Template With Multiple Data    Create Outstandings for Deal D00000963    ${CBAUAT_ExcelPath}    4    SERV01_LoanDrawdown
    # Pause Execution    ### EOD 21-Feb-2019
    # Mx Execute Template With Multiple Data    Create Repricing for Loans in Deal D00000963    ${CBAUAT_ExcelPath}    7    UAT04_Runbook
    # Pause Execution    ### EOD 28-Feb-2019
    # Mx Execute Template With Multiple Data    Create Repricing and Partial Repayment for Loan AA    ${CBAUAT_ExcelPath}    4    UAT04_Runbook
    # Mx Execute Template With Multiple Data    Create Full Repayment for Loans in Deal D00000963    ${CBAUAT_ExcelPath}    10    UAT04_Runbook
    
