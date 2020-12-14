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
    ...    @update: fluberio    14DEC2020    - Added new Writing
    [Arguments]    ${ExcelPath}

    Delete File If Exist    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_PAYMENT_REPORTFILE}.xlsx
    Copy File    &{ExcelPath}[Report_Path]${CBA_PAYMENT_REPORTFILE}.xlsx    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_PAYMENT_REPORTFILE}.xlsx
    Write Data To Excel    DNR    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_PAYMENT_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    PAYNA    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_PAYMENT_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True
    
    ${Cashflow_Amount}    Read Data From Excel    &{ExcelPath}[LIQ_Sheet_Name]    Cashflow_Amount    ${rowid}    ${DNR_DATASET}
    ${Transaction_Status}    Read Data From Excel    &{ExcelPath}[LIQ_Sheet_Name]    Transaction_Status    ${rowid}    ${DNR_DATASET}
    ${ProcessingAreaCode}    Read Data From Excel    &{ExcelPath}[LIQ_Sheet_Name]    Processing_Area_Code    ${rowid}    ${DNR_DATASET}
    ${Cashflow_Id}    Read Data From Excel    &{ExcelPath}[LIQ_Sheet_Name]    Cashflow_ID    ${rowid}    ${DNR_DATASET}
    ${ProcessingDate}    Read Data From Excel    &{ExcelPath}[LIQ_Sheet_Name]    Transaction_Date    ${rowid}    ${DNR_DATASET}
    ${Cashflow_Amount_Principal}    Read Data From Excel    &{ExcelPath}[LIQ_Sheet_Name]    Cashflow_Amount_Principal    ${rowid}    ${DNR_DATASET}
    ${Cashflow_Amount_Interest}    Read Data From Excel    &{ExcelPath}[LIQ_Sheet_Name]    Cashflow_Amount_Interest    ${rowid}    ${DNR_DATASET}
    
    Write Data To Excel    PAYNA    Transaction_Date    ${TestCase_Name}    ${ProcessingDate}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    PAYNA    Cashflow_Amount    ${TestCase_Name}    ${Cashflow_Amount}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    PAYNA    Transaction_Status    ${TestCase_Name}    ${Transaction_Status}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    PAYNA    Processing_Area_Code    ${TestCase_Name}    ${ProcessingAreaCode}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    PAYNA    Cashflow_ID    ${TestCase_Name}    ${Cashflow_Id}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    PAYNA    Cashflow_Amount_Principal    ${TestCase_Name}    ${Cashflow_Amount_Principal}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    PAYNA    Cashflow_Amount_Interest    ${TestCase_Name}    ${Cashflow_Amount_Interest}    ${DNR_DATASET}    bTestCaseColumn=True
         
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
    
Write Cashflow ID of Initial Loan Drawdown for Payment Non Agency Report
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
    
Write Cashflow ID of Loan Repricing for Payment Non Agency Report
    [Documentation]    This will serve as a High Level keyword for reopening of the loans's cashflow
    ...    and getting the cashflow ID to be written in the AHBDE Report Validation sheet.
    ...    @author: fluberio    14DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    ###Login to Inputter and Open the Loan After Released###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    mx LoanIQ click element if present    ${LIQ_Alerts_OK_Button}
    mx LoanIQ activate window    ${LIQ_ExistingLoans_Window} 
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingSelect_ExistingLoans
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_ExistingLoans_JavaTree}    &{ExcelPath}[New_Loan_Alias]%d
    mx LoanIQ click element if present    ${LIQ_Alerts_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Loan_InquiryMode_Button}
    
    ${CashflowID}   Get Cashflow Details from Released Loan Repricing    &{ExcelPath}[Borrower1_ShortName]
     
    ###Write Cashflow ID for Report Validation Sheet###
    Write Data To Excel    SC1_ComprehensiveRepricing    Cashflow_ID    ${rowid}    ${CashflowID}    ${DNR_DATASET}
    
    Close All Windows on LIQ
    
