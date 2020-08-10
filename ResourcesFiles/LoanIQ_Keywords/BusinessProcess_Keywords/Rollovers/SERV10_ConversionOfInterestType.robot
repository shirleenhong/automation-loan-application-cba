*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Create Repricing for Conversion of Interest Type
    [Documentation]    High-level keyword used to Create Repricing for Conversion of Interest Type.
    ...                @author: bernchua    26AUG2019    Inital create
    ...                @author: bernchua    10SEP2019    Added setting up of Repayment Schedule during Repricing
    ...                @author: bernchua    18SEP2019    Updated keyword name
    ...                @update: sahalder    22JUN2020    Modified keyword as per the new framework, Changed the Keyword name as well as per BNS 
    [Arguments]    ${ExcelPath}
    
    Close All Windows on LIQ
    Refresh Tables in LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    Search for Existing Outstanding    Loan    &{ExcelPath}[Facility_Name]
    Select Loan to Reprice    &{ExcelPath}[Loan_Alias]
    Select Repricing Type    Comprehensive Repricing
    Select Loan Repricing for Deal    &{ExcelPath}[Loan_Alias]
    
    Select Existing Outstandings for Loan Repricing    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_Alias]
    Cick Add in Loan Repricing Notebook
    Set Repricing Detail Add Options    Rollover/Conversion to New    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower1_ShortName]
    
    ${Effective_Date}    ${Loan_Alias}    Set RolloverConversion Notebook General Details    &{ExcelPath}[Rollover_RequestedAmount]    &{ExcelPath}[Rollover_RepricingFrequency]
    Write Data To Excel    SERV10_ConversionOfInterestType    New_LoanAlias    &{ExcelPath}[rowid]    ${Loan_Alias}    ${ExcelPath}
    Write Data To Excel    SERV10_ConversionOfInterestType    Loan_Alias    &{ExcelPath}[rowid]    ${Loan_Alias}    ${ExcelPath}
    Save Notebook Transaction    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_Save_Menu}
    Set RolloverConversion Notebook Rates    &{ExcelPath}[Rollover_BaseRate]
    ${AllInRate}    Add Borrower Base Rate and Facility Spread    &{ExcelPath}[Rollover_BaseRate]    &{ExcelPath}[Interest_SpreadValue]
    ${AllInRate}    Set Variable    ${AllInRate}%
    Validate String Data In LIQ Object    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_AllInRate_Text}    ${AllInRate}
    
    ### Setting up of Repayment Schedule
    Navigate from Rollover to Repayment Schedule
    Select Reschedule Menu in Repayment Schedule
    Select Type of Schedule    &{ExcelPath}[RepaymentSchedule_Type]
    
    Add Item in Flexible Schedule Window
    Tick Flexible Schedule Add Item Pay Thru Maturity
    Set Flexible Schedule Add Item Type    &{ExcelPath}[FlexSchedule_Type]
    Tick Flexible Schedule Add Item PI Amount    P&&I Amount
    Enter Flexible Schedule Add Item PI Amount    &{ExcelPath}[FlexSchedule_PrincipalAmount]
    Click OK in Add Items for Flexible Schedule
    Click OK in Flexible Schedule Window
    Save and Exit Repayment Schedule For Loan
    
    ### End of Repayment Schedule setup script 
    Close RolloverConversion Notebook
    ${New_Outstanding}    Set Variable    &{ExcelPath}[Pricing_Option] (${Loan_Alias})
    Validate Loan Repricing New Outstanding Amount    ${New_Outstanding}    &{ExcelPath}[Rollover_RequestedAmount]
    Validate Loan Repricing Effective Date    ${Effective_Date}
    
    Navigate to Rollover Conversion Notebook Workflow    Create Cashflows    Cashflow_Creation        
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RemittanceDescription]    &{ExcelPath}[Borrower1_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender1_RemittanceDescription]    &{ExcelPath}[Lender1_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    
    Navigate to GL Entries
    Close GL Entries and Cashflow Window
    
    Navigate to Rollover Conversion Notebook Workflow    Send to Approval    Supervisor_Approval
    
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Approval    Loan Repricing    &{ExcelPath}[Deal_Name]
    Navigate to Rollover Conversion Notebook Workflow    Approval    LoanRepricing-Approved
        
    Navigate to Rollover Conversion Notebook Workflow    Send to Rate Approval    Rate_Approval
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Rate Approval    Loan Repricing    &{ExcelPath}[Deal_Name]
    Navigate to Rollover Conversion Notebook Workflow    Rate Approval    LoanRepricing-RateApproved
    Navigate to Rollover Conversion Notebook Workflow    Release    LoanRepricing-Released
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}