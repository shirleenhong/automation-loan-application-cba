*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate Agency DE Extract from Agency Host Bank DE Report
    [Documentation]    This test case is used to validate Agency DE Extract tab in the DE report if the following fields are available:
    ...    Fields to Validate in Agency DE Extract Tab: Customer Short Name, Host Bank Share Amount, Cashflow Currency, Cashflow Direction, Processing Date
    ...    Effective Date, DDA Transaction Description, Cashflow Description, Deal Tracking Number, Transaction Code, Expense Code, Cashflow ID, Processing Area Code
    ...    Cashflow Status, Payment Method, Cashflow Create Date/Time
    ...    @author: fluberio    19NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Multiple Value if Existing in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_DE_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]
    
Write Details for Agency Host Bank DE Extract Report
    [Documentation]    This keyword is used to write needed details in Agency Host Bank DE Report sheet.
    ...    @author: fluberio    04DEC2020    - initial create
    ...    @update: fluberio    09DEC2020    - updated for AHBDE sheet
    [Arguments]    ${ExcelPath}

    Delete File If Exist    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_PAYMENT_REPORTFILE}.xlsx
    Copy File    &{ExcelPath}[Report_Path]${CBA_PAYMENT_REPORTFILE}.xlsx    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_PAYMENT_REPORTFILE}.xlsx
    Write Data To Excel    DNR    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_PAYMENT_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    AHBDE    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_PAYMENT_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True
    
Write Filter Details for Agency Host Bank DE Extract Report in DNR Data Set
    [Documentation]    This keyword is used to write needed filter details for Agency Host Bank DE Report sheet in DNR Date Set.
    ...    @author: fluberio    07DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    ${Effective_Date}    Read Data From Excel    &{ExcelPath}[LIQ_Sheet_Name]    Effective_Date    ${rowid}    ${DNR_DATASET}
    ${From_Date}    Get Specific Detail in Given Date    ${Effective_Date}    D    -
    ${From_Month}    Get Specific Detail in Given Date    ${Effective_Date}    M    -
    ${From_Year}    Get Specific Detail in Given Date    ${Effective_Date}    Y    -    
    Write Data To Excel    DNR    From_Date    ${TestCase_Name}    ${From_Date}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    DNR    From_Month    ${TestCase_Name}    ${From_Month}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    DNR    From_Year    ${TestCase_Name}    ${From_Year}    ${DNR_DATASET}    bTestCaseColumn=True
    
