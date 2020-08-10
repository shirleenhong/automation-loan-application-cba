*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Loan Drawdown Under a Non Committed Line
    [Documentation]    This keyword is used to create a Loan Drawdown under a non committed line.
    ...    @author: hstone      17JUN2020      - Initial Create
    [Arguments]    ${ExcelPath}

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Create Loan Drawdown ####
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    Navigate to Outstanding Select Window
    ${Loan_Alias}    Input Initial Loan Drawdown Details    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_ShortName]
    ...    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_Currency]
    Write Data To Excel    SERV03_DrwUnderNonCommittedLine   Loan_Alias    ${rowid}    ${Loan_Alias}

    Validate Initial Loan Dradown Details    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Loan_Currency]
    ${Loan_RepricingDate}    Add Time from From Date and Returns Weekday    &{ExcelPath}[Loan_EffectiveDate]    30
    ${AdjustedDueDate}    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_MaturityDate]    &{ExcelPath}[Loan_RepricingFrequency]
    ...    sRepricing_Date=${Loan_RepricingDate}
    Write Data To Excel    SERV03_DrwUnderNonCommittedLine   Loan_RepricingDate    ${rowid}    ${Loan_RepricingDate}
    Save Initial Drawdown Notebook

    ### Update Lender Shares ###
    Navigate to View/Update Lender Share via Loan Drawdown Notebook
    Validate Lender Shares    &{ExcelPath}[Lender_ShortName1]    &{ExcelPath}[Lender_SharePercentage1]    &{ExcelPath}[Loan_OutstandingAmount]
    Validate Lender Shares    &{ExcelPath}[Lender_ShortName2]    &{ExcelPath}[Lender_SharePercentage2]    &{ExcelPath}[Loan_OutstandingAmount]
    Validate Lender Shares    &{ExcelPath}[Lender_ShortName3]    &{ExcelPath}[Lender_SharePercentage3]    &{ExcelPath}[Loan_OutstandingAmount]
    ${TranAmount3}    ${New_LenderShare3}    Update Facility Lender Shares    &{ExcelPath}[Lender_ShortName3]    &{ExcelPath}[Lender_AdjustmentAmount3]    &{ExcelPath}[Lender_CommitmentAmt3]
    ...    &{ExcelPath}[Loan_ProposedCommitmentAmount]    &{ExcelPath}[Loan_OutstandingAmount]    Actual Amount
    ${TranAmount2}    ${New_LenderShare2}    Update Facility Lender Shares    &{ExcelPath}[Lender_ShortName2]    &{ExcelPath}[Lender_AdjustmentAmount2]    &{ExcelPath}[Lender_CommitmentAmt2]
    ...    &{ExcelPath}[Loan_ProposedCommitmentAmount]    &{ExcelPath}[Loan_OutstandingAmount]    Actual Amount
    Validate Lender Shares    &{ExcelPath}[Lender_ShortName1]    &{ExcelPath}[Lender_SharePercentage1]    &{ExcelPath}[Loan_OutstandingAmount]
    Validate Lender Shares    &{ExcelPath}[Lender_ShortName2]    ${New_LenderShare2}    &{ExcelPath}[Loan_OutstandingAmount]
    Validate Lender Shares    &{ExcelPath}[Lender_ShortName3]    ${New_LenderShare3}    &{ExcelPath}[Loan_OutstandingAmount]
    Add Share Adjustment Comment    &{ExcelPath}[Lender_AdjustmentComment3]
    Submit Share Adjustment

    ### Create Cashflows ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Create Cashflow
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender_ShortName2]    &{ExcelPath}[Lender_RemmittanceDesc2]    &{ExcelPath}[Lender_RemmittanceInstruction2]
    Verify if Status is set to Do It    &{ExcelPath}[Lender_ShortName2]
    Click OK In Cashflows

    ### Rate Setting ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Rate Setting
    Set Base Rate Details    None    Y

    ### Send to Approval
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Send to Approval
    Close All Windows on LIQ 

    ### Drawdown Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Approval    Loan Initial Drawdown    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Approval
    Close All Windows on LIQ 

    ### Send to Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate to an Existing Loan    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    ${Loan_Alias}    N    N    Y
    Navigate to Loan Pending Tab and Proceed with the Pending Transaction    Awaiting Send to Rate Approval
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Send to Rate Approval
    Close All Windows on LIQ 

    ### Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Rate Approval    Loan Initial Drawdown    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Rate Approval
    Close All Windows on LIQ 

    ### Drawdown Release ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate to an Existing Loan    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    ${Loan_Alias}    N    N    Y
    Navigate to Loan Pending Tab and Proceed with the Pending Transaction    Awaiting Release
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Release
    Click OK In Cashflows

    ### Final Validations ###
    Go To Initial Drawdown GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender_GLPortfolioName1]    Debit Amt
    ${NonAgentBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender_ShortName2]    Debit Amt
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    &{ExcelPath}[GL_Entries_TotalCreditAmt_Row]     Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    &{ExcelPath}[GL_Entries_TotalDebitAmt_Row]     Debit Amt
    ${HostBanksShare}    Add All Amounts    &{ExcelPath}[Lender_CommitmentAmt1]    &{ExcelPath}[Lender_AdjustmentAmount2]
    ${HostBanksShare_Debit}    Add All Amounts    ${HostBank_Debit}    ${NonAgentBank_Debit}
    Compare UIAmount versus Computed Amount    ${HostBanksShare}    ${HostBanksShare_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBanksShare_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    &{ExcelPath}[Loan_RequestedAmount]
    Go To Facility From Initial Drawdown Notebook
    Validate New Facility Available to Draw Amount    &{ExcelPath}[Facility_NewAvailToDraw]

    Close All Windows on LIQ