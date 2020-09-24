*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${SCENARIO}

*** Keywords ***
Commitment Fee Payment for D00000454
    [Documentation]    This keyword collects the commitment fee payment of the facility
    ...    @author:fmamaril    03SEP2019    Intial Create
    [Arguments]    ${ExcelPath}

    ${Date}    Get System Date
    
    ### Navigate to Commitment Fee Notebook ###
    Search Existing Deal    &{ExcelPath}[Deal_Name]    
    Navigate Directly to Commitment Fee Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    
    ### Commitment Fee Notebook - General Tab ###  
    ${Rate}    ${BalanceAmount}    ${RateBasis}    Get Data in General Tab
    Write Data To Excel    SERV29_CommitmentFeePayment    Rate    ${rowid}    ${Rate}    ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV29_CommitmentFeePayment    Balance_Amount    ${rowid}    ${BalanceAmount}    ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV29_CommitmentFeePayment    Rate_Basis    ${rowid}    ${RateBasis}    ${CBAUAT_ExcelPath}
    
    ${ProjectedCycleDue}    Run Keyword If    &{ExcelPath}[rowid] == 3    Run Keyword    Compute Commitment Fee Amount Per Cycle    &{ExcelPath}[Balance_Amount]    &{ExcelPath}[Rate_Basis]    &{ExcelPath}[Cycle_Number]    ${Date}    &{ExcelPath}[Total]    
    ...    ELSE    Compute Commitment Fee Amount Per Cycle    &{ExcelPath}[Balance_Amount]    &{ExcelPath}[Rate_Basis]    &{ExcelPath}[Cycle_Number]    ${Date} 
    Write Data To Excel    SERV29_CommitmentFeePayment    Computed_CycleDue    ${rowid}    ${ProjectedCycleDue}    ${CBAUAT_ExcelPath}

    ### Ongoing Fee Payment ###
    Select Cycle Due Fee Payment 
    Enter Effective Date for Ongoing Fee-Cycle Due Payment    ${Date}
    
    ### Ongoing Fee Payment - Cashflow Validation ###
    Navigate to Cashflow - Ongoing Fee
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]    
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender_RemittanceDescription]    &{ExcelPath}[Lender_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Lender2_RemittanceDescription]    &{ExcelPath}[Lender2_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender2_ShortName]   
    
    ### GL Entries Validation ###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]
    ${Lend2TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender2_ShortName]

    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount with exact percentage    ${ProjectedCycleDue}    &{ExcelPath}[HostBankSharePct]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount with exact percentage    ${ProjectedCycleDue}    &{ExcelPath}[LenderSharePct1]
    ${ComputedLend2TranAmount}    Compute Lender Share Transaction Amount with exact percentage    ${ProjectedCycleDue}    &{ExcelPath}[LenderSharePct2]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}|${ComputedLend2TranAmount}
 
    ###GL Entries###
    Navigate to GL Entries
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Debit Amt
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Lender2_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender2_ShortName]    Credit Amt
    ${Lender1_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001   Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001    Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${HostBank_Credit}|${Lender1_Credit}|${Lender2_Credit}
    Validate if Debit and Credit Amt is Balanced    ${Borrower_Debit}    ${HostBank_Credit}|${Lender1_Credit}|${Lender2_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    ${ProjectedCycleDue}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    UATDEAL1-Cashflow
    Take Screenshot    ${SCREENSHOT_FILENAME}
    
    mx LoanIQ click element if present     ${LIQ_PaymentNotebook_Cashflow_OK_Button}      
    Send Ongoing Fee Payment to Approval
    
    ### Ongoing Fee Payment Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Work in Process for Ongoing Fee Payment Approval    &{ExcelPath}[Facility_Name]
    Approve Ongoing Fee Payment
    Close All Windows on LIQ
    
    ###Ongoing Fee Payment Notebook - Workflow Tab###  
    Navigate Work in Process for Ongoing Fee Payment Release    &{ExcelPath}[Facility_Name]
    ###Cashflow Notebook - Release Cashflows###
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_WorkflowItems}     Release Cashflows
    Release Cashflow    &{ExcelPath}[Borrower_ShortName]|&{ExcelPath}[Lender1_ShortName]|&{ExcelPath}[Lender2_ShortName]

    ###GL Entries###
    Navigate to GL Entries
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Debit Amt
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Lender2_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender2_ShortName]    Credit Amt
    ${Lender1_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001   Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001    Debit Amt
    Set Test Variable    ${SCREENSHOT_FILENAME}    UATDEAL1-GLEntries
    Take Screenshot    ${SCREENSHOT_FILENAME}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Credit}|${Lender2_Credit}|${Lender1_Credit}    ${Borrower_Debit} 
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    ${ProjectedCycleDue}
    Close GL Entries and Cashflow Window

    Release Ongoing Fee Payment

    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ##Deal Notebook - Summary Tab### 
    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[OngoingFee_Type]

    ##Commitment Fee Notebook - Acrual Tab###   
    Validate Details on Acrual Tab    ${ProjectedCycleDue}    &{ExcelPath}[Cycle_Number]
    Set Test Variable    ${SCREENSHOT_FILENAME}    UATDEAL1-CommitmentFeeAccruals
    Take Screenshot    ${SCREENSHOT_FILENAME}
    Validate release of Ongoing Fee Payment
    Set Test Variable    ${SCREENSHOT_FILENAME}    UATDEAL1-CommitmentFeeRelease
    Take Screenshot    ${SCREENSHOT_FILENAME}    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

