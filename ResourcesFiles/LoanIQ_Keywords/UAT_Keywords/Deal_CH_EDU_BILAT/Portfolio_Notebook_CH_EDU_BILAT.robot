*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Complete Portfolio Settled Discount for CH EDU Bilateral Deal
    [Documentation]    This keyword is used to peform Portfolio Settled Discount Change/Adjustment
    ...    @author:    dahijara    18DEC2020    initial create
    [Arguments]    ${ExcelPath}

    ### Read Excel Data ###
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup_A    Facility_Name    &{ExcelPath}[rowid]
    ${Adjustment_Amount}    Read Data From Excel    CRED07_UpfrontFee_Payment    UpfrontFee_Amount    &{ExcelPath}[rowid]
    ${EffectiveDate}    Read Data From Excel    SERV01_LoanDrawdown    Loan_EffectiveDate    &{ExcelPath}[rowid]
    ${Portfolio_Name}    Read Data From Excel    SYND02_PrimaryAllocation    Primary_Portfolio    &{ExcelPath}[rowid]
    ${Currency}    Read Data From Excel    CRED02_FacilitySetup_A    Facility_Currency    &{ExcelPath}[rowid]
    ${ExpenseCode}    Read Data From Excel    CRED01_DealSetup    Deal_ExpenseCode    &{ExcelPath}[rowid]
    
    ### LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Portfolio position Selection ###
    Open Existing Deal    ${Deal_Name}
    Navigate to Facility Notebook    ${Deal_Name}    ${FacilityName}
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
    
    ### Release Transaction ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Launch Existing Facility    ${Deal_Name}    ${FacilityName}
    Navigate to Pending Portfolio Selection Discount Change
    Navigate to Portfolio Settled Discount Change Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    Close All Windows on LIQ

    ### Validation ###
    Launch Existing Facility    ${Deal_Name}    ${FacilityName}
    Navigate to Portfolio Positions from Facility Notebook
    Navigate to Porfolio Allocation from Portfolio Position Notebook    ${Portfolio_Name}    ${FacilityName}
    Validate Trade and Settled Discount Amount    ${Adjustment_Amount}    ${Adjustment_Amount}
    Close All Windows on LIQ