Validate that the Agency Host Bank DE Report Net Amount is Correct
    [Documentation]    This keyword is used to verify net amount is correct when completing a loan split with interest collection
    ...    @author: fluberio    04DEC2020    - initial create
    ...    @update: clanding    09DEC2020    - updated index to be dataset driven
    [Arguments]    ${ExcelPath}
    
    ### Get Expected Details ###
    ${HostBank_Share}    Read Data From Excel    SC2_LoanSplit    HostBank_Share    ${rowid}    ${DNR_DATASET}
    ${Customer_Name}    Read Data From Excel    SC2_LoanSplit    Borrower_Name    ${rowid}    ${DNR_DATASET}
    ${Facility_Name}    Read Data From Excel    SC2_LoanDrawdown    Facility_Name    ${rowid}    ${DNR_DATASET}
   
    ### Get Actual Details in the Report
    ${HostBank_Share_Amount}    Read Data From Excel    Agency_DE Extract    Host Bank Share Amount    Interest${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description    iHeaderIndex=&{ExcelPath}[Column_Row_Index]
    ${Cashflow_Direction}    Read Data From Excel    Agency_DE Extract    Cashflow Direction    &{ExcelPath}[DDA_Transaction_Description]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description    iHeaderIndex=&{ExcelPath}[Column_Row_Index]
    ${Customer_Name_Report}    Read Data From Excel    Agency_DE Extract    Customer Short Name    &{ExcelPath}[DDA_Transaction_Description]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description    iHeaderIndex=&{ExcelPath}[Column_Row_Index]
        
    Compare Two Strings    ${HostBank_Share}    ${HostBank_Share_Amount}
    Compare Two Strings    &{ExcelPath}[Cashflow_Direction]    ${Cashflow_Direction.strip()}
    Compare Two Strings    ${Customer_Name}    ${Customer_Name_Report.strip()}
        
Validate that the Agency Host Bank DE Report DDA Transaction Desc is Correct 
    [Documentation]    This keyword is used to verify DDA Transaction Description is correct when completing a loan drawdown rollover with comprehensive repricing
    ...    @author: makcamps    09DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ### Get Expected Details ###
    ${HostBank_Share}    Read Data From Excel    AHBDE    HostBankCashNet    ${rowid}    ${DNR_DATASET}
    ${Customer_Name}    Read Data From Excel    AHBDE    Customer_Name    ${rowid}    ${DNR_DATASET}
    ${Cashflow_Direction}    Read Data From Excel    AHBDE    Cashflow_Direction    ${rowid}    ${DNR_DATASET}
    ${DDATransaction_Desc}    Read Data From Excel    AHBDE    DDA_Transaction_Description    ${rowid}    ${DNR_DATASET}
    ${Transaction_Code}    Read Data From Excel    AHBDE    Transaction_Code    ${rowid}    ${DNR_DATASET}
   
    ### Get Actual Details in the Report
    ${HostBank_Share_Extract}    Read Data From Excel    Agency_DE Extract    Host Bank Share Amount    &{ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID    iHeaderIndex=&{ExcelPath}[Column_Row_Index]
    ${Customer_Name_Extract}    Read Data From Excel    Agency_DE Extract    Customer Short Name    &{ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID    iHeaderIndex=&{ExcelPath}[Column_Row_Index]
    ${Cashflow_Direction_Extract}    Read Data From Excel    Agency_DE Extract    Cashflow Direction    &{ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID    iHeaderIndex=&{ExcelPath}[Column_Row_Index]
    ${DDATransaction_Desc_Extract}    Read Data From Excel    Agency_DE Extract    DDA Transaction Description    &{ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID    iHeaderIndex=&{ExcelPath}[Column_Row_Index]
    ${Transaction_Code_Extract}    Read Data From Excel    Agency_DE Extract    Transaction Code    &{ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID    iHeaderIndex=&{ExcelPath}[Column_Row_Index]
    
    Compare Two Strings    ${HostBank_Share}    ${HostBank_Share_Extract}
    Compare Two Strings    ${Customer_Name}    ${Customer_Name_Extract.strip()}
    Compare Two Strings    ${Cashflow_Direction}    ${Cashflow_Direction_Extract.strip()}
    Compare Two Strings    ${Transaction_Code}    ${Transaction_Code_Extract}
    Compare Two Strings    ${DDATransaction_Desc}    ${DDATransaction_Desc_Extract.strip()}
    
Write Cashflow ID for Agency DE Report
    [Documentation]    This will serve as a High Level keyword for reopening of the loans's cashflow
    ...    and getting the cashflow ID to be written in the AHBDE Report Validation sheet.
    ...    @author: makcamps    09DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    ###Login to Inputter and Open the Loan After Released###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    Launch Loan Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[New_Loan_Alias]
    
    ${CashflowID}   Get Cashflow Details from Released Loan Repricing    &{ExcelPath}[Borrower_ShortName]
     
    ###Write Cashflow ID for Report Validation Sheet###
    Write Data To Excel    AHBDE    Cashflow_ID    ${rowid}    ${CashflowID}    ${DNR_DATASET}
    
    Close All Windows on LIQ
    
Validation of Report and Dataset Value for Agency Host Bank DE
    [Documentation]    This keyword is used for reading the downloaded Agency Host Bank DE Report 
    ...    and validating the value Processing_Date from the dataset. AHBDE
    ...    @author: songchan    - Initial Create
    [Arguments]    ${ExcelPath}
        
    Log    ${ExcelPath}
    
    ### Get Expected Details
    ${HostBank_Share}    Read Data From Excel    SC2_PaymentFees    Host_BankShare    ${rowid}    ${DNR_DATASET}
    ${Customer_Name}    Read Data From Excel    SC2_PaymentFees    Borrower_ShortName    ${rowid}    ${DNR_DATASET}
    ${DDA_Transaction_Description}    Read Data From Excel    SC2_PaymentFees    WIP_OutstandingType    ${rowid}    ${DNR_DATASET}
    
    ### Get Actual Details in the Report
    ${Actual_HostBankShare}    Read Data From Excel    Agency_DE Extract    Host Bank Share Amount    &{ExcelPath}[DDA_Transaction_Description]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]${CBA_DE_REPORTFILE}.xlsx    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description    iHeaderIndex=2
    ${Actual_CustomerName}    Read Data From Excel    Agency_DE Extract    Customer Short Name    &{ExcelPath}[DDA_Transaction_Description]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]${CBA_DE_REPORTFILE}.xlsx    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description    iHeaderIndex=2
    ${Actual_DDA_Transaction_Description}    Read Data From Excel    Agency_DE Extract    DDA Transaction Description    &{ExcelPath}[DDA_Transaction_Description]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]${CBA_DE_REPORTFILE}.xlsx    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description    iHeaderIndex=2  
    ${Actual_Transaction_Code}    Read Data From Excel    Agency_DE Extract    Transaction Code    &{ExcelPath}[DDA_Transaction_Description]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}   &{ExcelPath}[Report_Path]${CBA_DE_REPORTFILE}.xlsx    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description    iHeaderIndex=2
   
    ### Validation of Expected and Actual
    Compare Two Strings    ${HostBank_Share}    ${Actual_HostBankShare}
    Compare Two Strings    ${Customer_Name}    ${Actual_CustomerName}
    Compare Two Strings    ${DDA_Transaction_Description}    ${Actual_DDA_Transaction_Description}
    Compare Two Strings    ${ExcelPath}[Transaction_Code]    ${Actual_Transaction_Code}

Write Filter Details for Agency Host Bank DE Report in DNR Data Set
    [Documentation]    This keyword is used to write needed filter details for Agency Host Bank DE Report sheet in DNR Date Set.
    ...    @author: songchan    10DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    ${ProcessingDate}    Read Data From Excel    &{ExcelPath}[LIQ_Sheet_Name]    FeePayment_EffectiveDate    ${rowid}    ${DNR_DATASET}

    ${From_Date}    Get Specific Detail in Given Date    ${ProcessingDate}    D    -
    ${From_Month}    Get Specific Detail in Given Date    ${ProcessingDate}    M    -
    ${From_Year}    Get Specific Detail in Given Date    ${ProcessingDate}    Y    -    
    Write Data To Excel    DNR    From_Date    ${TestCase_Name}    ${From_Date}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    DNR    From_Month    ${TestCase_Name}    ${From_Month}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    DNR    From_Year    ${TestCase_Name}    ${From_Year}    ${DNR_DATASET}    bTestCaseColumn=True
    
Validation of Report and Dataset Value for Agency Host Bank DE - AHBDE_004
    [Documentation]    This keyword is used for reading the downloaded AHBDE Report
    ...    and validating the value from the dataset.
    ...    @author: songchan    14DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ### Get Expected Details
    ${HostBank_Share}    Read Data From Excel    SC2_PaymentFees    Host_BankShare    ${rowid}    ${DNR_DATASET}
    ${Customer_Name}    Read Data From Excel    SC2_AdminFeePayment    Borrower_ShortName    ${rowid}    ${DNR_DATASET}
    ${DDA_Transaction_Description}    Read Data From Excel    SC2_AdminFeePayment    AdminFeePayment_Comment    ${rowid}    ${DNR_DATASET}
    ${Effective_Date}    Read Data From Excel    SC2_AdminFeePayment    FeePayment_EffectiveDate    ${rowid}    ${DNR_DATASET}
    
    ### Get Actual Details in the Report
    ${Actual_HostBankShare}    Read Data From Excel    Agency_DE Extract    Host Bank Share Amount    &{ExcelPath}[DDA_Transaction_Description]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]${CBA_DE_REPORTFILE}.xlsx    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description    iHeaderIndex=2
    ${Actual_CustomerName}    Read Data From Excel    Agency_DE Extract    Customer Short Name    &{ExcelPath}[DDA_Transaction_Description]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]${CBA_DE_REPORTFILE}.xlsx    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description    iHeaderIndex=2
    ${Actual_DDA_Transaction_Description}    Read Data From Excel    Agency_DE Extract    DDA Transaction Description    &{ExcelPath}[DDA_Transaction_Description]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]${CBA_DE_REPORTFILE}.xlsx    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description    iHeaderIndex=2  
    ${Actual_Cashflow_Currency}    Read Data From Excel    Agency_DE Extract    Cashflow Currency    &{ExcelPath}[DDA_Transaction_Description]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}   &{ExcelPath}[Report_Path]${CBA_DE_REPORTFILE}.xlsx    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description    iHeaderIndex=2
    ${Actual_Cashflow_Direction}    Read Data From Excel    Agency_DE Extract    Cashflow Direction    &{ExcelPath}[DDA_Transaction_Description]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}   &{ExcelPath}[Report_Path]${CBA_DE_REPORTFILE}.xlsx    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description    iHeaderIndex=2
    ${Actual_Processing_Date}    Read Data From Excel    Agency_DE Extract    Processing Date    &{ExcelPath}[DDA_Transaction_Description]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}   &{ExcelPath}[Report_Path]${CBA_DE_REPORTFILE}.xlsx    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description    iHeaderIndex=2
    ${Actual_Effective_Date}    Read Data From Excel    Agency_DE Extract    Effective Date    &{ExcelPath}[DDA_Transaction_Description]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}   &{ExcelPath}[Report_Path]${CBA_DE_REPORTFILE}.xlsx    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description    iHeaderIndex=2
    
    ### Validation of Expected and Actual
    Compare Two Strings    ${Customer_Name}    ${Actual_CustomerName}
    Compare Two Strings    ${HostBank_Share}    ${Actual_HostBankShare}
    Compare Two Strings    ${ExcelPath}[Cashflow_Currency]    ${Actual_Cashflow_Currency}
    Compare Two Strings    ${ExcelPath}[Cashflow_Direction]    ${Actual_Cashflow_Direction}
    Compare Two Strings    ${ExcelPath}[Processing_Date]    ${Actual_Processing_Date}
    Compare Two Strings    ${Effective_Date}    ${Actual_Effective_Date}
    Compare Two Strings    ${DDA_Transaction_Description}    ${Actual_DDA_Transaction_Description}