Update Ongoing Fee Cycle for UAT Deal
    [Documentation]    This keyword will update the existing commitment fee cycle in the created deal
    ...    @author: fmamaril    03SEP2019    Initial Create
    ...    @update: fmamaril    04SEP2019    Update handling per fee 
    [Arguments]    ${ExcelPath}
    
    ###Loan IQ Desktop###
    ${SystemDate}    Get System Date
    
    ###Commitment Fee Notebook - General Tab###
    Run Keyword If    '&{ExcelPath}[rowid]'=='1'    Run Keywords    Open Existing Deal    &{ExcelPath}[Deal_Name]    
    ...    AND    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[OngoingFee_Type]
    # ...    AND    Setup Commitment Fee Effective Date and Cycle   &{ExcelPath}[Effective_Date]    &{ExcelPath}[Fee_Cycle]  
    ...    AND    Close All Windows on LIQ

    Run Keyword If    '&{ExcelPath}[rowid]'=='2'    Run Keywords    Open Existing Deal    &{ExcelPath}[Deal_Name]    
    ...    AND    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[OngoingFee_Type]
    ...    AND    Setup Line Fee Effective Date and Cycle   &{ExcelPath}[Effective_Date]    &{ExcelPath}[Fee_Cycle]  
    ...    AND    Close All Windows on LIQ

