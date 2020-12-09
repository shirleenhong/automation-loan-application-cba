*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${row_id}    2

*** Test Cases ***
AHBDE_001
    [Documentation]    This test case is used to validate Agency DE Extract tab in the DE report if the following fields are available:
    ...    Fields to Validate in Agency DE Extract Tab: Customer Short Name, Host Bank Share Amount, Cashflow Currency, Cashflow Direction, Processing Date
    ...    Effective Date, DDA Transaction Description, Cashflow Description, Deal Tracking Number, Transaction Code, Expense Code, Cashflow ID, Processing Area Code
    ...    Cashflow Status, Payment Method, Cashflow Create Date/Time
    ...    NOTE: DE Report should be available already in the report path.
    ...    @author: fluberio    20NOV2020    - initial create

    Set Global Variable    ${TestCase_Name_SummaryTab}    AHBDE_001
    MX Execute Template With Specific Test Case Name    Validate Agency DE Extract from Agency Host Bank DE Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name_SummaryTab}    AHBDE

Create Syndicated Deal for AHBDE
    [Documentation]    This test case is to create a syndicated deal for Agency DE
    ...    @author: songchan    23NOV2020    - initial create 

    Mx Execute Template With Multiple Data    Setup Syndicated Deal for DNR    ${DNR_DATASET}    ${rowid}    SC2_DealSetup
    Mx Execute Template With Multiple Data    Setup Deal Administrative Fees for DNR    ${DNR_DATASET}	${rowid}    SC2_AdminFee
    Mx Execute Template With Multiple Data    Setup Deal Event Fees for DNR    ${DNR_DATASET}    ${rowid}    SC2_EventFee
    Mx Execute Template With Multiple Data    Setup Term Facility for Syndicated Deal for DNR    ${DNR_DATASET}    ${rowid}    SC2_FacilitySetup
    Mx Execute Template With Multiple Data    Setup Fees for Term Facility for DNR    ${DNR_DATASET}    ${rowid}    SC2_OngoingFeeSetup
    Mx Execute Template With Multiple Data    Setup Primaries for Syndicated Deal for DNR    ${DNR_DATASET}    ${rowid}    SC2_PrimaryAllocation
    Mx Execute Template With Multiple Data    Syndicated Deal Approval and Close for DNR   ${DNR_DATASET}    ${rowid}    SC2_PrimaryAllocation
    
# #Pause for EOD

Initiate Line Fee Payment for AHBDE
    [Documentation]    This test case will pay the Line Fee for Agency DE after 1 day EOD
    ...    @author: songchan    02DEC2020    - initial create
    
    Mx Execute Template With Multiple Data    Update Line Fee Cycle for DNR    ${DNR_DATASET}    ${rowid}    SC2_PaymentFees
    Mx Execute Template With Multiple Data    Pay Line Fee Amount - Syndicated for DNR    ${DNR_DATASET}    ${rowid}    SC2_PaymentFees

Initiate Agency Fee Payment for AHBDE
    [Documentation]    This test case will pay the Admin Fee Payment for Agency DE after 1 day EOD
    Mx Execute Template With Multiple Data    Admin Fee Payment for DNR    ${DNR_DATASET}    ${rowid}    SC2_AdminFeePayment