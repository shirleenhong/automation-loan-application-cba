*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Create Initial Loan Drawdown with Repayment Schedule for DNR
    [Documentation]    This keyword is used to create initial loan drawdown with repayment schedule.
    ...    @author: clanding    26NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ###Close all windows###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Facility###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    ${AvailToDrawAmount}    Get Facility Global Available to Draw Amount
    ${GlobalOutstandings}    Get Facility Global Outstandings
    
    Write Data To Excel    SC1_LoanDrawdown   Facility_CurrentAvailToDraw    ${TestCase_Name}     ${AvailToDrawAmount}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    SC1_LoanDrawdown   Facility_CurrentGlobalOutstandings    ${TestCase_Name}     ${AvailToDrawAmount}    ${DNR_DATASET}    bTestCaseColumn=True
    
    ##Outstanding Select Window###
    Navigate to Outstanding Select Window
    ${Loan_Alias}    Input Initial Loan Drawdown Details    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_Currency]
    Write Data To Excel    SC1_LoanDrawdown   Loan_Alias    ${TestCase_Name}     ${Loan_Alias}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    SC1_PaymentFees   Loan_Alias    ${TestCase_Name}    ${Loan_Alias}    ${DNR_DATASET}    bTestCaseColumn=True
        
    ###Initial Loan Drawdown###
    ${SysDate}    Get System Date
    Validate Initial Loan Dradown Details    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Loan_Currency]
    ${AdjustedDueDate}    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    ${SysDate}    None    None    &{ExcelPath}[Loan_IntCycleFrequency]    &{ExcelPath}[Loan_Accrue]
    Input Loan Drawdown Rates    &{ExcelPath}[Borrower_BaseRate]    &{ExcelPath}[Facility_Spread]
    
    ###Repayment Schedule###
    Create Repayment Schedule for Fixed Loan with Interest
    
    ###Cashflow Notebook - Create Cashflows###
    Navigate to Drawdown Cashflow Window
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]  
 
    ##Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow    &{ExcelPath}[Loan_Currency]
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[HostBankSharePct]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Debit Amt
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower1_ShortName]    Credit Amt    
    ${UITotalCreditAmt}    Run Keyword If    '&{ExcelPath}[BranchCode]' != 'None'    Get GL Entries Amount    ${SPACE}Total For: &{ExcelPath}[BranchCode]     Credit Amt
    ...    ELSE    Get GL Entries Amount    ${SPACE}Total For: CB001     Credit Amt
    ${UITotalDebitAmt}    Run Keyword If    '&{ExcelPath}[BranchCode]' != 'None'    Get GL Entries Amount    ${SPACE}Total For: &{ExcelPath}[BranchCode]     Debit Amt
    ...    ELSE    Get GL Entries Amount    ${SPACE}Total For: CB001     Debit Amt
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    &{ExcelPath}[Loan_RequestedAmount]

    ###Approval of Loan###
    Send Initial Drawdown to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Refresh Tables in LIQ    
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Initial Drawdown     ${Loan_Alias}
    Approve Initial Drawdown
    
    ###Rate Setting###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Send to Rate Approval    Loan Initial Drawdown     ${Loan_Alias}
    Send Initial Drawdown to Rate Approval
        
    ###Rate Approval###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Refresh Tables in LIQ
    Select Item in Work in Process	Outstandings	Awaiting Rate Approval	Loan Initial Drawdown	${Loan_Alias}
    Select Item in Work in Process    Outstandings    Awaiting Rate Approval    Loan Initial Drawdown     ${Loan_Alias}
    Approve Initial Drawdown Rate
    
Release Initial Loan Drawdown and Add Alerts and Comments for DNR
    [Documentation]    This keyword is used to release initial loan drawdown with repayment schedule.
    ...    @author: clanding    26NOV2020    - initial create
    [Arguments]    ${ExcelPath}   
    
    ###Cashflow Notebook - Release Cashflows###
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Borrower1_ShortName]

    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Release

    ### Release Loan Drawdown
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    Navigate to an Existing Loan    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Loan_FacilityName]    &{ExcelPath}[Loan_Alias]

    ### Add Alert ###
    ${Alerts_Details}    ${Date_Added}    Add Alerts in Loan Notebook    &{ExcelPath}[Alerts_ShortDescription]    &{ExcelPath}[Alerts_DetailsPrefix]
    Write Data To Excel    SC1_LoanDrawdown   Alerts_Details    ${TestCase_Name}     ${Alerts_Details}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    SC1_LoanDrawdown   Alerts_DateAddedAmended    ${TestCase_Name}     ${Date_Added}    ${DNR_DATASET}    bTestCaseColumn=True

    ### Add Comments ###
    ${Comment_Author}    ${Comment_Date}    ${Comment_Details}    ${Comment_DateWithTime}    Add Details in Comments Tab in Loan Notebook    &{ExcelPath}[Comments_Subject]    &{ExcelPath}[Comments_Prefix]
    Write Data To Excel    SC1_LoanDrawdown   User_ID    ${TestCase_Name}     ${Comment_Author}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    SC1_LoanDrawdown   Comments_DateAddedAmended    ${TestCase_Name}     ${Date_Added}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    SC1_LoanDrawdown   Comments_Details    ${TestCase_Name}     ${Comment_Details}    ${DNR_DATASET}    bTestCaseColumn=True

    Close All Windows on LIQ

