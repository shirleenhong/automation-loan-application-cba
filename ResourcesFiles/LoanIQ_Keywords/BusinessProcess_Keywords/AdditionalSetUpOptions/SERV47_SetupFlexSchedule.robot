*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
   
*** Keywords ***

Create Loan Drawdown with Flex Schedule for Fixed P&I Repayment
    [Documentation]    create a Loan Drawdown for a Term Facility with Flex P&I Schedule
    ...    @author:mgaling
    ...    @udpate: rtarayao    11MAR2019    Updated low-level keywords usage.
    ...    @update: hstone    20MAY2020    - Added 'Release Cashflow Based on Remittance Instruction'
    ...                                    - Replaced 'Navigate Notebook Workflow' with 'Navigate to Loan Drawdown Workflow and Proceed With Transaction'
    ...                                    - Fixed 'Verify if Method has Remittance Instruction' arguments on Create Cashflows
    ...    @update: dahijara    03JUL2020    - Replaced 'Create Flex Repayment Schedule' to 'Create Flex Repayment Schedule for Initial Drawdown'
    [Arguments]    ${ExcelPath}
    ###Launch Facility Notebook###
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility2_Name]
    ${AvailToDrawAmount}    Get Facility Global Available to Draw Amount
    ${GlobalOutstandings}    Get Facility Global Outstandings
    Write Data To Excel    SERV_47_FlexPISchedule   Facility_CurrentAvailToDraw    ${rowid}    ${AvailToDrawAmount}
    Write Data To Excel    SERV_47_FlexPISchedule   Facility_CurrentGlobalOutstandings    ${rowid}    ${GlobalOutstandings}
    
    ###Create a Loan###
    Navigate to Outstanding Select Window
    ${sLoanAlias}    Populate Outstanding Select Window    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility2_Name]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Loan_PricingOption]
     ...    &{ExcelPath}[Loan_Currency]    
     Write Data To Excel    SERV_47_FlexPISchedule    Loan_Alias    ${rowid}    ${sLoanAlias}    
     Write Data To Excel    SERV23_LoanPaperClip    Loan_Alias    ${rowid}    ${sLoanAlias} 
     Write Data To Excel    SERV18_Payments    Loan_Alias    ${rowid}    ${sLoanAlias}
    ${sLoan_Alias}    Read Data From Excel    SERV_47_FlexPISchedule    Loan_Alias    ${rowid} 
    
    ###Initial Drawdown Notebook###
    ${sSystemDate}    Get System Date
    Write Data To Excel    SERV_47_FlexPISchedule    Loan_EffectiveDate    ${rowid}    ${sSystemDate}
    ${sLoan_EffectiveDate}    Read Data From Excel    SERV_47_FlexPISchedule    Loan_EffectiveDate    ${rowid}
    Populate General Tab in Initial Drawdown    &{ExcelPath}[Loan_RiskType]    &{ExcelPath}[Loan_RequestedAmount]    ${sLoan_EffectiveDate}    &{ExcelPath}[Loan_MaturityDate]    &{ExcelPath}[Loan_RepricingFrequency]  
    ${sAllInRate}    Input Loan Drawdown Rates    &{ExcelPath}[Borrower_BaseRate]    &{ExcelPath}[Facility_Spread]
    Write Data To Excel    SERV_47_FlexPISchedule    AllInRate_Value    ${rowid}    ${sAllInRate}    
   
    ###Flex Repayment Schedule###
    Create Flex Repayment Schedule for Initial Drawdown
    ${sDate}    Add Fixed PI Items in Flexible Schedule    &{ExcelPath}[Item_NoOFPayments]    &{ExcelPath}[Item_Frequency]    &{ExcelPath}[Item_type]    &{ExcelPath}[Item_PIAmount]    &{ExcelPath}[NonBusinessDayRule] 
    Write Data To Excel    SERV_47_FlexPISchedule    FixedPI_Date    ${rowid}    ${sDate}
    ${sFixedPI_Date}    Read Data From Excel    SERV_47_FlexPISchedule    FixedPI_Date    ${rowid}
         
    Calculate Payments in Flexible Schedule    ${sFixedPI_Date}
    ${sOrig_RemainingVal}    ${sPrincipalOnlyRemainingVal}    Add Principal Only Item in Flexible Schedule    ${sFixedPI_Date}    &{ExcelPath}[Item2_NoOFPayments]    &{ExcelPath}[Item_Frequency]    &{ExcelPath}[Item2_type]    &{ExcelPath}[Item2_AddedDays]
    ...    &{ExcelPath}[Item_PrincipalAmount]    &{ExcelPath}[AutoGen_Item] 
    Write Data To Excel    SERV_47_FlexPISchedule    Orig_RemainingVal    ${rowid}    ${sOrig_RemainingVal}
    Write Data To Excel    SERV_47_FlexPISchedule    PrincipalOnlyRemainingVal    ${rowid}    ${sPrincipalOnlyRemainingVal}
    ${PrincipalOnlyRemainingVal}    Read Data From Excel    SERV_47_FlexPISchedule    PrincipalOnlyRemainingVal    ${rowid}   
    ${Orig_RemainingVal}    Read Data From Excel    SERV_47_FlexPISchedule    Orig_RemainingVal    ${rowid}
        
    Calculate Payments in Flexible Schedule    ${sFixedPI_Date}
    ${sRateBasis_Value}    Add Interest Only Item in Flexible Schedule    ${sFixedPI_Date}    ${Orig_RemainingVal}    ${PrincipalOnlyRemainingVal}    &{ExcelPath}[Item2_NoOFPayments]    &{ExcelPath}[Item_Frequency]    &{ExcelPath}[Item3_type]    &{ExcelPath}[Item3_AddedDays]
    ...    ${sAllInRate}    &{ExcelPath}[Item2_AddedDays]    &{ExcelPath}[AutoGen_Item] 
    ${sFixedPIitem_Payment}    ${sUINewInterestOnly_Payment}    Calculate Payments in Flexible Schedule After Adding Items    ${sFixedPI_Date}    &{ExcelPath}[Item2_type]    &{ExcelPath}[Item3_type]
    ...    ${Orig_RemainingVal}    ${sAllInRate}    ${sRateBasis_Value}    ${PrincipalOnlyRemainingVal}    &{ExcelPath}[AutoGen_Item]
    Write Data To Excel    SERV_47_FlexPISchedule    Flex_Payment_Value    ${rowid}     ${sFixedPIitem_Payment}
    Write Data To Excel    SERV23_LoanPaperClip    Repayment_FirstPaymentAmount    ${rowid}     ${sFixedPIitem_Payment}
    Write Data To Excel    SERV_47_FlexPISchedule    UINewInterestOnly_Payment    ${rowid}    ${sUINewInterestOnly_Payment}
    ${sUINewInterestOnly_Payment}    Read Data From Excel    SERV_47_FlexPISchedule    UINewInterestOnly_Payment    ${rowid}
    
    Validate Flex Schedule Details in Repayment Schedule    &{ExcelPath}[Item_PrincipalAmount]    ${sUINewInterestOnly_Payment}
    
    ###Workflow Items- Split Cashflow###
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RTGSRemittanceDescription]    &{ExcelPath}[Borrower1_RTGSRemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]
    
    ${sHostBankShare}    Get Host Bank Cash in Cashflow
    ${sBorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
    ${sComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    100
    Compare UIAmount versus Computed Amount    ${sHostBankShare}    ${sComputedHBTranAmount}

    ###Workflow Items- Split Cashflow GL Entries Validation###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender1_Portfolio]   Debit Amt
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower1_ShortName]    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001    Debit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001    Credit Amt

    Compare UIAmount versus Computed Amount    ${HostBank_Debit}    ${sComputedHBTranAmount}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    &{ExcelPath}[Loan_RequestedAmount]
    
    Navigate Split Cashflows for Drawdown
    ${sSplitDDAAmount}    ${sSplitRTGSAmount}    Populate Split Cashflow Details    &{ExcelPath}[Borrower1_RTGSRemittanceDescription1]    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[SplitPrincipal_Percent] 
    ${sSplitRTGSAmount}    Convert Number With Comma Separators    ${sSplitRTGSAmount}
    ${sSplitDDAAmount}    Convert Number With Comma Separators    ${sSplitDDAAmount}
    
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RTGSRemittanceDescription]    &{ExcelPath}[Borrower1_RTGSRemittanceInstruction]    ${sSplitRTGSAmount}    &{ExcelPath}[Loan_Currency]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RTGSRemittanceDescription1]    &{ExcelPath}[Borrower1_RTGSRemittanceInstruction1]    ${sSplitDDAAmount}    &{ExcelPath}[Loan_Currency]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RTGSRemittanceInstruction]    ${sSplitRTGSAmount}    
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RTGSRemittanceInstruction1]    ${sSplitDDAAmount}
    
    Navigate to GL Entries
    ${sComputedHBTranAmount}    Convert Number With Comma Separators    ${sComputedHBTranAmount}
    Verify GL Entries Amount    ${sComputedHBTranAmount}    Debit Amt    &{ExcelPath}[Lender1_Portfolio]    Customer/Portfolio
    Verify GL Entries Amount    ${sSplitRTGSAmount}    Credit Amt    &{ExcelPath}[Borrower1_ShortName]    Customer/Portfolio
    Verify GL Entries Amount    ${sSplitDDAAmount}   Credit Amt    &{ExcelPath}[Borrower1_ShortName]    Customer/Portfolio
    ${UITotalDebitAmt}    Run Keyword If    '&{ExcelPath}[BranchCode]' != 'None'    Get GL Entries Amount    ${SPACE}Total For: &{ExcelPath}[BranchCode]     Debit Amt
    ...    ELSE    Get GL Entries Amount    ${SPACE}Total For: CB001     Debit Amt        
    ${UITotalCreditAmt}    Run Keyword If    '&{ExcelPath}[BranchCode]' != 'None'    Get GL Entries Amount    ${SPACE}Total For: &{ExcelPath}[BranchCode]     Credit Amt
    ...    ELSE    Get GL Entries Amount    ${SPACE}Total For: CB001     Credit Amt
    
    ${sComputedHBTranAmount}    Remove Comma and Convert to Number    ${sComputedHBTranAmount}
    Compare UIAmount versus Computed Amount    ${HostBank_Debit}    ${sComputedHBTranAmount}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    &{ExcelPath}[Loan_RequestedAmount]
   
    ##Workflow Items- Send to Approval (INPUTTER)### 
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Send to Approval
    Logout from Loan IQ
    
    ###Workflow Items- Approval thru WIP/Rate Approval###
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Approval    Loan Initial Drawdown    ${sLoanAlias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Approval
    Logout from Loan IQ
    
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Send to Rate Approval    Loan Initial Drawdown    ${sLoanAlias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Send to Rate Approval
    Logout from Loan IQ
    
    ###Workflow Items- Rate Approval/Release Cashfows/Generate Intent Notices thru WIP###
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Rate Approval    Loan Initial Drawdown    ${sLoanAlias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Rate Approval

    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Borrower1_RTGSRemittanceInstruction]    ${sSplitRTGSAmount}|${sSplitDDAAmount}    int
    
    Logout from Loan IQ
    
    ###Workflow Items- Release Transaction thru WIP###
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Release    Loan Initial Drawdown    ${sLoanAlias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Release
    Logout from Loan IQ

    ###Verify the created Loan###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Launch Loan Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility2_Name]    ${sLoan_Alias} 
    
    ###Validation in Facility Notebook###
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility2_Name]
    ${sCurrentCmtAmt}    Get Current Commitment Amount
    
    ###Facility Global Outstandings Validation###
    ${sNewGlobalOutstandings}    Get New Facility Global Outstandings  
    ${Facility_CurrentGlobalOutstandings}    Read Data From Excel    SERV_47_FlexPISchedule    Facility_CurrentGlobalOutstandings    ${rowid}
    ${sComputed_GlobalOutstandings}    Compute New Global Outstandings of the Facility    ${Facility_CurrentGlobalOutstandings}    &{ExcelPath}[Loan_RequestedAmount]
    Validate Outstandings    ${sNewGlobalOutstandings}    ${sComputed_GlobalOutstandings}    
    
    ###Facility Available to Draw Validation####
    ${sNewAvailToDrawAmount}    Get New Facility Available to Draw Amount
    ${Facility_CurrentAvailToDraw}    Read Data From Excel    SERV_47_FlexPISchedule    Facility_CurrentAvailToDraw    ${rowid}
    ${sComputed_AvailToDrawAmt}    Compute New Facility Available to Draw Amount after Drawdown    ${Facility_CurrentAvailToDraw}    &{ExcelPath}[Loan_RequestedAmount]
    Validate Draw Amounts    ${sComputed_AvailToDrawAmt}    ${sNewAvailToDrawAmount}  
    
    ###Global Facility Amount Balancing validation###
    Validate Global Facility Amounts - Balanced    ${sNewAvailToDrawAmount}    ${sNewGlobalOutstandings}    ${sCurrentCmtAmt}
    Close All Windows on LIQ
    
