*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Validate Cash Out Report For Payment Non Agency is Generated for All Transactions In Approval Status
    [Documentation]    This keyword is used to validate that the Cash Out Report is generated for all transactions in Approval status.
    ...    @author: fluberio    10DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    ### Get Expected Details ###
    ${Cashflow_Amount}    Read Data From Excel    SC1_LoanDrawdown    Cashflow_Amount    ${rowid}    ${DNR_DATASET}
    ${Transaction_Status}    Read Data From Excel    SC1_LoanDrawdown    Transaction_Status    ${rowid}    ${DNR_DATASET}
    ${ProcessingAreaCode}    Read Data From Excel    SC1_LoanDrawdown    Processing_Area_Code    ${rowid}    ${DNR_DATASET}
    ${Cashflow_Id}    Read Data From Excel    SC1_LoanDrawdown    Cashflow_ID    ${rowid}    ${DNR_DATASET}
    
    ### Get Actual Details in the Report
    ${Cashflow_Amount_Report}    Read Data From Excel    Page1    Cashflow Amount    ${Cashflow_Id}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID
    ${Transaction_Status_Report}    Read Data From Excel    Page1    Cashflow Status    ${Cashflow_Id}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID
    ${ProcessingAreaCode_Report}    Read Data From Excel    Page1    Processing Area Code    ${Cashflow_Id}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID
    ${ProcessingDate_Report}    Read Data From Excel    Page1    Processing Date    ${Cashflow_Id}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID
    ${Cashflow_Direction}    Read Data From Excel    Page1    Cashflow Direction    ${Cashflow_Id}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID
    
    ${Cashflow_Amount}    Convert to Number    ${Cashflow_Amount}
    ${Cashflow_Amount_Report}    Convert to Number    ${Cashflow_Amount_Report}
    Compare Two Strings    ${Cashflow_Amount}    ${Cashflow_Amount_Report}
    Compare Two Strings    ${Transaction_Status}    ${Transaction_Status_Report.strip()}
    Compare Two Strings    ${ProcessingAreaCode}    ${ProcessingAreaCode_Report.strip()}
    Compare Two Strings    &{ExcelPath}[Cashflow_Direction]    ${Cashflow_Direction.strip()}
    Compare Two Strings    ${NONE}   ${ProcessingDate_Report}
    
Write Details for Payment Non Agency Reports
    [Documentation]    This keyword is used to write needed details in Payment Non Agency sheet.
    ...    @author: fluberio    10DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    Delete File If Exist    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_PAYMENT_REPORTFILE}.xlsx
    Copy File    &{ExcelPath}[Report_Path]${CBA_PAYMENT_REPORTFILE}.xlsx    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_PAYMENT_REPORTFILE}.xlsx
    Write Data To Excel    DNR    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_PAYMENT_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    PAYNA    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_PAYMENT_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True
         