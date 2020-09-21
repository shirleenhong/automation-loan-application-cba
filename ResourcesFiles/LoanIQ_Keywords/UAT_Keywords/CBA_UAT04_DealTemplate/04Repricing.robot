*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Create Repricing for Loan AA in Deal D00000963
    [Documentation]    High-level keyword used to Create Repricing for Loans in Deal D00000963.
    ...                @author: bernchua    26AUG2019    Inital create
    ...                @author: bernchua    10SEP2019    Added setting up of Repayment Schedule during Repricing
    ...                @author: bernchua    18SEP2019    Updated keyword name
    ...                @update: aramos      28AUG2020    Update Take Screenshots
    ...                @update: aramos      10SEP2020    Update [Validate Loan Repricing New Outstanding Amount] in order to provide separate paths for Pricing_Option and Loan_Alias
    [Arguments]    ${ExcelPath}
    
    ${Facility_Spread}    Run Keyword If    '&{ExcelPath}[rowid]'=='1'    Read Data From Excel    CRED02_FacilitySetup    Interest_SpreadValue    1    ${CBAUAT_ExcelPath} 
    ...    ELSE    Read Data From Excel    CRED02_FacilitySetup    Interest_SpreadValue    2    ${CBAUAT_ExcelPath}
    
    Close All Windows on LIQ
    Refresh Tables in LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    Search for Existing Outstanding    Loan    &{ExcelPath}[Facility_Name]
    Select Loan to Reprice    &{ExcelPath}[Loan_Alias]
    Select Repricing Type    Comprehensive Repricing
    Select Loan Repricing for Deal    &{ExcelPath}[Loan_Alias]
    
    Select Existing Outstandings for Loan Repricing    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_Alias]
    Cick Add in Loan Repricing Notebook
    Set Repricing Detail Add Options    Rollover/Conversion to New    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_Name]
    
    ${Effective_Date}    ${Loan_Alias}    Set RolloverConversion Notebook General Details    &{ExcelPath}[Rollover_RequestedAmount]    &{ExcelPath}[Rollover_RepricingFrequency]
    Write Data To Excel    UAT04_Runbook    New_LoanAlias    &{ExcelPath}[rowid]    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    Write Data To Excel    UAT04_Runbook    Loan_Alias    2    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    Save Notebook Transaction    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_Save_Menu}
    Set RolloverConversion Notebook Rates    &{ExcelPath}[Rollover_BaseRate]
    ${AllInRate}    Add Borrower Base Rate and Facility Spread    &{ExcelPath}[Rollover_BaseRate]    ${Facility_Spread}
    ${AllInRate}    Set Variable    ${AllInRate}%
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricing-Rates
    Validate String Data In LIQ Object    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_AllInRate_Text}    ${AllInRate}
    
    ### Setting up of Repayment Schedule
    Navigate from Rollover to Repayment Schedule
    Select Reschedule Menu in Repayment Schedule
    Select Type of Schedule    &{ExcelPath}[RepaymentSchedule_Type]
    
    Add Item in Flexible Schedule Window
    Tick Flexible Schedule Add Item Pay Thru Maturity
    Set Flexible Schedule Add Item Type    &{ExcelPath}[FlexSchedule_Type]
    Tick Flexible Schedule Add Item PI Amount    Principal Amount
    Enter Flexible Schedule Add Item PI Amount    &{ExcelPath}[FlexSchedule_PrincipalAmount]
    Click OK in Add Items for Flexible Schedule
    
    Click OK in Flexible Schedule Window
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanNotebook-RepaymentSchedule
    Save and Exit Repayment Schedule For Loan
    ### End of Repayment Schedule setup script 
    
    Close RolloverConversion Notebook
    
    Validate Loan Repricing New Outstanding Amount    &{ExcelPath}[Pricing_Option]    ${Loan_Alias}    &{ExcelPath}[Rollover_RequestedAmount]
    Validate Loan Repricing Effective Date    ${Effective_Date}
    
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Send to Approval
    
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Approval    Loan Repricing    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Approval
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricing-Approved
    
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Send to Rate Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Rate Approval    Loan Repricing    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Rate Approval
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricing-RateApproved
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Release
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricing-Released
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    

