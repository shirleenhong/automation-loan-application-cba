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