Line Fee Payment for D00000454
    [Documentation]    This keyword collects the commitment fee payment of the facility
    ...    @author:fmamaril    03SEP2019    Intial Create
    [Arguments]    ${ExcelPath}
    
    ### Navigate to Commitment Fee Notebook ###
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate Directly to Line Fee Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    
    ### Commitment Fee Notebook - General Tab ###  
    ${ComputedCycleDue}    ${Rate}    ${RateBasis}    ${BalanceAmount}    Compute Line Fee Amount Per Cycle    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[Effective_Date]
    Write Data To Excel    SERV29_CommitmentFeePayment    Computed_CycleDue    &{ExcelPath}[rowid]    ${ComputedCycleDue}    ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV29_CommitmentFeePayment    Rate    &{ExcelPath}[rowid]    ${Rate}    ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV29_CommitmentFeePayment    Balance_Amount    &{ExcelPath}[rowid]    ${BalanceAmount}    ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV29_CommitmentFeePayment    Rate_Basis    &{ExcelPath}[rowid]    ${RateBasis}    ${CBAUAT_ExcelPath}
        
    ### Ongoing Fee Payment ###
    Select Cycle Due Line Fee Payment 
    Enter Effective Date for Line Fee-Cycle Due Payment    &{ExcelPath}[Effective_Date]
    
    ### Ongoing Fee Payment - Cashflow Validation ###
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_WorkflowItems}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]    
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender_RemittanceDescription]    &{ExcelPath}[Lender_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]  
    
    ### GL Entries Validation ###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]

    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount with exact percentage    ${ComputedCycleDue}    &{ExcelPath}[HostBankSharePct]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount with exact percentage    ${ComputedCycleDue}    &{ExcelPath}[LenderSharePct1]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}
 
    ###GL Entries###
    Navigate to GL Entries
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Debit Amt
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Lender1_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001   Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001    Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}    ${HostBank_Credit}|${Lender1_Credit}
    Validate if Debit and Credit Amt is Balanced    ${Borrower_Debit}    ${HostBank_Credit}|${Lender1_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    ${ComputedCycleDue}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    UATDEAL1-Cashflow
    Take Screenshot    ${SCREENSHOT_FILENAME}
    
    mx LoanIQ click element if present     ${LIQ_PaymentNotebook_Cashflow_OK_Button}      
    Send Ongoing Fee Payment to Approval
    
    ### Ongoing Fee Payment Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Work in Process for Ongoing Fee Payment Approval    &{ExcelPath}[Facility_Name]
    Approve Ongoing Fee Payment
    Close All Windows on LIQ
    
    ###Ongoing Fee Payment Notebook - Workflow Tab###  
    Navigate Work in Process for Ongoing Fee Payment Release    &{ExcelPath}[Facility_Name]
    ###Cashflow Notebook - Release Cashflows###
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_WorkflowItems}     Release
    ###GL Entries###
    Navigate to GL Entries from Ongoing Fee Payment
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Debit Amt
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Lender1_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001   Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001    Debit Amt
    Set Test Variable    ${SCREENSHOT_FILENAME}    UATDEAL1-GLEntries
    Take Screenshot    ${SCREENSHOT_FILENAME}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Credit}|${Lender1_Credit}    ${Borrower_Debit} 
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    ${ComputedCycleDue}
    Close GL Entries and Cashflow Window
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
Commitment Fee Release for D00000454 
    [Documentation]    This keyword releases the commitment fee of the facility
    ...    @author:fmamaril    04SEP2019    Intial Create
    [Arguments]    ${ExcelPath}
    
    ### Navigate to Commitment Fee Notebook ###
    Search Existing Deal    &{ExcelPath}[Deal_Name]    
    # Navigate Directly to Commitment Fee Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    # Check if Commitment Fee is already released
    
Line Fee Release for D00000454 
    [Documentation]    This keyword releases the line fee of the facility
    ...    @author:fmamaril    04SEP2019    Intial Create
    [Arguments]    ${ExcelPath}
    
    ### Navigate to Commitment Fee Notebook ###
    Search Existing Deal    &{ExcelPath}[Deal_Name]    
    Navigate Directly to Line Fee Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    Check if Line Fee is already released
    