Create Repricing and Partial Repayment for Loan AA
    [Documentation]    High-level keyword used to create a Comprehensive Repricing and Partial Repayment of Loans in Deal D00000963
    ...                @author: bernchua    11SEP2019    Initial create
    ...                @update: bernchua    18SEP2019    Setting up of new Repayment Schedule for Repriced Loan should be done after Release of Rollover transaction, and on the new Loan
    ...                @update: bernchua    20SEP2019    Added Resynchronizing of Loan's Repayment Schedule before Repricing transaction.
    ...                @update: aramos      14SEP2020    Updated to change Validate Loan Repricing New Outstanding Amount to Validate Loan Repricing New Outstanding Amount with Description
    [Arguments]    ${ExcelPath}
    
    ${Facility_Spread}    Run Keyword If    '&{ExcelPath}[rowid]'=='1'    Read Data From Excel    CRED02_FacilitySetup    Interest_SpreadValue    1    ${CBAUAT_ExcelPath} 
    ...    ELSE    Read Data From Excel    CRED02_FacilitySetup    Interest_SpreadValue    2    ${CBAUAT_ExcelPath}
    
    Close All Windows on LIQ
    Refresh Tables in LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ### Resynchronize    
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    Loan    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    Set Notebook to Update Mode    ${LIQ_Loan_Window}    ${LIQ_Loan_InquiryMode_Button}
    Navigate from Loan to Repayment Schedule
    Resynchronize Loan Repayment Schedule
    Save and Exit Repayment Schedule For Loan
    Close Loan Notebook
    ### ===
    
    Search for Existing Outstanding    Loan    &{ExcelPath}[Facility_Name]
    Select Loan to Reprice    &{ExcelPath}[Loan_Alias]
    Select Repricing Type    Comprehensive Repricing
    Select Loan Repricing for Deal    &{ExcelPath}[Loan_Alias]
    
    Select Existing Outstandings for Loan Repricing    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_Alias]

    ${PrincipalPayment_ScheduledItem}    Set Variable    Scheduled Principal Payment
    ${InterestPayment_ScheduledItem}    Set Variable    Scheduled Interest Payment
    
    Cick Add in Loan Repricing Notebook
    Set Repricing Detail Add Options    Scheduled Items    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_Name]
    Verify If Warning Is Displayed
    ${Principal_Amount}    ${Interest_Amount}    ${Total_Amount}    Set Payments for Loan Details    &{ExcelPath}[ScheduledItem_PrincipalAmount]    &{ExcelPath}[ScheduledItem_InterestAmount]    &{ExcelPath}[ScheduledItem_PaymentAmount]
    Validate Loan Repricing New Outstanding Amount with Description   &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_Alias]     ${PrincipalPayment_ScheduledItem}   ${Principal_Amount}
    Validate Loan Repricing New Outstanding Amount with Description    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_Alias]    ${InterestPayment_ScheduledItem}    ${Interest_Amount}
    
    ### Rollover/Conversion Transaction
    Cick Add in Loan Repricing Notebook
    Set Repricing Detail Add Options    Rollover/Conversion to New    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_Name]
    
    ${Effective_Date}    ${Loan_Alias}    Set RolloverConversion Notebook General Details    &{ExcelPath}[Rollover_RequestedAmount]    &{ExcelPath}[Rollover_RepricingFrequency]
    
    Write Data To Excel    UAT04_Runbook    New_LoanAlias    &{ExcelPath}[rowid]    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]'=='2'    Write Data To Excel    UAT04_Runbook    Loan_Alias    3    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    ...    ELSE IF    '&{ExcelPath}[rowid]'=='3'    Write Data To Excel    UAT04_Runbook    Loan_Alias    4    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    
    Save Notebook Transaction    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_Save_Menu}
    Set RolloverConversion Notebook Rates    &{ExcelPath}[Rollover_BaseRate]
    ${AllInRate}    Add Borrower Base Rate and Facility Spread    &{ExcelPath}[Rollover_BaseRate]    ${Facility_Spread}
    ${AllInRate}    Set Variable    ${AllInRate}%
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricing-Rates
    Validate String Data In LIQ Object    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_AllInRate_Text}    ${AllInRate}
    Close RolloverConversion Notebook
    
    Validate Loan Repricing New Outstanding Amount    &{ExcelPath}[Pricing_Option]    ${Loan_Alias}    &{ExcelPath}[Rollover_RequestedAmount]
    Validate Loan Repricing Effective Date    ${Effective_Date}
    
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]    ${Total_Amount}    AUD
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Remittance_Instruction]    ${Total_Amount}
    Click OK In Cashflows
    
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Send to Approval
    
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Approval    Loan Repricing    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Approval
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricing-Approved
    
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Send to Rate Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Rate Approval    Loan Repricing    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Rate Approval
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricing-RateApproved
    
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Release Cashflows 
    Cashflows Mark All To Release
    Click OK In Cashflows
    
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Release
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricing-Released
    Close All Windows on LIQ
    
    ### Setting up of Repayment Schedule
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    Loan    &{ExcelPath}[Facility_Name]    ${Loan_Alias}
    Set Notebook to Update Mode    ${LIQ_Loan_Window}    ${LIQ_Loan_InquiryMode_Button}
    
    Navigate from Loan to Repayment Schedule
    Select Reschedule Menu in Repayment Schedule
    Select Type of Schedule    &{ExcelPath}[RepaymentSchedule_Type]
    
    Add Item in Flexible Schedule Window
    Tick Flexible Schedule Add Item Pay Thru Maturity
    Set Flexible Schedule Add Item Type    &{ExcelPath}[FlexSchedule_Type]
    Tick Flexible Schedule Add Item PI Amount    Principal Amount
    Enter Flexible Schedule Add Item PI Amount    &{ExcelPath}[FlexSchedule_PrincipalAmount]
    Click OK in Add Items for Flexible Schedule
    
    Click OK in Flexible Schedule Window
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanNotebook-RepaymentSchedule
    Save and Exit Repayment Schedule For Loan
    Close All Windows on LIQ
    ### End of Repayment Schedule setup script
        
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    
Create Repricing for Loans in Deal D00000963
    [Documentation]    High-level keyword used to Create Repricing for Loans in Deal D00000963.
    ...                @author: bernchua    18SEP2019    Inital create
    ...                @update: aramos      14SEP2020    Update Validate Loan Repricing New Outstanding Amount to include parameters loan_alias and pricing option
    [Arguments]    ${ExcelPath}
    
    ${Facility_Spread}    Run Keyword If    '&{ExcelPath}[rowid]'=='1'    Read Data From Excel    CRED02_FacilitySetup    Interest_SpreadValue    1    ${CBAUAT_ExcelPath} 
    ...    ELSE    Read Data From Excel    CRED02_FacilitySetup    Interest_SpreadValue    2    ${CBAUAT_ExcelPath}
    
    Close All Windows on LIQ
    Refresh Tables in LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    Search for Existing Outstanding    Loan    &{ExcelPath}[Facility_Name]
    Select Loan to Reprice    &{ExcelPath}[Loan_Alias]
    Select Repricing Type    Comprehensive Repricing
    Select Loan Repricing for Deal    &{ExcelPath}[Loan_Alias]
    
    Select Existing Outstandings for Loan Repricing    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_Alias]
    Cick Add in Loan Repricing Notebook
    Set Repricing Detail Add Options    Rollover/Conversion to New    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_Name]
    
    ${Effective_Date}    ${Loan_Alias}    Set RolloverConversion Notebook General Details    &{ExcelPath}[Rollover_RequestedAmount]    &{ExcelPath}[Rollover_RepricingFrequency]
    
    Write Data To Excel    UAT04_Runbook    New_LoanAlias    &{ExcelPath}[rowid]    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]'=='5'    Write Data To Excel    UAT04_Runbook    Loan_Alias    6    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    ...    ELSE IF    '&{ExcelPath}[rowid]'=='6'    Write Data To Excel    UAT04_Runbook    Loan_Alias    7    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    ...    ELSE IF    '&{ExcelPath}[rowid]'=='7'    Write Data To Excel    UAT04_Runbook    Loan_Alias    8    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    ...    ELSE IF    '&{ExcelPath}[rowid]'=='8'    Write Data To Excel    UAT04_Runbook    Loan_Alias    9    ${Loan_Alias}    ${CBAUAT_ExcelPath}

    Save Notebook Transaction    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_Save_Menu}
    Set RolloverConversion Notebook Rates    &{ExcelPath}[Rollover_BaseRate]
    ${AllInRate}    Add Borrower Base Rate and Facility Spread    &{ExcelPath}[Rollover_BaseRate]    ${Facility_Spread}
    ${AllInRate}    Set Variable    ${AllInRate}%
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricing-Rates
    Validate String Data In LIQ Object    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_AllInRate_Text}    ${AllInRate}
    Close RolloverConversion Notebook
    
    Validate Loan Repricing New Outstanding Amount    &{ExcelPath}[Pricing_Option]    ${Loan_Alias}    &{ExcelPath}[Rollover_RequestedAmount]
    
    Validate Loan Repricing Effective Date    ${Effective_Date}
    
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Send to Approval
    
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Approval    Loan Repricing    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Approval
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricing-Approved
    
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Send to Rate Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Rate Approval    Loan Repricing    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Rate Approval
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricing-RateApproved
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Release
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricing-Released
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