Validate Cash In Report for Payment Non Agency is Generated for All Payments Coming in for CBA
    [Documentation]    This keyword is used to validate that the Cash In Report is generated for all payments coming in for CBA.
    ...    @author: fluberio    10DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ### Get Actual Details in the Report For Interest DDA Transaction ###
    ${Cashflow_Amount_Interest}    Read Data From Excel    Page1    Cashflow Amount    &{ExcelPath}[DDA_Transaction_Interest]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description
    ${Transaction_Status_Interest}    Read Data From Excel    Page1    Cashflow Status    &{ExcelPath}[DDA_Transaction_Interest]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description
    ${ProcessingAreaCode_Interest}    Read Data From Excel    Page1    Processing Area Code    &{ExcelPath}[DDA_Transaction_Interest]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description
    ${ProcessingDate_Interest}    Read Data From Excel    Page1    Processing Date    &{ExcelPath}[DDA_Transaction_Interest]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description
    ${Cashflow_Direction_Interest}    Read Data From Excel    Page1    Cashflow Direction${SPACE}    &{ExcelPath}[DDA_Transaction_Interest]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description
    
    ${Cashflow_Amount}    Convert to Number    &{ExcelPath}[Cashflow_Amount_Interest]
    ${Cashflow_Amount_Interest}    Convert to Number    ${Cashflow_Amount_Interest}
    Compare Two Strings    ${Cashflow_Amount}    ${Cashflow_Amount_Interest}
    Compare Two Strings    &{ExcelPath}[Transaction_Status]    ${Transaction_Status_Interest.strip()}
    Compare Two Strings    &{ExcelPath}[Processing_Area_Code]    ${ProcessingAreaCode_Interest.strip()}
    Compare Two Strings    &{ExcelPath}[Cashflow_Direction]    ${Cashflow_Direction_Interest.strip()}
    
    ${Report_Date_Value}    Get Date Value from Date Added or Amended Column    ${ProcessingDate_Interest}    %d-%b-%Y
    ${Dataset_Date_Value}    Get Date Value from Date Added or Amended Column    &{ExcelPath}[Transaction_Date]
    Compare Two Strings    ${Dataset_Date_Value}    ${Report_Date_Value.strip()}
    
    ### Get Actual Details in the Report For Principal DDA Transaction ###
    ${Cashflow_Amount_Principal}    Read Data From Excel    Page1    Cashflow Amount    &{ExcelPath}[DDA_Transaction_Principal]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description
    ${Transaction_Status_Principal}    Read Data From Excel    Page1    Cashflow Status    &{ExcelPath}[DDA_Transaction_Principal]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description
    ${ProcessingAreaCode_Principal}    Read Data From Excel    Page1    Processing Area Code    &{ExcelPath}[DDA_Transaction_Principal]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description
    ${ProcessingDate_Principal}    Read Data From Excel    Page1    Processing Date    &{ExcelPath}[DDA_Transaction_Principal]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description
    ${Cashflow_Direction_Principal}    Read Data From Excel    Page1    Cashflow Direction${SPACE}    &{ExcelPath}[DDA_Transaction_Principal]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=DDA Transaction Description
    
    ${Cashflow_Amount}    Convert to Number    &{ExcelPath}[Cashflow_Amount_Principal]
    ${Cashflow_Amount_Principal}    Convert to Number    ${Cashflow_Amount_Principal}
    Compare Two Strings    ${Cashflow_Amount}    ${Cashflow_Amount_Principal}
    Compare Two Strings    &{ExcelPath}[Transaction_Status]    ${Transaction_Status_Principal.strip()}
    Compare Two Strings    &{ExcelPath}[Processing_Area_Code]    ${ProcessingAreaCode_Principal.strip()}
    Compare Two Strings    &{ExcelPath}[Cashflow_Direction]    ${Cashflow_Direction_Principal.strip()}
    
    ${Report_Date_Value}    Get Date Value from Date Added or Amended Column    ${ProcessingDate_Principal}    %d-%b-%Y
    ${Dataset_Date_Value}    Get Date Value from Date Added or Amended Column    &{ExcelPath}[Transaction_Date]
    Compare Two Strings    ${Dataset_Date_Value}    ${Report_Date_Value.strip()}