Commitment Fee Payment with Split Balance for D00000454
    [Documentation]    This keyword collects the commitment fee payment of the facility
    ...    @author:fmamaril    03SEP2019    Intial Create
    [Arguments]    ${ExcelPath}

    ${Date}    Get System Date
    
    ### Navigate to Commitment Fee Notebook ###
    Search Existing Deal    &{ExcelPath}[Deal_Name]    
    # Navigate Directly to Commitment Fee Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    
    ### Commitment Fee Notebook - General Tab ###  
    ${Rate}    ${BalanceAmount}    ${RateBasis}    Get Data in General Tab
    
    ${ProjectedCycleDue}    Run Keyword If    &{ExcelPath}[rowid] == 3    Run Keyword    Compute Commitment Fee Amount Per Cycle    &{ExcelPath}[Balance_Amount]    &{ExcelPath}[Rate_Basis]    &{ExcelPath}[Cycle_Number]    ${Date}    &{ExcelPath}[Total]    
    ...    ELSE    Compute Commitment Fee Amount Per Cycle    &{ExcelPath}[Balance_Amount]    &{ExcelPath}[Rate_Basis]    &{ExcelPath}[Cycle_Number]    ${Date} 
    Write Data To Excel    SERV29_CommitmentFeePayment    Computed_CycleDue    ${rowid}    ${ProjectedCycleDue}    ${CBAUAT_ExcelPath}
    
    ### Ongoing Fee Payment ###
    Select Cycle Due Fee Payment 
    Enter Effective Date for Ongoing Fee-Cycle Due Payment    ${Date}
    
    ### Ongoing Fee Payment - Cashflow Validation ###
    Navigate to Cashflow - Ongoing Fee
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]    
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender_RemittanceDescription]    &{ExcelPath}[Lender_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Lender2_RemittanceDescription]    &{ExcelPath}[Lender2_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender2_ShortName]   
    
    ### GL Entries Validation ###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]
    ${Lend2TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender2_ShortName]

    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount with exact percentage    &{ExcelPath}[Total]    &{ExcelPath}[HostBankSharePct]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount with exact percentage    &{ExcelPath}[Total]    &{ExcelPath}[LenderSharePct1]
    ${ComputedLend2TranAmount}    Compute Lender Share Transaction Amount with exact percentage    &{ExcelPath}[Total]    &{ExcelPath}[LenderSharePct2]
 
    ###GL Entries###
    Navigate to GL Entries
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Debit Amt
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Lender2_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender2_ShortName]    Credit Amt
    ${Lender1_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001   Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001    Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${HostBank_Credit}|${Lender1_Credit}|${Lender2_Credit}
    Validate if Debit and Credit Amt is Balanced    ${Borrower_Debit}    ${HostBank_Credit}|${Lender1_Credit}|${Lender2_Credit}
    ###For Improvement Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    &{ExcelPath}[Total]
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    UATDEAL1-Cashflow
    Take Screenshot    ${SCREENSHOT_FILENAME}
    
    mx LoanIQ click element if present     ${LIQ_PaymentNotebook_Cashflow_OK_Button}      
    Send Ongoing Fee Payment to Approval
    
    ### Ongoing Fee Payment Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Work in Process for Ongoing Fee Payment Approval    &{ExcelPath}[Facility_Name]
    Approve Ongoing Fee Payment
    Close All Windows on LIQ
    
    ###Ongoing Fee Payment Notebook - Workflow Tab###  
    Navigate Work in Process for Ongoing Fee Payment Release    &{ExcelPath}[Facility_Name]
    ###Cashflow Notebook - Release Cashflows###
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_WorkflowItems}     Release Cashflows
    Release Cashflow    &{ExcelPath}[Borrower_ShortName]|&{ExcelPath}[Lender1_ShortName]|&{ExcelPath}[Lender2_ShortName]

    ###GL Entries###
    Navigate to GL Entries
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Debit Amt
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Lender2_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender2_ShortName]    Credit Amt
    ${Lender1_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001   Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001    Debit Amt
    Set Test Variable    ${SCREENSHOT_FILENAME}    UATDEAL1-GLEntries
    Take Screenshot    ${SCREENSHOT_FILENAME}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Credit}|${Lender2_Credit}|${Lender1_Credit}    ${Borrower_Debit} 
    ###For Improvement Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    &{ExcelPath}[Total]
    Close GL Entries and Cashflow Window

    Release Ongoing Fee Payment

    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ##Deal Notebook - Summary Tab### 
    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[OngoingFee_Type]

    ##Commitment Fee Notebook - Acrual Tab###   
    Validate release of Ongoing Fee Payment
    Set Test Variable    ${SCREENSHOT_FILENAME}    UATDEAL1-CommitmentFeeRelease
    Take Screenshot    ${SCREENSHOT_FILENAME}    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
