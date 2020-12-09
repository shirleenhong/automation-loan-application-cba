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
    ...    @update: shirhong    09DEC2020    - Updated writing and assertion of values
    [Arguments]    ${ExcelPath}
        
    Log    ${ExcelPath}
    
    ### Read and Write Values to be Asserted from Loan Drawdown Dataset ###
    ${Processing_Date}    Read Data From Excel    &{ExcelPath}[LIQ_Sheet_Name]    Loan_ProcessingDate    ${rowid}    ${DNR_DATASET}
    Write Data To Excel    AHBCO    Processing_Date    ${TestCase_Name}    ${Processing_Date}    ${DNR_DATASET}
    ${Dataset_Date_Value}    Get Date Value from Date Added or Amended Column    &{ExcelPath}[Processing_Date]
    
    ### Extract the Data from Downloaded Excel File ###
    ${ActualProcessingDate}    Read Data From Excel    Agency_CashOut    Processing Date    ${ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]${CBA_CASHOUT_REPORTFILE}.xlsx    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID    iHeaderIndex=2
    ${Report_Date_Value}    Get Date Value from Date Added or Amended Column    ${ActualProcessingDate}    %d-%b-%Y
    
    ### Verify the Data from Dataset File ###
    Compare Two Strings    ${Dataset_Date_Value}    ${Report_Date_Value.strip()}
    
Validation of Report and Dataset Value for Agency Host Bank Cash Out for Effective Date
    [Documentation]    This keyword is used for reading the downloaded Agency Host Bank Cashout Report 
    ...    and validating the value Effective_Date from the dataset. AHBCO_0003
    ...    @author: shirhong    20NOV2020    - Initial create
    ...    @update: shirhong    09DEC2020    - Updated writing and assertion of values
    [Arguments]    ${ExcelPath}
        
    Log    ${ExcelPath}
    
    ### Read and Write Values to be Asserted from Loan Drawdown Dataset ###
    ${Effective_Date}    Read Data From Excel    &{ExcelPath}[LIQ_Sheet_Name]    Loan_EffectiveDate    ${rowid}    ${DNR_DATASET}
    Write Data To Excel    AHBCO    Effective_Date    ${TestCase_Name}    ${Effective_Date}    ${DNR_DATASET}
    ${Dataset_Date_Value}    Get Date Value from Date Added or Amended Column    &{ExcelPath}[Effective_Date]
    
    ### Extract the Data from Downloaded Excel File ###
    ${ActualEffectiveDate}    Read Data From Excel    Agency_CashOut    Effective Date    ${ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]${CBA_CASHOUT_REPORTFILE}.xlsx    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID    iHeaderIndex=2
    ${Report_Date_Value}    Get Date Value from Date Added or Amended Column    ${ActualEffectiveDate}    %d-%b-%Y
    
    ### Verify the Data from Dataset File ###
    Compare Two Strings    ${Dataset_Date_Value}    ${Report_Date_Value.strip()}

Write Cashflow ID for Agency Cashout Report
    [Documentation]    This will serve as a High Level keyword for reopening of the loans's cashflow
    ...    and getting the cashflow ID to be written in the AHBCO Report Validation sheet.
    ...    @author: shirhong    04DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    ###Login to Inputter and Open the Loan After Released###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    Launch Loan Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    
    ${CashflowID}   Get Cashflow Details from Released Initial Loan Drawdown    &{ExcelPath}[Borrower_ShortName]
     
    ###Write Cashflow ID to AHBCO_001 and AHBCO_002 Report Validation Sheet###
    Write Data To Excel    AHBCO    Cashflow_ID    1    ${CashflowID}    ${DNR_DATASET}
    Write Data To Excel    AHBCO    Cashflow_ID    2    ${CashflowID}    ${DNR_DATASET}
    
    ###Write Cashflow ID to Specific Report Validation Sheet###
    Write Data To Excel    AHBCO    Cashflow_ID    &{ExcelPath}[RowId_ToWriteCashflowId_ForReportValidation]    ${CashflowID}    ${DNR_DATASET}
    Close All Windows on LIQ   
    
Write Filter Details for Agency Host Bank Cashout Report in DNR Data Set
    [Documentation]    This keyword is used to write needed filter details for Agency Host Bank Cashout Report sheet in DNR Date Set.
    ...    @author: shirhong    07DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    ${Effective_Date}    Read Data From Excel    &{ExcelPath}[LIQ_Sheet_Name]    Loan_ProcessingDate    ${rowid}    ${DNR_DATASET}
    ${From_Date}    Get Specific Detail in Given Date    ${Effective_Date}    D    -
    ${From_Month}    Get Specific Detail in Given Date    ${Effective_Date}    M    -
    ${From_Year}    Get Specific Detail in Given Date    ${Effective_Date}    Y    -    
    Write Data To Excel    DNR    From_Date    ${TestCase_Name}    ${From_Date}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    DNR    From_Month    ${TestCase_Name}    ${From_Month}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    DNR    From_Year    ${TestCase_Name}    ${From_Year}    ${DNR_DATASET}    bTestCaseColumn=True
    

