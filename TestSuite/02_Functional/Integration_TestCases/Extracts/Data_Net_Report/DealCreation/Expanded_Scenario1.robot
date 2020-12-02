*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***

Deal Setup for Expanded Scenario 1
    [Tags]    01 Deal Setup for Expanded Scenario 1
    Mx Execute Template With Multiple Data    Setup a Bilateral Deal for DNR    ${DNR_DATASET}    ${rowid}    SC1_DealSetup

    Set Global Variable    ${TestCase_Name}    Expanded_Scenario1_ActiveFac1_Repayment
    Mx Execute Template With Multiple Data    Write Loan Details from Deal for DNR    ${DNR_DATASET}    ${rowid}    SC1_DealSetup
    Set Global Variable    ${TestCase_Name}    Expanded_Scenario1_ExpiredFac2
    Mx Execute Template With Multiple Data    Write Loan Details from Deal for DNR    ${DNR_DATASET}    ${rowid}    SC1_DealSetup
    Set Global Variable    ${TestCase_Name}    Expanded_Scenario1_ActiveFac1_NoRepayment
    Mx Execute Template With Multiple Data    Write Loan Details from Deal for DNR    ${DNR_DATASET}    ${rowid}    SC1_DealSetup

Facility 1 Setup for Expanded Scenario 1
    [Tags]    02 Facility 1 Setup for Expanded Scenario 1
    Set Global Variable    ${rowid}    1
    Mx Execute Template With Multiple Data    Create Facility for DNR    ${DNR_DATASET}    ${rowid}    SC1_FacilitySetup
    Mx Execute Template With Multiple Data    Ongoing Fee Setup for DNR     ${DNR_DATASET}    ${rowid}    SC1_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Get Active Facility Details for Active Outstanding and Write in DNR Dataset    ${DNR_DATASET}    ${rowid}    SC1_FacilitySetup
    
    Set Global Variable    ${TestCase_Name}    Expanded_Scenario1_ActiveFac1_Repayment
    Mx Execute Template With Multiple Data    Write Loan Details from Facility for DNR    ${DNR_DATASET}    ${rowid}    SC1_FacilitySetup
    Set Global Variable    ${TestCase_Name}    Expanded_Scenario1_ActiveFac1_NoRepayment
    Mx Execute Template With Multiple Data    Write Loan Details from Facility for DNR    ${DNR_DATASET}    ${rowid}    SC1_FacilitySetup

Facility 2 Setup for Expanded Scenario 1
    [Tags]    03 Facility 2 Setup for Expanded Scenario 1
    Set Global Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Create Facility for DNR    ${DNR_DATASET}    ${rowid}    SC1_FacilitySetup
    Mx Execute Template With Multiple Data    Ongoing Fee Setup for DNR     ${DNR_DATASET}    ${rowid}    SC1_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Get Expired Facility Details for Active Outstanding and Write in DNR Dataset    ${DNR_DATASET}    ${rowid}    SC1_FacilitySetup
    
    Set Global Variable    ${TestCase_Name}    Expanded_Scenario1_ExpiredFac2
    Mx Execute Template With Multiple Data    Write Loan Details from Facility for DNR    ${DNR_DATASET}    ${rowid}    SC1_FacilitySetup

Primary Setup for Expanded Scenario 1
    [Tags]    04 Primary Setup for Expanded Scenario 1
    Set Global Variable    ${rowid}    1
    Mx Execute Template With Multiple Data    Setup a Primary Notebook for DNR    ${DNR_DATASET}    ${rowid}    SC1_PrimaryAllocation

    ### Generate Facility Performance Report with Pending Facility ###
    Set Global Variable    ${TestCase_Name}    FACPF_005
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Facility Performance    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Facility Performance    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR

    Mx Execute Template With Multiple Data    Close Deal for DNR    ${DNR_DATASET}    ${rowid}    SC1_PrimaryAllocation
    Mx Execute Template With Multiple Data    Get Deal Details and Write in DNR Dataset    ${DNR_DATASET}    ${rowid}    SC1_PrimaryAllocation

    ### Generate Facility Performance Report with Active Facility without Active Outstanding ###
    Set Global Variable    ${TestCase_Name}    FACPF_003
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Facility Performance    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Facility Performance    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR    

