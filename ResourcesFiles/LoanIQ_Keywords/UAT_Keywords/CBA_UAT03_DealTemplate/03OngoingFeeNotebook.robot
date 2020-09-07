*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Commitment Fee Payment
    [Documentation]    This keyword collects the commitment fee payment of the facility
    ...    @author:mgaling    31July2019    Intial Create
    [Arguments]    ${ExcelPath}
    
    ${Date}    Get System Date
    
    ### Navigate to Commitment Fee Notebook ###
    Search Existing Deal    &{ExcelPath}[Deal_Name]    
    #Navigate Directly to Commitment Fee Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    
    ### Commitment Fee Notebook - General Tab ###  
    ${Rate}    ${BalanceAmount}    ${RateBasis}    Get Data in General Tab
    Write Data To Excel    SERV29_CommitmentFeePayment    Rate    ${rowid}    ${Rate}    ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV29_CommitmentFeePayment    Balance_Amount    ${rowid}    ${BalanceAmount}    ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV29_CommitmentFeePayment    Rate_Basis    ${rowid}    ${RateBasis}    ${CBAUAT_ExcelPath}
    
    ${ProjectedCycleDue}    Compute Commitment Fee Amount Per Cycle    &{ExcelPath}[Balance_Amount]    &{ExcelPath}[Rate_Basis]    &{ExcelPath}[Cycle_Number]    ${Date}
    Write Data To Excel    SERV29_CommitmentFeePayment    Computed_CycleDue    ${rowid}    ${ProjectedCycleDue}    ${CBAUAT_ExcelPath}
    
    ### Ongoing Fee Payment ###
    # Select Cycle Due Fee Payment 
    # Enter Effective Date for Ongoing Fee-Cycle Due Payment    ${Date}
    
    ### Ongoing Fee Payment - Cashflow Validation ###
    Navigate to Cashflow - Ongoing Fee
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]    
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]    
    
    # # ### GL Entries Validation ###
    ${ProjectedCycleDue}    Read Data From Excel    SERV29_CommitmentFeePayment    Computed_CycleDue    ${rowid}    ${CBAUAT_ExcelPath}
    
    Navigate to GL Entries
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Debit Amt
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    Validate if Debit and Credit Amt is Balanced    ${Borrower_Debit}    ${HostBank_Credit}
    
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001   Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001    Debit Amt
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    ${ProjectedCycleDue}
    
    ### Ongoing Fee Payment - Send to Approval ### 
    Send Ongoing Fee Payment to Approval
    
    ### Ongoing Fee Payment Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Work in Process for Ongoing Fee Payment Approval    &{ExcelPath}[Facility_Name]
    Approve Ongoing Fee Payment
    Close All Windows on LIQ
    
    ### Ongoing Fee Payment Release ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Work in Process for Ongoing Fee Payment Release    &{ExcelPath}[Facility_Name]
    
    Release Ongoing Fee Payment
    
    ### Payment Transaction Validation ###
    Close All Windows on LIQ
    Search Existing Deal    &{ExcelPath}[Deal_Name]    
    # Navigate Directly to Commitment Fee Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    Validate Details on Acrual Tab - Commitment Fee    ${ProjectedCycleDue}    &{ExcelPath}[Cycle_Number]
    Validate release of Ongoing Fee Payment
    Close All Windows on LIQ   

Setup Ongoing Fee
    [Documentation]    This keyword will update the Setup the Ongoing Fees in the Deal
    ...    @author:    ritragel    09SEP2020    Addded selection of Due Date
    [Arguments]    ${ExcelPath}
    
    ### Navigate to Commitment Fee Notebook ###
    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Fee_Type]
    
    ### Enter Details
    Run Keyword If    '&{ExcelPath}[rowid]' != '4'    Enter Commitment Fee Details    &{ExcelPath}[Effective_Date]    &{ExcelPath}[Actual_DueDate]    &{ExcelPath}[Adjusted_DueDate]    &{ExcelPath}[Cycle_Frequency]    &{ExcelPath}[Accrue]
    Run Keyword If    '&{ExcelPath}[rowid]' == '4'    Enter Line Fee Details    &{ExcelPath}[Effective_Date]    &{ExcelPath}[Actual_DueDate]    &{ExcelPath}[Adjusted_DueDate]    &{ExcelPath}[Cycle_Frequency]    &{ExcelPath}[Accrue]
    
Commitment Fee Release
    [Documentation]    This keyword validates the status of commitment fee notebook of the facility.
    ...    @author:mgaling    31July2019    Intial Create
    [Arguments]    ${ExcelPath}
    
    ### Navigate to Commitment Fee Notebook ###
    Search Existing Deal    &{ExcelPath}[Deal_Name]    
    # Navigate Directly to Commitment Fee Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    
    ### Workflow Tab ###
    # Validate Commitment Fee Notebook Status
    

    
    
    