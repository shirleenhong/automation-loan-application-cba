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
    [Arguments]    ${ExcelPath}

    Delete File If Exist    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_CALENDAR_REPORTFILE}.xlsx
    # Copy File    &{ExcelPath}[Report_Path]${CBA_CALENDAR_REPORTFILE}.xlsx    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_CALENDAR_REPORTFILE}.xlsx
    # Write Data To Excel    DNR    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_CALENDAR_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True
    # Write Data To Excel    CALND    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_CALENDAR_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True
    
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
    [Arguments]    ${ExcelPath}
    
    ### Get Expected Details ###
    ${HostBank_Share}    Read Data From Excel    SC2_LoanSplit    HostBank_Share    ${rowid}    ${DNR_DATASET}
    ${Customer_Name}    Read Data From Excel    SC2_LoanSplit    Borrower_Name    ${rowid}    ${DNR_DATASET}
    ${Facility_Name}    Read Data From Excel    SC2_LoanDrawdown    Facility_Name    ${rowid}    ${DNR_DATASET}
   
    ### Get Actual Details in the Report
    ${HostBank_Share_Amount}    Read Data From Excel    Agency_DE Extract    Host Bank Share Amount    Interest${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description    iHeaderIndex=2
    ${Cashflow_Direction}    Read Data From Excel    Agency_DE Extract    Cashflow Direction    &{ExcelPath}[DDA_Transaction_Description]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description    iHeaderIndex=2
    ${Customer_Name_Report}    Read Data From Excel    Agency_DE Extract    Customer Short Name    &{ExcelPath}[DDA_Transaction_Description]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description    iHeaderIndex=2
        
    Compare Two Strings    ${HostBank_Share}    ${HostBank_Share_Amount}
    Compare Two Strings    &{ExcelPath}[Cashflow_Direction]    ${Cashflow_Direction.strip()}
    Compare Two Strings    ${Customer_Name}    ${Customer_Name_Report.strip()}

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