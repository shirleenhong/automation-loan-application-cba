*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Create Query for VLS_RISK_PORT_EXP to validate RPE_CDE_EXPENSE
    [Documentation]    This keyword is used to create a/an SQL Query for VLS_RISK_PORT_EXP to validate RPE_CDE_EXPENSE
    ...    @author: ehugo    29AUG2019    - initial create
    
    Get Count of Non-Unique Items from Different Tables    RPE_CDE_EXPENSE    VLS_RISK_PORT_EXP    BSG_CDE_EXPENSE    VLS_BAL_SUBLEDGER

Create Query for VLS_RISK_PORT_EXP to validate RPE_CDE_PORTFOLIO
    [Documentation]    This keyword is used to create a/an SQL Query for VLS_RISK_PORT_EXP to validate RPE_CDE_PORTFOLIO
    ...    @author: ehugo    30AUG2019    - initial create
    
    Get Count of Non-Unique Items from Different Tables    RPE_CDE_PORTFOLIO    VLS_RISK_PORT_EXP    BSG_CDE_PORTFOLIO    VLS_BAL_SUBLEDGER
        
Run Query to get Records from DB
    [Documentation]    This keyword is used run query to get the records from DB
    ...    @author: mgaling    06Sep2019    Initial Create
    [Arguments]    ${sQuery_Script}
    
    ${Query}    Set Variable    ${sQuery_Script}    
    ${Result}    Connect to LIQ Database and Return Results    ${Query}
    
    [Return]    ${Result}    

Check Bank and Net Amounts from VLS_PROD_POS_CUR DB Table
    [Documentation]    This keyword is used to validate PDC_AMT_BNK_GR_CMT and PDC_AMT_BNK_NT_CMT values from DB VLS_PROD_POS_CUR Table.
    ...    @author: mgaling    23Sep2019    Initial Create
    [Arguments]    ${sSQL_Query} 
    
    ${result}    Run Query to get Records from DB    ${sSQL_Query}
    ${Result}    Convert To String    ${Result}
    ${Result}=    Remove String    ${Result}    [    (    ,    )    ]
    Run Keyword If    "${result}"=="${Empty}"    Log    Gross and Net Amount are matched!
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Gross and Net Amount are not matched, Deal is Syndicated!

Run Query for Referential Integrity Validation
    [Documentation]    This keyword is used to run the query to check if there's an orphan records between the two DB Tables.
    ...    @author: mgaling    25Sep2019    Initial Create
    [Arguments]    ${sSQL_Query}    ${sReference_TableName}    ${sSource_TableName}     
    
    ${result}    Run Query to get Records from DB    ${sSQL_Query}
    ${Result}    Convert To String    ${Result}
    ${Result}=    Remove String    ${Result}    [    (    ,    )    ]
    Run Keyword If    "${result}"=="${Empty}"    Log    No Orphan Records between ${sReference_TableName} and ${sSource_TableName}!
    ...    ELSE    Run Keyword And Continue On Failure    Fail    There's Orphan Records (${result}) between ${sReference_TableName} and ${sSource_TableName} !
