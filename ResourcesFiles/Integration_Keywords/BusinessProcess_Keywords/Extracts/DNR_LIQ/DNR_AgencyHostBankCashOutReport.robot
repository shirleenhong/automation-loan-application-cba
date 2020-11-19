*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validation of Report and Dataset Value for Agency Host Bank Cash Out for Host Bank Share Amount
    [Documentation]    This keyword is used for reading and validating the values from the downloaded excel file in Cognos.
    ...    @author: shirhong    17NOV2020    - Initial create
    [Arguments]    ${ExcelPath}
    
    Log    ${ExcelPath}

    ### Extract the Data from Downloaded Excel File ###   
    ${ActualHostBankShareAmount}    Read Data From Excel    Agency_CashOut    Host Bank Share Amount    ${ExcelPath}[Cashflow_ID]    &{ExcelPath}[Report_Path]${CBA_CASHOUT_REPORTFILE}.xlsx    bTestCaseColumn=True    sTestCaseColReference=Cashflow ID    iHeaderIndex=2

    ### Verify the Data from Dataset File ###
    Compare Two Strings    &{ExcelPath}[Host_Bank_Share_Amount]    ${ActualHostBankShareAmount}
    
