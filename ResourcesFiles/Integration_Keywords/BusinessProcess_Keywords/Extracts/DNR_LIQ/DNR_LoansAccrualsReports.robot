*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate Columns from Loans and Accruals Report
    [Documentation]    This keyword is used to validate the following fields (columns) in the same order as specified below in the report:
    ...    Fields to Validate in Facilities sheet: Data Type, Branch Code, Business Date, Risk Book, Portfolio, Expense Code, Deal Number, Facility Number, Facility Start Date, Facility Maturity Date, Facility Currency Code, Lender Commitment
    ...    Fields to Validate in Outstandings sheet: Data Type, Outstanding Cycle Start Date, Outstanding Cycle End Date, Outstanding Cycle Due Date, Current Cycle, Outstanding Global Cycle Due, Outstanding Global Paid to Date, 
    ...    Outstanding Global projected EOC Accrual, Outstanding Global Projected EOC Due, Outstanding Global Accrued to Date, Branch Code, Business Date, Risk Book, Portfolio, Expense Code, Deal Number, Facility Number, 
    ...    Facility Start Date, Facility Maturity Date, Facility Currency Code, Lender Commitment, Outstanding Alias, Outstanding Borrower CIF, Outstanding Type, Pricing Option, Rate Basis, OST Currency Code, OST Host Bank Net, 
    ...    OST All-In Rate, OST Base Rate Percentage, OST Spread Percentage, OST Rate Basis, OST Effective Date, OST Repricing Frequency, OST Repricing Date
    ...    NOTE: Loans and Accruals Report should be available already in the report path.
    ...    @author: ccarriedo    23NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ${LoanAccrual_Report}    Set Variable    &{ExcelPath}[Report_Path]${CBA_LOANSACCRUALS_REPORTFILE}.xlsx
    Validate Sequencing of Columns if Correct in Excel Sheet    ${LoanAccrual_Report}    &{ExcelPath}[Sheet_Name]    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]

Write Details for Loans and Accruals Report
    [Documentation]    This keyword is used to write needed details in Loans and Accruals Report sheet.
    ...    @author: clanding    07DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    Delete File If Exist    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_LOANSACCRUALS_REPORTFILE}.xlsx
    Copy File    &{ExcelPath}[Report_Path]${CBA_LOANSACCRUALS_REPORTFILE}.xlsx    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_LOANSACCRUALS_REPORTFILE}.xlsx
    Write Data To Excel    DNR    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_LOANSACCRUALS_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    LOACC    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_LOANSACCRUALS_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True

Validate Data Type Column if Correct from Loans and Accruals Report
    [Documentation]    This keyword is used to validate if Data Type values are correct for Facility and Outstanding sheet.
    ...    @author: ccarriedo    07DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ${Actual_DataType_Facilities}    Read Data From Excel    Facilities    Data Type    1    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    readAllData=Y
    Verify List Values if Correct    ${Actual_DataType_Facilities}    Facility

    ${Actual_DataType_Outstanding}    Read Data From Excel    Outstandings    Data Type    1    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    readAllData=Y
    Verify List Values if Correct    ${Actual_DataType_Outstanding}    Outstanding

Validate Currency Column if Correct from Loans and Accruals Report
    [Documentation]    This keyword is used to validate if Currency values are correct for Facility and Outstanding sheet.
    ...    @author: kaustero    07DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    ${Actual_FacilityCurrency}    Read Data From Excel    Facilities    Facility Currency    1    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    readAllData=Y
    Validate List Value if Existing in Excel Sheet Column    ${Currency_Codes}    Currency_Codes    Currency_Code    ${Actual_FacilityCurrency}

    ${Actual_OutstandingCurrency}    Read Data From Excel    Outstandings    Outstanding Currency    1    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    readAllData=Y
    Validate List Value if Existing in Excel Sheet Column    ${Currency_Codes}    Currency_Codes    Currency_Code    ${Actual_OutstandingCurrency}

Validate Active Facility with Active Outstanding is Not Existing in Loans and Accruals Report
    [Documentation]    This keyword is used to validate active facility with active outstanding is not existing in Loans and Accruals Report.
    ...    @author: clanding    09DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Text Value if Not Existing in Excel Sheet Column    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    &{ExcelPath}[Sheet_Name]    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[FCN]${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}
