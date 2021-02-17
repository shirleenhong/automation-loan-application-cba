*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Complete Portfolio Settled Discount for LBT Bilateral Deal
    [Documentation]    This keyword is used to peform Portfolio Settled Discount Change/Adjustment for LBT Bilateral Deal
    ...    @author:    javinzon    10FEB2021    - Initial create
    [Arguments]    ${ExcelPath}

    ### Read Excel Data ###
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    ${rowid}
    ${Facility_Name}    Read Data From Excel    CRED01_FacilitySetup    Facility_Name    ${rowid}
    ${Adjustment_Amount}    Read Data From Excel    CRED07_UpfrontFee_Payment    UpfrontFee_Amount    ${rowid}
    ${Effective_Date}    Read Data From Excel    CRED07_UpfrontFee_Payment    UpfrontFee_EffectiveDate    ${rowid}
    ${Portfolio_Name}    Read Data From Excel    SYND02_PrimaryAllocation    Primary_Portfolio    ${rowid}
    ${Currency}    Read Data From Excel    CRED01_FacilitySetup    Facility_Currency    ${rowid}
    ${ExpenseCode}    Read Data From Excel    CRED01_DealSetup    Deal_ExpenseCode    ${rowid}

    ### Portfolio position Selection ###
    Open Existing Deal    ${Deal_Name}
    Navigate to Facility Notebook    ${Deal_Name}    ${Facility_Name}
    Adjust Lender Shares from Facility Notebook    &{ExcelPath}[AdjustmentSelection]
    Select Portfolio for Portfolio Settled Discount Change    ${Portfolio_Name}
    Update Portfolio Settled Discount Change Details    ${EffectiveDate}    ${Adjustment_Amount}
    Update GLOffset Details    &{ExcelPath}[GL_ShortName]    &{ExcelPath}[GL_Offset_Type]    ${ExpenseCode}\t${Currency}\t${Adjustment_Amount}\t${Adjustment_Amount}\t${Deal_Name}

    ### Send transaction for approval ###
    Send to Approval Portfolio Selection Discount Change  
    
    ### Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${FACILITIES}    ${AWAITING_APPROVAL_STATUS}    ${PORTFOLIO_SETTLED_DISCOUNT_ADJUSTMENT}    ${Deal_Name}
    Navigate to Portfolio Settled Discount Change Workflow and Proceed With Transaction    ${APPROVAL_STATUS}
    
    ### Release ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Launch Existing Facility    ${Deal_Name}    ${Facility_Name}
    Navigate to Pending Portfolio Selection Discount Change
    Navigate to Portfolio Settled Discount Change Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    Close All Windows on LIQ

    ### Validation ###
    Launch Existing Facility    ${Deal_Name}    ${Facility_Name}
    Validate an Event in Events Tab of Facility Notebook    ${PORTFOLIO_SETTLED_DISCOUNT_CHANGE_RELEASED}
    Navigate to Portfolio Positions from Facility Notebook
    Navigate to Porfolio Allocation from Portfolio Position Notebook    ${Portfolio_Name}    ${Facility_Name}
    Validate Trade and Settled Discount Amount    ${Adjustment_Amount}    ${Adjustment_Amount}
    Close All Windows on LIQ