Create Initial Loan Drawdown with no Repayment Schedule for DNR
    [Documentation]    This keyword is used to create a Loan Drawdown without selecting a Payment Schedule.
    ...    @author: clanding    27NOV2020    - initial create
    [Arguments]    ${ExcelPath}    
    
    ###Facility###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    ${AvailToDrawAmount}    Get Facility Global Available to Draw Amount
    ${GlobalOutstandings}    Get Facility Global Outstandings
    
    Write Data To Excel    SC1_LoanDrawdown   Facility_CurrentAvailToDraw    ${TestCase_Name}     ${AvailToDrawAmount}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    SC1_LoanDrawdown   Facility_CurrentGlobalOutstandings    ${TestCase_Name}     ${GlobalOutstandings}    ${DNR_DATASET}    bTestCaseColumn=True
    
    ##Outstanding Select Window###
    Navigate to Outstanding Select Window
    ${Loan_Alias}    Input Initial Loan Drawdown Details    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Loan_FacilityName]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_Currency]
    Write Data To Excel    SC1_LoanDrawdown   Loan_Alias    ${TestCase_Name}     ${Loan_Alias}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    SC1_UnscheduledPayments   Loan_Alias    ${TestCase_Name}     ${Loan_Alias}    ${DNR_DATASET}    bTestCaseColumn=True
        
    ###Initial Loan Drawdown###   
    Validate Initial Loan Dradown Details    &{ExcelPath}[Loan_FacilityName]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Loan_Currency]
    ${AdjustedDueDate}    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_MaturityDate]    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_IntCycleFrequency]    &{ExcelPath}[Loan_Accrue]    
    # Write Data To Excel    SERV21_InterestPayments    ScheduledActivityReport_Date    ${rowid}    ${AdjustedDueDate}
    Input Loan Drawdown Rates    &{ExcelPath}[Borrower_BaseRate]    &{ExcelPath}[Facility_Spread]
    
    ###Cashflow Notebook - Create Cashflows###
    Navigate to Drawdown Cashflow Window
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]  
 
    ###Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow    &{ExcelPath}[Facility_Currency]   
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[HostBankSharePct]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Debit Amt
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower1_ShortName]    Credit Amt    
    ${UITotalCreditAmt}    Run Keyword If    '&{ExcelPath}[BranchCode]' != 'None'    Get GL Entries Amount    ${SPACE}Total For: &{ExcelPath}[BranchCode]     Credit Amt
    ...    ELSE    Get GL Entries Amount    ${SPACE}Total For: CB001     Credit Amt
    ${UITotalDebitAmt}    Run Keyword If    '&{ExcelPath}[BranchCode]' != 'None'    Get GL Entries Amount    ${SPACE}Total For: &{ExcelPath}[BranchCode]     Debit Amt
    ...    ELSE    Get GL Entries Amount    ${SPACE}Total For: CB001     Debit Amt   
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    &{ExcelPath}[Loan_RequestedAmount]

    ###Approval of Loan###
    Send Initial Drawdown to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Initial Drawdown     ${Loan_Alias}
    Approve Initial Drawdown
    
    ###Rate Setting###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Send to Rate Approval    Loan Initial Drawdown     ${Loan_Alias}
    Send Initial Drawdown to Rate Approval
        
    ###Rate Approval###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Rate Approval    Loan Initial Drawdown     ${Loan_Alias}
    Approve Initial Drawdown Rate
    
    ###Generate Rate Setting Notices###
    Generate Rate Setting Notices for Drawdown    &{ExcelPath}[Borrower1_LegalName]    &{ExcelPath}[NoticeStatus]
    
    ###Cashflow Notebook - Release Cashflows###
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Borrower1_ShortName]

    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Release
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