Create Initial Loan Drawdown for Active Facility Expanded Scenario 1
    [Tags]    05 Create Initial Loan Drawdown for Expanded Scenario 1
    Set Global Variable    ${rowid}    1
    Set Global Variable    ${TestCase_Name}    Expanded_Scenario1_ActiveFac1_Repayment
    Mx Execute Template With Multiple Data    Create Initial Loan Drawdown with Repayment Schedule for DNR    ${DNR_DATASET}    ${rowid}    SC1_LoanDrawdown

    ### add code for liquidity for pending loan - LQDTY_003
    Set Global Variable    ${TestCase_Name}    LQDTY_003
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Liquidity    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Liquidity Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR

    Set Global Variable    ${TestCase_Name}    Expanded_Scenario1_ActiveFac1_Repayment
    Mx Execute Template With Multiple Data    Release Initial Loan Drawdown and Add Alerts and Comments for DNR    ${DNR_DATASET}    ${rowid}    SC1_LoanDrawdown
    Mx Execute Template With Multiple Data    Get Fee Alias from Ongoing Fee Setup for DNR    ${DNR_DATASET}    ${rowid}    SC1_LoanDrawdown
    
    ### Generate Facility Performance Report with Active Facility with Active Outstanding ###
    Set Global Variable    ${TestCase_Name}    FACPF_002
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Facility Performance    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Facility Performance    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR

    ### Generate Calendar report after drawdown
    Set Global Variable    ${TestCase_Name}    CALND_002
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Calendar    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Calendar Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR  

    ### Ongoing Fee - adjusted due date
    Set Global Variable    ${TestCase_Name}    CALND_003_EqualFeeDate
    Mx Execute Template With Specific Test Case Name    Write Details for Calendar Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR

    ### add code for liquidity for active loan - LQDTY_002
    Set Global Variable    ${TestCase_Name}    LQDTY_002
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Liquidity    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Liquidity Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR

    ### add update comment code
    ### add delete comment code

Create Initial Loan Drawdown with no Repayment Schedule for Active Facility Expanded Scenario 1
    [Tags]    06 Create Initial Loan Drawdown for Expanded Scenario 1
    Set Global Variable    ${rowid}    3
    Set Global Variable    ${TestCase_Name}    Expanded_Scenario1_ExpiredFac2
    Mx Execute Template With Multiple Data    Create Initial Loan Drawdown with no Repayment Schedule for DNR    ${DNR_DATASET}    ${rowid}    SC1_LoanDrawdown

Create Initial Loan Drawdown for Expired Facility Expanded Scenario 1
    [Tags]    07 Create Initial Loan Drawdown for Expanded Scenario 1

    Log To Console    Run 1 Day EOD for Facility 2 to equal system date to expiry date
    Pause Execution
    
    Set Global Variable    ${rowid}    2
    Set Global Variable    ${TestCase_Name}    Expanded_Scenario1_ExpiredFac2
    Mx Execute Template With Multiple Data    Create Initial Loan Drawdown with Repayment Schedule for DNR    ${DNR_DATASET}    ${rowid}    SC1_LoanDrawdown
    Mx Execute Template With Multiple Data    Release Initial Loan Drawdown and Add Alerts and Comments for DNR    ${DNR_DATASET}    ${rowid}    SC1_LoanDrawdown

    Log To Console    Run 1 Day EOD for Facility 2 to expire
    Pause Execution

    Set Global Variable    ${TestCase_Name}    FACPF_004
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Facility Performance    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Facility Performance    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR

    Set Global Variable    ${TestCase_Name}    CALND_003_UpdateFeeDate
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Calendar    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Calendar Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    
Update Adjusted Due Date for Active Facility Expanded Scenario 1
    [Tags]    08 Update Adjusted Due Date for Active Facility Expanded Scenario 1
    Set Global Variable    ${rowid}    1
    Set Global Variable    ${TestCase_Name}    Expanded_Scenario1_ActiveFac1_Repayment
    Mx Execute Template With Multiple Data    Update Adjusted Due Date for DNR    ${DNR_DATASET}    ${rowid}    SC1_PaymentFees
    Mx Execute Template With Multiple Data    Get Fee Alias for Payment from Ongoing Fee Setup for DNR    ${DNR_DATASET}    ${rowid}    SC1_PaymentFees

    ### CALND_003 - generate  calendar report
    Set Global Variable    ${TestCase_Name}    CALND_003_UpdateFeeDate
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Calendar    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Calendar Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR

Pay Commitment Fee Amount for Active Facility Expanded Scenario 1
    [Tags]    09 Pay Commitment Fee Amount for Active Facility Expanded Scenario 1
    Set Global Variable    ${rowid}    1
    Set Global Variable    ${TestCase_Name}    Expanded_Scenario1_ActiveFac1_Repayment
    Mx Execute Template With Multiple Data    Pay Commitment Fee Amount for DNR    ${DNR_DATASET}    ${rowid}    SC1_PaymentFees 

    Set Global Variable    ${TestCase_Name}    LQDTY_004
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Liquidity    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Liquidity Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR

Unscheduled Principal Payment for Active Facility Expanded Scenario 1
    [Tags]    10 Unscheduled Principal Payment for Active Facility Expanded Scenario 1
    Set Global Variable    ${rowid}    3
    Set Global Variable    ${TestCase_Name}    Expanded_Scenario1_ActiveFac1_NoRepayment
    Mx Execute Template With Multiple Data    Unscheduled Principal Payment - No Schedule for DNR    ${DNR_DATASET}    ${rowid}    SC1_UnscheduledPayments

    ### EOD
    ### Unscheduled Principal Payment - No Schedule
    ### LQDTY_005