Run Online Accrual for Commitment Fee
    [Documentation]    This keyword runs online accrual for commitment fee
    ...    @author:fmamaril    12SEP2019    Intial Create
    [Arguments]    ${ExcelPath}
    Search Existing Deal    &{ExcelPath}[Deal_Name]    
    # Navigate Directly to Commitment Fee Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    Run Online Acrual to Commitment Fee
    
Run Online Accrual for Line Fee
    [Documentation]    This keyword runs online accrual for line fee
    ...    @author:fmamaril    17SEP2019    Intial Create
    [Arguments]    ${ExcelPath}
    Search Existing Deal    &{ExcelPath}[Deal_Name]    
    Navigate Directly to Line Fee Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    Run Online Acrual to Line Fee
    
    
Line Fee Payment with Split Balance for D00000454
    [Documentation]    This keyword collects the commitment fee payment of the facility
    ...    @author:fmamaril    18SEP2019    Intial Create
    [Arguments]    ${ExcelPath}
    
    ### Navigate to Commitment Fee Notebook ###
    Search Existing Deal    &{ExcelPath}[Deal_Name]    
    Navigate Directly to Line Fee Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    
    ### Commitment Fee Notebook - General Tab ###  
    ${ComputedCycleDue}    ${Rate}    ${RateBasis}    ${BalanceAmount}    Compute Line Fee Amount Per Cycle    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[Effective_Date]
        
    ### Ongoing Fee Payment ###
    Select Cycle Due Line Fee Payment 
    Enter Effective Date for Line Fee-Cycle Due Payment    &{ExcelPath}[Effective_Date]
    
    ### Ongoing Fee Payment - Cashflow Validation ###
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_WorkflowItems}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]    
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender_RemittanceDescription]    &{ExcelPath}[Lender_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]  
    
    ### GL Entries Validation ###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]

    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount with exact percentage    ${ExcelPath}[Total]    &{ExcelPath}[HostBankSharePct]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount with exact percentage    ${ExcelPath}[Total]    &{ExcelPath}[LenderSharePct1]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}
 
    ###GL Entries###
    Navigate to GL Entries
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Debit Amt
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Lender1_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001   Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001    Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}    ${HostBank_Credit}|${Lender1_Credit}
    Validate if Debit and Credit Amt is Balanced    ${Borrower_Debit}    ${HostBank_Credit}|${Lender1_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    ${ExcelPath}[Total]
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    UATDEAL1-Cashflow
    Take Screenshot    ${SCREENSHOT_FILENAME}
    
    mx LoanIQ click element if present     ${LIQ_PaymentNotebook_Cashflow_OK_Button}      
    Send Ongoing Fee Payment to Approval
    
    ### Ongoing Fee Payment Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Work in Process for Ongoing Fee Payment Approval    &{ExcelPath}[Facility_Name]
    Approve Ongoing Fee Payment
    Close All Windows on LIQ
    
    ###Ongoing Fee Payment Notebook - Workflow Tab###  
    Navigate Work in Process for Ongoing Fee Payment Release    &{ExcelPath}[Facility_Name]
    ###Cashflow Notebook - Release Cashflows###
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_WorkflowItems}     Release
    ###GL Entries###
    Navigate to GL Entries from Ongoing Fee Payment
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Debit Amt
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Lender1_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001   Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001    Debit Amt
    Set Test Variable    ${SCREENSHOT_FILENAME}    UATDEAL1-GLEntries
    Take Screenshot    ${SCREENSHOT_FILENAME}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Credit}|${Lender1_Credit}    ${Borrower_Debit} 
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    ${ExcelPath}[Total]
    Close GL Entries and Cashflow Window
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}          