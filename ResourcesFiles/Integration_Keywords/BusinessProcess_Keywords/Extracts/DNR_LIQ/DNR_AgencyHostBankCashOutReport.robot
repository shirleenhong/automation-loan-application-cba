*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validation of Report and Dataset Value for Agency Host Bank Cash Out for Host Bank Share Amount
    [Documentation]    This keyword is used for reading the downloaded Agency Host Bank Cashout Report 
    ...    and validating the value Host_Bank_Share_Amount from the dataset.
    ...    @author: shirhong    17NOV2020    - Initial create
    [Arguments]    ${ExcelPath}
    
    Log    ${ExcelPath}

    ### Extract the Data from Downloaded Excel File ###   
    ${ActualHostBankShareAmount}    Read Data From Excel    Agency_CashOut    Host Bank Share Amount    ${ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]${CBA_CASHOUT_REPORTFILE}.xlsx    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID    iHeaderIndex=2

    ### Verify the Data from Dataset File ###
    Compare Two Strings    &{ExcelPath}[Host_Bank_Share_Amount]    ${ActualHostBankShareAmount}
    
Validation of Report and Dataset Value for Agency Host Bank Cash Out for Cashflow Status
    [Documentation]    This keyword is used for reading the downloaded Agency Host Bank Cashout Report 
    ...    and validating the value Cashflow_Status from the dataset.
    ...    @author: shirhong    19NOV2020    - Initial create
    [Arguments]    ${ExcelPath}
        
    Log    ${ExcelPath}
    
    ### Extract the Data from Downloaded Excel File ###
    ${ActualCashflowStatus}    Read Data From Excel    Agency_CashOut    Cashflow Status    ${ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]${CBA_CASHOUT_REPORTFILE}.xlsx    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID    iHeaderIndex=2

    ### Verify the Data from Dataset File ###
    Compare Two Strings    &{ExcelPath}[Cashflow_Status]    ${ActualCashflowStatus}
    
Validation of Report and Dataset Value for Agency Host Bank Cash Out for Processing Date
    [Documentation]    This keyword is used for reading the downloaded Agency Host Bank Cashout Report 
    ...    and validating the value Processing_Date from the dataset. AHBCO_0003
    ...    @author: shirhong    20NOV2020    - Initial create
    [Arguments]    ${ExcelPath}
        
    Log    ${ExcelPath}
    
    ### Extract the Data from Downloaded Excel File ###
    ${ActualProcessingDate}    Read Data From Excel    Agency_CashOut    Processing Date    ${ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]${CBA_CASHOUT_REPORTFILE}.xlsx    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID    iHeaderIndex=2

    ### Verify the Data from Dataset File ###
    Compare Two Strings    &{ExcelPath}[Processing_Date]    ${ActualProcessingDate}
    
Validation of Report and Dataset Value for Agency Host Bank Cash Out for Effective Date
    [Documentation]    This keyword is used for reading the downloaded Agency Host Bank Cashout Report 
    ...    and validating the value Effective_Date from the dataset. AHBCO_0003
    ...    @author: shirhong    20NOV2020    - Initial create
    [Arguments]    ${ExcelPath}
        
    Log    ${ExcelPath}
    
    ### Extract the Data from Downloaded Excel File ###
    ${ActualEffectiveDate}    Read Data From Excel    Agency_CashOut    Effective Date    ${ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]${CBA_CASHOUT_REPORTFILE}.xlsx    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID    iHeaderIndex=2

    ### Verify the Data from Dataset File ###
    Compare Two Strings    &{ExcelPath}[Effective_Date]    ${ActualEffectiveDate}
    
    
