*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate Summary and Details from Liquidity Report
    [Documentation]    This keyword is used to validate fields in Summary and Details sheet names in the Liquidity Report.
    ...    Fields to Validate in Summary Tab: Effective Date, New Drawdown, Increase, Total Drawdown,Payments,Interest,Total Repayment,NetFlow
    ...    Fields to Validate in Details Tab: Effective Date,TRN Group Internal ID,Transaction Id,Customer ID,Customer Name,Currency,Net Cashflow,Transaction Description,Transaction Status
    ...    @author: fluberio    19NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Multiple Value if Existing in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_LIQUIDITY_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]

Write Details for Liquidity Report
    [Documentation]    This keyword is used to write needed details in Liquidity Report sheet.
    ...    @author: clanding    25NOV2020    - initial create
    [Arguments]    ${ExcelPath}

    Delete File If Exist    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_LIQUIDITY_REPORTFILE}.xlsx
    Copy File    &{ExcelPath}[Report_Path]${CBA_LIQUIDITY_REPORTFILE}.xlsx    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_LIQUIDITY_REPORTFILE}.xlsx
    Write Data To Excel    DNR    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_LIQUIDITY_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    LQDTY    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_LIQUIDITY_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True

Validate Ongoing Fee Payment is Not Existing in Liquidity Report
    [Documentation]    This keyword is used to validate Ongoing Fee Payment transactions are not existing in the liquidity report.
    ...    @author: clanding    08DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Text Value if Not Existing in Excel Sheet Column    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    &{ExcelPath}[Sheet_Name]    &{ExcelPath}[Columns_To_Validate]    ${DNR_ONGOINGFEEPAYMENT_TRANSACTION}    2
    
Get RID from Loan for Liquidity Report
    [Documentation]    This keyword is used to get RID from loan for Liquidity Report.
    ...    @author: clanding    08DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate to an Existing Loan    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    ${Loan_RID}    Get Cashflow Details from Released Initial Loan Drawdown    &{ExcelPath}[LIQCustomer_ShortName]
    Logout from Loan IQ

    Write Data To Excel    LQDTY    Transaction_ID    ${TestCase_Name}    ${Loan_RID}    ${DNR_DATASET}    bTestCaseColumn=True

Validate if RID is Not Existing in Liquidity Report
    [Documentation]    This keyword is used verify if RID is not existing in the report.
    ...    @author: clanding    08DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    Validate Text Value if Not Existing in Excel Sheet Column    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    &{ExcelPath}[Sheet_Name]    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Transaction_ID]    2

Validate if Loan is Existing in Liquidity Report
    [Documentation]    This keyword is used verify if RID is not existing in the report.
    ...    @author: clanding    08DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    ### Get Deal Values ###
    ${Loan_RequestedAmount_WithComma}    Read Data From Excel    SC1_LoanDrawdown    Loan_RequestedAmount    Expanded_Scenario1_ActiveFac1_Repayment    ${DNR_DATASET}    bTestCaseColumn=True    sTestCaseColReference=Test_Case
    ${Loan_RequestedAmount}    Remove Comma Separators in Numbers    ${Loan_RequestedAmount_WithComma}
    
    ### Get Report Values ###
    ${Net_Cashflow}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Net Cashflow    &{ExcelPath}[Transaction_ID]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Transaction Id    iHeaderIndex=2
    ${Transaction_Status}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Transaction Status    &{ExcelPath}[Transaction_ID]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Transaction Id    iHeaderIndex=2

    Compare Two Strings    &{ExcelPath}[Transaction_Status]    ${Transaction_Status}

    ${Net_Cashflow}   Return Given Number with Specific Decimal Places without Rounding    ${Net_Cashflow}    2
    ${Loan_RequestedAmount}   Return Given Number with Specific Decimal Places without Rounding    ${Loan_RequestedAmount}    2
    Compare Two Strings    -${Loan_RequestedAmount}    ${Net_Cashflow}