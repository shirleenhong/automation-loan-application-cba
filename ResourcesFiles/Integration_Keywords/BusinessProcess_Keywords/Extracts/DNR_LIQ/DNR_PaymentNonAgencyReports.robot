*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Validate Cash Out Report for Payment Non Agency is Generated for All Transactions in Approval Status
    [Documentation]    This keyword is used to validate that the Cash Out Report is generated for all transactions in Approval status.
    ...    @author: fluberio    10DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ### Get Actual Details in the Report
    ${Cashflow_Amount_Report}    Read Data From Excel    Page1    Cashflow Amount    &{ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID
    ${Transaction_Status_Report}    Read Data From Excel    Page1    Cashflow Status    &{ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID
    ${ProcessingAreaCode_Report}    Read Data From Excel    Page1    Processing Area Code    &{ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID
    ${ProcessingDate_Report}    Read Data From Excel    Page1    Processing Date    &{ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID
    ${Cashflow_Direction}    Read Data From Excel    Page1    Cashflow Direction    &{ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID
    
    ${Cashflow_Amount}    Convert to Number    &{ExcelPath}[Cashflow_Amount]
    ${Cashflow_Amount_Report}    Convert to Number    ${Cashflow_Amount_Report}
    Compare Two Strings    ${Cashflow_Amount}    ${Cashflow_Amount_Report}
    Compare Two Strings    &{ExcelPath}[Transaction_Status]    ${Transaction_Status_Report.strip()}
    Compare Two Strings    &{ExcelPath}[Processing_Area_Code]    ${ProcessingAreaCode_Report.strip()}
    Compare Two Strings    &{ExcelPath}[Cashflow_Direction]    ${Cashflow_Direction.strip()}
    Compare Two Strings    ${NONE}   ${ProcessingDate_Report}
    
Validate Cash Out Report for Payment Non Agency is Generated for All Transactions in Released Status
    [Documentation]    This keyword is used to validate that the Cash Out Report is generated for all transactions in Release status.
    ...    @author: fluberio    11DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ### Get Actual Details in the Report
    ${Cashflow_Amount_Report}    Read Data From Excel    Page1    Cashflow Amount    &{ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID
    ${Transaction_Status_Report}    Read Data From Excel    Page1    Cashflow Status    &{ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID
    ${ProcessingAreaCode_Report}    Read Data From Excel    Page1    Processing Area Code    &{ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID
    ${ProcessingDate_Report}    Read Data From Excel    Page1    Processing Date    &{ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID
    ${Cashflow_Direction}    Read Data From Excel    Page1    Cashflow Direction    &{ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID
    
    ${Cashflow_Amount}    Convert to Number    &{ExcelPath}[Cashflow_Amount]
    ${Cashflow_Amount_Report}    Convert to Number    ${Cashflow_Amount_Report}
    Compare Two Strings    ${Cashflow_Amount}    ${Cashflow_Amount_Report}
    Compare Two Strings    &{ExcelPath}[Transaction_Status]    ${Transaction_Status_Report.strip()}
    Compare Two Strings    &{ExcelPath}[Processing_Area_Code]    ${ProcessingAreaCode_Report.strip()}
    Compare Two Strings    &{ExcelPath}[Cashflow_Direction]    ${Cashflow_Direction.strip()}
    
    ${Report_Date_Value}    Get Date Value from Date Added or Amended Column    ${ProcessingDate_Report}    %d-%b-%Y
    ${Dataset_Date_Value}    Get Date Value from Date Added or Amended Column    &{ExcelPath}[Transaction_Date]
    Compare Two Strings    ${Dataset_Date_Value}    ${Report_Date_Value.strip()}
    
    
Write Details for Payment Non Agency Reports
    [Documentation]    This keyword is used to write needed details in Payment Non Agency sheet.
    ...    @author: fluberio    10DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    Delete File If Exist    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_PAYMENT_REPORTFILE}.xlsx
    Copy File    &{ExcelPath}[Report_Path]${CBA_PAYMENT_REPORTFILE}.xlsx    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_PAYMENT_REPORTFILE}.xlsx
    Write Data To Excel    DNR    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_PAYMENT_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    PAYNA    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_PAYMENT_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True
    
    ${Cashflow_Amount}    Read Data From Excel    SC1_LoanDrawdown    Cashflow_Amount    ${rowid}    ${DNR_DATASET}
    ${Transaction_Status}    Read Data From Excel    SC1_LoanDrawdown    Transaction_Status    ${rowid}    ${DNR_DATASET}
    ${ProcessingAreaCode}    Read Data From Excel    SC1_LoanDrawdown    Processing_Area_Code    ${rowid}    ${DNR_DATASET}
    ${Cashflow_Id}    Read Data From Excel    SC1_LoanDrawdown    Cashflow_ID    ${rowid}    ${DNR_DATASET}
    ${ProcessingDate}    Read Data From Excel    SC1_LoanDrawdown    Transaction_Date    ${rowid}    ${DNR_DATASET}
    ${Deal_TrackingNumber}    Read Data From Excel    SC1_LoanDrawdown    Deal_TrackingNumber    ${rowid}    ${DNR_DATASET}
    
    Write Data To Excel    PAYNA    Transaction_Date    ${TestCase_Name}    ${ProcessingDate}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    PAYNA    Deal_TrackingNumber    ${TestCase_Name}    ${Deal_TrackingNumber}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    PAYNA    Cashflow_Amount    ${TestCase_Name}    ${Cashflow_Amount}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    PAYNA    Transaction_Status    ${TestCase_Name}    ${Transaction_Status}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    PAYNA    Processing_Area_Code    ${TestCase_Name}    ${ProcessingAreaCode}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    PAYNA    Cashflow_ID    ${TestCase_Name}    ${Cashflow_Id}    ${DNR_DATASET}    bTestCaseColumn=True
         
Write Filter Details for Payment Non Agency Reports in DNR Data Set
    [Documentation]    This keyword is used to write needed filter details for Payment Non Agency Report sheet in DNR Date Set.
    ...    @author: fluberio    11DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    ${Effective_Date}    Read Data From Excel    &{ExcelPath}[LIQ_Sheet_Name]    Transaction_Date    ${rowid}    ${DNR_DATASET}
    ${From_Date}    Get Specific Detail in Given Date    ${Effective_Date}    D    -
    ${From_Month}    Get Specific Detail in Given Date    ${Effective_Date}    M    -
    ${From_Year}    Get Specific Detail in Given Date    ${Effective_Date}    Y    -    
    Write Data To Excel    DNR    From_Date    ${TestCase_Name}    ${From_Date}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    DNR    From_Month    ${TestCase_Name}    ${From_Month}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    DNR    From_Year    ${TestCase_Name}    ${From_Year}    ${DNR_DATASET}    bTestCaseColumn=True
    
Write Cashflow ID for Payment Non Agency Report
    [Documentation]    This will serve as a High Level keyword for reopening of the loans's cashflow
    ...    and getting the cashflow ID to be written in the AHBDE Report Validation sheet.
    ...    @author: fluberio    11DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    ###Login to Inputter and Open the Loan After Released###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    Launch Loan Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    mx LoanIQ click element if present    ${LIQ_Alerts_OK_Button}
    ${CashflowID}   Get Cashflow Details from Released Initial Loan Drawdown    &{ExcelPath}[Borrower1_ShortName]
     
    ###Write Cashflow ID for Report Validation Sheet###
    Write Data To Excel    SC1_LoanDrawdown    Cashflow_ID    ${rowid}    ${CashflowID}    ${DNR_DATASET}
    
    Close All Windows on LIQ