Get Fee Alias from Ongoing Fee Setup for DNR
    [Documentation]    This keyword is used to get details from Ongoing Fee Setup.
    ...    @author: clanding    27NOV2020    - initial create
    [Arguments]    ${ExcelPath}

    Open Existing Deal    &{ExcelPath}[Deal_Name]
    ${Fee_Alias}    Get Facility Ongoing Fee Alias    &{ExcelPath}[Facility_Name]
    Open Facility Navigator from Deal Notebook
    Open Ongoing Fee List from Facility Navigator    &{ExcelPath}[Facility_Name]
    Open Ongoing Fee from Fee List    ${Fee_Alias}
    ${ActualDueDate}    ${AdjustedDueDate}    Get Actual and Adjusted Due Date

    Write Data To Excel    SC1_LoanDrawdown    Fee_Alias    ${TestCase_Name}    ${Fee_Alias}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    SC1_LoanDrawdown    ActualDueDate    ${TestCase_Name}    ${ActualDueDate}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    SC1_LoanDrawdown    AdjustedDueDate    ${TestCase_Name}    ${AdjustedDueDate}    ${DNR_DATASET}    bTestCaseColumn=True

    Close All Windows on LIQ

Write Loan Details from Deal for DNR
    [Documentation]    This keyword is used to write needed details for Loan Drawdown.
    ...    @author: clanding    25NOV2020    - initial create
    [Arguments]    ${ExcelPath}

    Write Data To Excel    SC1_LoanDrawdown    Loan_EffectiveDate    ${TestCase_Name}    &{ExcelPath}[Deal_EffectiveDate]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    SC1_LoanDrawdown    Repayment_TriggerDate    ${TestCase_Name}    &{ExcelPath}[Deal_EffectiveDate]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    SC1_LoanDrawdown    Deal_Name    ${TestCase_Name}    &{ExcelPath}[Deal_Name]    ${DNR_DATASET}    bTestCaseColumn=True

Write Loan Details from Facility for DNR
    [Documentation]    This keyword is used to write needed details for Loan Drawdown.
    ...    @author: clanding    25NOV2020    - initial create
    [Arguments]    ${ExcelPath}

    Write Data To Excel    SC1_LoanDrawdown    Facility_Name    ${TestCase_Name}    &{ExcelPath}[Facility_Name]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    SC1_LoanDrawdown    Loan_FacilityName    ${TestCase_Name}    &{ExcelPath}[Facility_Name]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    SC1_LoanDrawdown   Loan_MaturityDate    ${TestCase_Name}     &{ExcelPath}[Facility_MaturityDate]    ${DNR_DATASET}    bTestCaseColumn=True

Get Loan Details and Write in DNR Dataset for Alerts and Comments
    [Documentation]    This keyword is used to get details for each report and write in dataset.
    ...    @author: clanding    01DECV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    ${TrackingNumber}    Get Deal Tracking Number
    ${FName_UI}    ${LName_UI}    Get First Name of a User    &{ExcelPath}[User_ID]
    
    ### Writing for Comments Report ###
    Write Data To Excel    CMMNT    Deal_Name    CMMNT_009    &{ExcelPath}[Deal_Name]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Deal_Tracking_Number    CMMNT_009    ${TrackingNumber}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Alias_Number    CMMNT_009    &{ExcelPath}[Loan_Alias]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Comment_Heading    CMMNT_009    &{ExcelPath}[Comments_Subject]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Comment_Detail    CMMNT_009    &{ExcelPath}[Comments_Details]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    User_ID    CMMNT_009    &{ExcelPath}[User_ID]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Date_Added_Amended    CMMNT_009    &{ExcelPath}[Comments_DateAddedAmended]    ${DNR_DATASET}    bTestCaseColumn=True

    ### Writing for Alerts Report ###
    Write Data To Excel    ALERT    Deal_Name    ALERT_009    &{ExcelPath}[Deal_Name]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Deal_Tracking_Number    ALERT_009    ${TrackingNumber}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Alias_Number    ALERT_009    &{ExcelPath}[Loan_Alias]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Alert_Heading    ALERT_009    &{ExcelPath}[Alerts_ShortDescription]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Alert_Content    ALERT_009    &{ExcelPath}[Alerts_Details]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    User_Name    ALERT_009    ${FName_UI}${SPACE}${LName_UI}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Date_Added_Amended    ALERT_009    &{ExcelPath}[Alerts_DateAddedAmended]    ${DNR_DATASET}    bTestCaseColumn=True

    Close All Windows on LIQ
    