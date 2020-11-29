*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Access GL Entry CSV File for New Funding Amount and Return Sum of Amount
    [Documentation]    This keyword is used to access VLS_GL_ENTRY csv file and return sum of GL_AMT_ENTRY column.
    ...    NOTE: sBus_Date format should be 2020-01-02
    ...    @author: clanding    19OCT2020    - initial create
    ...    @update: clanding    29NOV2020    - added handling for Zone 2, added delimiter argument
    [Arguments]    ${sDWE_Extract_Path}    ${sZone}    ${sBus_Date}    ${sDelimiter}
    
    ${Bus_Date_Converted}    Remove String    ${sBus_Date}    -
    
    ${CSV_File}    Run Keyword If    '${sZone}'=='ZONE3'    Set Variable    ${DNA_CCB_LIQ_FILENAME}SYD_VLS_GL_ENTRY_${Bus_Date_Converted}.csv
    ...    ELSE IF    '${sZone}'=='ZONE2'    Set Variable    ${DNA_CCB_LIQ_FILENAME}EUR_VLS_GL_ENTRY_${Bus_Date_Converted}.csv
    ${CSV_File_Content}    Run Keyword If    '${sZone}'=='ZONE3'    OperatingSystem.Get File    ${sDWE_Extract_Path}/${DNA_CCB_LIQ_FILENAME}SYD_${Bus_Date_Converted}/${CSV_File}
    ...    ELSE IF    '${sZone}'=='ZONE2'    OperatingSystem.Get File    ${sDWE_Extract_Path}/${DNA_CCB_LIQ_FILENAME}EUR_${Bus_Date_Converted}/${CSV_File}
    
    ### Get Column header list ###    
    ${Column_List}    Split String    ${CSV_File_Content}    ${sDelimiter}
    ${Column_List_Count}    Get Length    ${Column_List}

    ### Get GLE_CDE_BUS_TRAN index ###
    :FOR    ${GLE_CDE_BUS_TRAN_Index}    IN RANGE    ${Column_List_Count}
    \    Log    @{Column_List}[${GLE_CDE_BUS_TRAN_Index}]
    \    ${Column}    Remove String    @{Column_List}[${GLE_CDE_BUS_TRAN_Index}]    "
    \    Exit For Loop If    '${Column}'=='GLE_CDE_BUS_TRAN'

    ### Get GLE_CDE_ACCTG_OPER index ###
    :FOR    ${GLE_CDE_ACCTG_OPER_Index}    IN RANGE    ${Column_List_Count}
    \    Log    @{Column_List}[${GLE_CDE_ACCTG_OPER_Index}]
    \    ${Column}    Remove String    @{Column_List}[${GLE_CDE_ACCTG_OPER_Index}]    "
    \    Exit For Loop If    '${Column}'=='GLE_CDE_ACCTG_OPER'

    ### Get GLE_DTE_POSTING index ###
    :FOR    ${GLE_DTE_POSTING_Index}    IN RANGE    ${Column_List_Count}
    \    Log    @{Column_List}[${GLE_DTE_POSTING_Index}]
    \    ${Column}    Remove String    @{Column_List}[${GLE_DTE_POSTING_Index}]    "
    \    Exit For Loop If    '${Column}'=='GLE_DTE_POSTING'

    ### Get GLE_AMT_ENTRY index ###
    :FOR    ${GLE_AMT_ENTRY_Index}    IN RANGE    ${Column_List_Count}
    \    Log    @{Column_List}[${GLE_AMT_ENTRY_Index}]
    \    ${Column}    Remove String    @{Column_List}[${GLE_AMT_ENTRY_Index}]    "
    \    Exit For Loop If    '${Column}'=='GLE_AMT_ENTRY'

    ${GL_Amount_Sum}    Set Variable    0
    ${CSV_File_Content_LineCount}    Get Line Count    ${CSV_File_Content}
    :FOR    ${Index}    IN RANGE    1    ${CSV_File_Content_LineCount}
    \    ${CSV_Line}    Get Line    ${CSV_File_Content}    ${Index}
    \    ${CSV_Line_List}    Split String    ${CSV_Line}    ${sDelimiter}
    \    Log    GLE_CDE_BUS_TRAN : @{CSV_Line_List}[${GLE_CDE_BUS_TRAN_Index}]
    \    Log    GLE_CDE_ACCTG_OPER : @{CSV_Line_List}[${GLE_CDE_ACCTG_OPER_Index}]
    \    Log    GLE_DTE_POSTING : @{CSV_Line_List}[${GLE_DTE_POSTING_Index}]
    \    Log    GLE_AMT_ENTRY : @{CSV_Line_List}[${GLE_AMT_ENTRY_Index}]
    \    ${GLE_CDE_BUS_TRAN_Value}    Remove String    @{CSV_Line_List}[${GLE_CDE_BUS_TRAN_Index}]    "
    \    ${GLE_CDE_ACCTG_OPER_Value}    Remove String    @{CSV_Line_List}[${GLE_CDE_ACCTG_OPER_Index}]    "
    \    ${GLE_DTE_POSTING_Value}    Remove String    @{CSV_Line_List}[${GLE_DTE_POSTING_Index}]    "    00:00:00
    \    ${GLE_AMT_ENTRY_Value}    Remove String    @{CSV_Line_List}[${GLE_AMT_ENTRY_Index}]    "
    \    ${IsEqual_GLE_CDE_BUS_TRAN}    Run Keyword And Return Status    Should Be Equal As Strings    ${GLE_CDE_BUS_TRAN_Value.strip()}    LNDR
    \    ${IsEqual_GLE_CDE_ACCTG_OPER}    Run Keyword And Return Status    Should Be Equal As Strings    ${GLE_CDE_ACCTG_OPER_Value.strip()}    DR
    \    ${IsEqual_GLE_DTE_POSTING}    Run Keyword And Return Status    Should Be Equal As Strings    ${GLE_DTE_POSTING_Value.strip()}    ${sBus_Date}
    \    ${GL_Amount_Sum}    Run Keyword If    ${IsEqual_GLE_CDE_BUS_TRAN}==${True} and ${IsEqual_GLE_CDE_ACCTG_OPER}==${True} and ${IsEqual_GLE_DTE_POSTING}==${True}    Evaluate    ${GL_Amount_Sum}+${GLE_AMT_ENTRY_Value}
         ...    ELSE    Set Variable    ${GL_Amount_Sum}
    \    Log    Sum of GLE_AMT_ENTRY: ${GL_Amount_Sum}
    Log    Sum of GLE_AMT_ENTRY: ${GL_Amount_Sum}
    [Return]    ${GL_Amount_Sum}

Access Balance Subledger CSV File and Return Sum of Amount
    [Documentation]    This keyword is used to access VLS_BAL_SUBLEDGER csv file and return sum of BSG_AMT_PRIOR_EOD column.
    ...    NOTE: sPosting_Date format should be %d-%b-%Y (21-MAY-2020)
    ...    @author: clanding    19OCT2020    - initial create
    ...    @update: clanding    29NOV2020    - added delimiter argument
    [Arguments]    ${sDWE_Extract_Path}    ${sZone}    ${sBus_Date}    ${sCurrency}    ${sShort_Name}    ${sDelimiter}
    
    ${Bus_Date_Converted}    Remove String    ${sBus_Date}    -
    
    ${CSV_File}    Run Keyword If    '${sZone}'=='ZONE3'    Set Variable    ${DNA_CCB_LIQ_FILENAME}SYD_VLS_BAL_SUBLEDGER_${Bus_Date_Converted}.csv
    ...    ELSE IF    '${sZone}'=='ZONE2'    Set Variable    ${DNA_CCB_LIQ_FILENAME}EUR_VLS_BAL_SUBLEDGER_${Bus_Date_Converted}.csv
    ${CSV_File_Content}    OperatingSystem.Get File    ${sDWE_Extract_Path}/${DNA_CCB_LIQ_FILENAME}SYD_${Bus_Date_Converted}/${CSV_File}
    
    ### Get Column header list ###    
    ${Column_List}    Split String    ${CSV_File_Content}    ${sDelimiter}
    ${Column_List_Count}    Get Length    ${Column_List}

    ### Get BSG_CDE_GL_SHTNAME index ###
    :FOR    ${BSG_CDE_GL_SHTNAME_Index}    IN RANGE    ${Column_List_Count}
    \    Log    @{Column_List}[${BSG_CDE_GL_SHTNAME_Index}]
    \    ${Column}    Remove String    @{Column_List}[${BSG_CDE_GL_SHTNAME_Index}]    "
    \    Exit For Loop If    '${Column}'=='BSG_CDE_GL_SHTNAME'
    
    ### Get BSG_CDE_CURRENCY index ###
    :FOR    ${BSG_CDE_CURRENCY_Index}    IN RANGE    ${Column_List_Count}
    \    Log    @{Column_List}[${BSG_CDE_CURRENCY_Index}]
    \    ${Column}    Remove String    @{Column_List}[${BSG_CDE_CURRENCY_Index}]    "
    \    Exit For Loop If    '${Column}'=='BSG_CDE_CURRENCY'

    ### Get BSG_AMT_PRIOR_EOD index ###
    :FOR    ${BSG_AMT_PRIOR_EOD_Index}    IN RANGE    ${Column_List_Count}
    \    Log    @{Column_List}[${BSG_AMT_PRIOR_EOD_Index}]
    \    ${Column}    Remove String    @{Column_List}[${BSG_AMT_PRIOR_EOD_Index}]    "
    \    Exit For Loop If    '${Column}'=='BSG_AMT_PRIOR_EOD'

    ${Bal_Subledger_Sum}    Set Variable    0
    ${CSV_File_Content_LineCount}    Get Line Count    ${CSV_File_Content}
    :FOR    ${Index}    IN RANGE    1    ${CSV_File_Content_LineCount}
    \    ${CSV_Line}    Get Line    ${CSV_File_Content}    ${Index}
    \    ${CSV_Line_List}    Split String    ${CSV_Line}    ${sDelimiter}
    \    Log    BSG_CDE_GL_SHTNAME : @{CSV_Line_List}[${BSG_CDE_GL_SHTNAME_Index}]
    \    Log    BSG_CDE_CURRENCY : @{CSV_Line_List}[${BSG_CDE_CURRENCY_Index}]
    \    ${BSG_CDE_GL_SHTNAME_Value}    Remove String    @{CSV_Line_List}[${BSG_CDE_GL_SHTNAME_Index}]    "
    \    ${BSG_CDE_CURRENCY_Value}    Remove String    @{CSV_Line_List}[${BSG_CDE_CURRENCY_Index}]    "
    \    ${BSG_AMT_PRIOR_EOD_Value}    Remove String    @{CSV_Line_List}[${BSG_AMT_PRIOR_EOD_Index}]    "
    \    ${IsEqual_BSG_CDE_GL_SHTNAME}    Run Keyword And Return Status    Should Be Equal As Strings    ${BSG_CDE_GL_SHTNAME_Value.strip()}    ${sShort_Name}
    \    ${IsEqual_BSG_CDE_CURRENCY}    Run Keyword And Return Status    Should Be Equal As Strings    ${BSG_CDE_CURRENCY_Value.strip()}    ${sCurrency}
    \    ${Bal_Subledger_Sum}    Run Keyword If    ${IsEqual_BSG_CDE_GL_SHTNAME}==${True} and ${IsEqual_BSG_CDE_CURRENCY}==${True}    Evaluate    ${Bal_Subledger_Sum}+${BSG_AMT_PRIOR_EOD_Value}
         ...    ELSE    Set Variable    ${Bal_Subledger_Sum}
    \    Log    Sum of BSG_AMT_PRIOR_EOD: ${Bal_Subledger_Sum}
    Log    Sum of BSG_AMT_PRIOR_EOD: ${Bal_Subledger_Sum}
    ${Bal_Subledger_Sum}    Evaluate  "%.2f" % (${Bal_Subledger_Sum})
    [Return]    ${Bal_Subledger_Sum}

Access GL Entry CSV File for Transaction Amount and Return Sum of Amount
    [Documentation]    This keyword is used to access VLS_GL_ENTRY csv file and return sum of GL_AMT_ENTRY column.
    ...    NOTE: sBus_Date format should be 2020-01-02
    ...    @author: clanding    19OCT2020    - initial create
    ...    @update: clanding    29NOV2020    - added delimiter argument
    [Arguments]    ${sDWE_Extract_Path}    ${sZone}    ${sBus_Date}    ${sCurrency}    ${sDelimiter}
    
    ${Bus_Date_Converted}    Remove String    ${sBus_Date}    -
    
    ${CSV_File}    Run Keyword If    '${sZone}'=='ZONE3'    Set Variable    ${DNA_CCB_LIQ_FILENAME}SYD_VLS_GL_ENTRY_${Bus_Date_Converted}.csv
    ...    ELSE IF    '${sZone}'=='ZONE2'    Set Variable    ${DNA_CCB_LIQ_FILENAME}EUR_VLS_GL_ENTRY_${Bus_Date_Converted}.csv
    ${CSV_File_Content}    OperatingSystem.Get File    ${sDWE_Extract_Path}/${DNA_CCB_LIQ_FILENAME}SYD_${Bus_Date_Converted}/${CSV_File}
    
    ### Get Column header list ###    
    ${Column_List}    Split String    ${CSV_File_Content}    ${sDelimiter}
    ${Column_List_Count}    Get Length    ${Column_List}

    ### Get GLE_CDE_CURRENCY index ###
    :FOR    ${GLE_CDE_CURRENCY_Index}    IN RANGE    ${Column_List_Count}
    \    Log    @{Column_List}[${GLE_CDE_CURRENCY_Index}]
    \    ${Column}    Remove String    @{Column_List}[${GLE_CDE_CURRENCY_Index}]    "
    \    Exit For Loop If    '${Column}'=='GLE_CDE_CURRENCY'

    ### Get GLE_DTE_POSTING index ###
    :FOR    ${GLE_DTE_POSTING_Index}    IN RANGE    ${Column_List_Count}
    \    Log    @{Column_List}[${GLE_DTE_POSTING_Index}]
    \    ${Column}    Remove String    @{Column_List}[${GLE_DTE_POSTING_Index}]    "
    \    Exit For Loop If    '${Column}'=='GLE_DTE_POSTING'

    ### Get GLE_AMT_ENTRY index ###
    :FOR    ${GLE_AMT_ENTRY_Index}    IN RANGE    ${Column_List_Count}
    \    Log    @{Column_List}[${GLE_AMT_ENTRY_Index}]
    \    ${Column}    Remove String    @{Column_List}[${GLE_AMT_ENTRY_Index}]    "
    \    Exit For Loop If    '${Column}'=='GLE_AMT_ENTRY'

    ${GL_Amount_Sum}    Set Variable    0
    ${CSV_File_Content_LineCount}    Get Line Count    ${CSV_File_Content}
    :FOR    ${Index}    IN RANGE    1    ${CSV_File_Content_LineCount}
    \    ${CSV_Line}    Get Line    ${CSV_File_Content}    ${Index}
    \    ${CSV_Line_List}    Split String    ${CSV_Line}    ${sDelimiter}
    \    Log    GLE_CDE_CURRENCY : @{CSV_Line_List}[${GLE_CDE_CURRENCY_Index}]
    \    Log    GLE_DTE_POSTING : @{CSV_Line_List}[${GLE_DTE_POSTING_Index}]
    \    Log    GLE_AMT_ENTRY : @{CSV_Line_List}[${GLE_AMT_ENTRY_Index}]
    \    ${GLE_CDE_CURRENCY_Value}    Remove String    @{CSV_Line_List}[${GLE_CDE_CURRENCY_Index}]    "
    \    ${GLE_DTE_POSTING_Value}    Remove String    @{CSV_Line_List}[${GLE_DTE_POSTING_Index}]    "    00:00:00
    \    ${GLE_AMT_ENTRY_Value}    Remove String    @{CSV_Line_List}[${GLE_AMT_ENTRY_Index}]    "
    \    ${IsEqual_GLE_CDE_CURRENCY}    Run Keyword And Return Status    Should Be Equal As Strings    ${GLE_CDE_CURRENCY_Value.strip()}    ${sCurrency}
    \    ${IsEqual_GLE_DTE_POSTING}    Run Keyword And Return Status    Should Be Equal As Strings    ${GLE_DTE_POSTING_Value.strip()}    ${sBus_Date}
    \    ${GL_Amount_Sum}    Run Keyword If    ${IsEqual_GLE_CDE_CURRENCY}==${True} and ${IsEqual_GLE_DTE_POSTING}==${True}    Evaluate    ${GL_Amount_Sum}+${GLE_AMT_ENTRY_Value}
         ...    ELSE    Set Variable    ${GL_Amount_Sum}
    \    Log    Sum of GLE_AMT_ENTRY: ${GL_Amount_Sum}
    Log    Sum of GLE_AMT_ENTRY: ${GL_Amount_Sum}
    ${GL_Amount_Sum}    Evaluate  "%.2f" % (${GL_Amount_Sum})
    [Return]    ${GL_Amount_Sum}

Access Deal CSV File and Return Sum
    [Documentation]    This keyword is used to access VLS_DEAL csv file and return sum of DEA_PID_DEAL column.
    ...    NOTE: sBus_Date format should be 2020-01-02
    ...    @author: clanding    19OCT2020    - initial create
    ...    @update: clanding    29NOV2020    - added delimiter argument
    [Arguments]    ${sDWE_Extract_Path}    ${sZone}    ${sBus_Date}    ${sBranch_Code}    ${sDelimiter}
    
    ${Bus_Date_Converted}    Remove String    ${sBus_Date}    -
    
    ${CSV_File}    Run Keyword If    '${sZone}'=='ZONE3'    Set Variable    ${DNA_CCB_LIQ_FILENAME}SYD_VLS_DEAL_${Bus_Date_Converted}.csv
    ...    ELSE IF    '${sZone}'=='ZONE2'    Set Variable    ${DNA_CCB_LIQ_FILENAME}EUR_VLS_DEAL_${Bus_Date_Converted}.csv
    ${CSV_File_Content}    OperatingSystem.Get File    ${sDWE_Extract_Path}/${DNA_CCB_LIQ_FILENAME}SYD_${Bus_Date_Converted}/${CSV_File}
    
    ### Get Column header list ###    
    ${Column_List}    Split String    ${CSV_File_Content}    ${sDelimiter}
    ${Column_List_Count}    Get Length    ${Column_List}

    ### Get DEA_IND_ACTIVE index ###
    :FOR    ${DEA_IND_ACTIVE_Index}    IN RANGE    ${Column_List_Count}
    \    Log    @{Column_List}[${DEA_IND_ACTIVE_Index}]
    \    ${Column}    Remove String    @{Column_List}[${DEA_IND_ACTIVE_Index}]    "
    \    Exit For Loop If    '${Column}'=='DEA_IND_ACTIVE'

    ### Get DEA_CDE_BRANCH index ###
    :FOR    ${DEA_CDE_BRANCH_Index}    IN RANGE    ${Column_List_Count}
    \    Log    @{Column_List}[${DEA_CDE_BRANCH_Index}]
    \    ${Column}    Remove String    @{Column_List}[${DEA_CDE_BRANCH_Index}]    "
    \    Exit For Loop If    '${Column}'=='DEA_CDE_BRANCH'

    ${Total_Deal}    Set Variable    0
    ${CSV_File_Content_LineCount}    Get Line Count    ${CSV_File_Content}
    :FOR    ${Index}    IN RANGE    1    ${CSV_File_Content_LineCount}
    \    ${CSV_Line}    Get Line    ${CSV_File_Content}    ${Index}
    \    ${CSV_Line_List}    Split String    ${CSV_Line}    ${sDelimiter}
    \    Log    DEA_IND_ACTIVE : @{CSV_Line_List}[${DEA_IND_ACTIVE_Index}]
    \    Log    DEA_CDE_BRANCH : @{CSV_Line_List}[${DEA_CDE_BRANCH_Index}]
    \    ${DEA_IND_ACTIVE_Value}    Remove String    @{CSV_Line_List}[${DEA_IND_ACTIVE_Index}]    "
    \    ${DEA_CDE_BRANCH_Value}    Remove String    @{CSV_Line_List}[${DEA_CDE_BRANCH_Index}]    "
    \    ${IsEqual_DEA_IND_ACTIVE}    Run Keyword And Return Status    Should Be Equal As Strings    ${DEA_IND_ACTIVE_Value.strip()}    Y
    \    ${IsEqual_DEA_CDE_BRANCH}    Verify If CSV File Have Expected Value    ${sBranch_Code}    ${DEA_CDE_BRANCH_Value.strip()}
    \    ${Total_Deal}    Run Keyword If    ${IsEqual_DEA_IND_ACTIVE}==${True} and ${IsEqual_DEA_CDE_BRANCH}==${True}    Evaluate    ${Total_Deal}+1
         ...    ELSE    Set Variable    ${Total_Deal}
    \    Log    Total Deal: ${Total_Deal}
    Log    Total Deal: ${Total_Deal}
    [Return]    ${Total_Deal}

Verify If CSV File Have Expected Value
    [Documentation]    This keyword is used to extract all expected value and compare actual value from the CSV line.
    ...    @author: clanding    19OCT2020    - initial create
    [Arguments]    ${sExpected_Value}    ${sActual_Value}    ${bList}=${False}
    
    ${Expected_Value_List}    Run Keyword If    ${bList}==${False}    Split String    ${sExpected_Value}    ,
    ...    ELSE    Set Variable    ${sExpected_Value}
    ${IsEqual}    Run Keyword And Return Status    Should Contain    ${Expected_Value_List}    ${sActual_Value.strip()}

    [Return]    ${IsEqual}

Access Deal and Prod Pos Current CSV Files and Return Sum
    [Documentation]    This keyword is used to access VLS_DEAL and VLS_PROD_POS_CUR csv files and return sum of PDC_AMT_BNK_GR_CMT column.
    ...    VLS_DEAL: Filter DEA_CDE_ORIG_CCY by ${sCurrency} and get DEA_PID_DEAL
    ...    VLS_PROD_POS_CUR: Filter PDC_CDE_PROD_TYPE by DEA and PDC_PID_PRODUCT_ID value should be equal to DEA_PID_DEAL and get sum of PDC_AMT_BNK_GR_CMT.
    ...    NOTE: sBus_Date format should be 2020-01-02
    ...    @author: clanding    19OCT2020    - initial create
    ...    @update: clanding    29NOV2020    - added delimiter argument
    [Arguments]    ${sDWE_Extract_Path}    ${sZone}    ${sBus_Date}    ${sCurrency}    ${sControl_Matrix}    ${sDelimiter}
    
    ${Amount_Type}    Run Keyword If    '${sControl_Matrix}'=='SUM_OF_HB_DEAL_LIMITS_GROSS'    Set Variable    PDC_AMT_BNK_GR_CMT
    ...    ELSE IF    '${sControl_Matrix}'=='SUM_OF_HB_DEAL_LIMITS_NET'    Set Variable    PDC_AMT_BNK_GR_CMT

    ${Bus_Date_Converted}    Remove String    ${sBus_Date}    -
    
    ### VLS_DEAL csv file ###
    ${VLS_DEAL_CSV_File}    Run Keyword If    '${sZone}'=='ZONE3'    Set Variable    ${DNA_CCB_LIQ_FILENAME}SYD_VLS_DEAL_${Bus_Date_Converted}.csv
    ...    ELSE IF    '${sZone}'=='ZONE2'    Set Variable    ${DNA_CCB_LIQ_FILENAME}EUR_VLS_DEAL_${Bus_Date_Converted}.csv
    ${VLS_DEAL_CSV_File_Content}    OperatingSystem.Get File    ${sDWE_Extract_Path}/${DNA_CCB_LIQ_FILENAME}SYD_${Bus_Date_Converted}/${VLS_DEAL_CSV_File}
    
    ### Get Column header list - VLS_DEAL ###    
    ${VLS_DEAL_Column_List}    Split String    ${VLS_DEAL_CSV_File_Content}    ${sDelimiter}
    ${VLS_DEAL_Column_List_Count}    Get Length    ${VLS_DEAL_Column_List}

    ### Get DEA_CDE_ORIG_CCY index ###
    :FOR    ${DEA_CDE_ORIG_CCY_Index}    IN RANGE    ${VLS_DEAL_Column_List_Count}
    \    Log    @{VLS_DEAL_Column_List}[${DEA_CDE_ORIG_CCY_Index}]
    \    ${Column}    Remove String    @{VLS_DEAL_Column_List}[${DEA_CDE_ORIG_CCY_Index}]    "
    \    Exit For Loop If    '${Column}'=='DEA_CDE_ORIG_CCY'

    ### Get DEA_PID_DEAL index ###
    :FOR    ${DEA_PID_DEAL_Index}    IN RANGE    ${VLS_DEAL_Column_List_Count}
    \    Log    @{VLS_DEAL_Column_List}[${DEA_PID_DEAL_Index}]
    \    ${Column}    Remove String    @{VLS_DEAL_Column_List}[${DEA_PID_DEAL_Index}]    "
    \    Exit For Loop If    '${Column}'=='DEA_PID_DEAL'

    ${Deal_List}    Create List
    ${VLS_DEAL_CSV_File_Content_LineCount}    Get Line Count    ${VLS_DEAL_CSV_File_Content}
    :FOR    ${Index}    IN RANGE    1    ${VLS_DEAL_CSV_File_Content_LineCount}
    \    ${CSV_Line}    Get Line    ${VLS_DEAL_CSV_File_Content}    ${Index}
    \    ${CSV_Line_List}    Split String    ${CSV_Line}    ${sDelimiter}
    \    Log    DEA_CDE_ORIG_CCY : @{CSV_Line_List}[${DEA_CDE_ORIG_CCY_Index}]
    \    Log    DEA_PID_DEAL : @{CSV_Line_List}[${DEA_PID_DEAL_Index}]
    \    ${DEA_CDE_ORIG_CCY_Value}    Remove String    @{CSV_Line_List}[${DEA_CDE_ORIG_CCY_Index}]    "
    \    ${DEA_PID_DEAL_Value}    Remove String    @{CSV_Line_List}[${DEA_PID_DEAL_Index}]    "
    \    ${IsEqual_DEA_CDE_ORIG_CCY}    Run Keyword And Return Status    Should Be Equal As Strings    ${DEA_CDE_ORIG_CCY_Value.strip()}    ${sCurrency}
    \    Run Keyword If    ${IsEqual_DEA_CDE_ORIG_CCY}==${True}    Append To List    ${Deal_List}    ${DEA_PID_DEAL_Value}
         ...    ELSE    Append To List    ${Deal_List}
    \    Log    ${Deal_List}
    Log    Deal List: ${Deal_List}

    ### VLS_PROD_POS_CUR csv file ###
    ${VLS_PROD_POS_CUR_CSV_File}    Run Keyword If    '${sZone}'=='ZONE3'    Set Variable    ${DNA_CCB_LIQ_FILENAME}SYD_VLS_PROD_POS_CUR_${Bus_Date_Converted}.csv
    ...    ELSE IF    '${sZone}'=='ZONE2'    Set Variable    ${DNA_CCB_LIQ_FILENAME}EUR_VLS_PROD_POS_CUR_${Bus_Date_Converted}.csv
    ${VLS_PROD_POS_CUR_CSV_File_Content}    OperatingSystem.Get File    ${sDWE_Extract_Path}/${DNA_CCB_LIQ_FILENAME}SYD_${Bus_Date_Converted}/${VLS_PROD_POS_CUR_CSV_File}

    ### Get Column header list - VLS_PROD_POS_CUR ###    
    ${VLS_PROD_POS_CUR_Column_List}    Split String    ${VLS_PROD_POS_CUR_CSV_File_Content}    ${sDelimiter}
    ${VLS_PROD_POS_CUR_Column_List_Count}    Get Length    ${VLS_PROD_POS_CUR_Column_List}
    
    ### Get Column header list - VLS_PROD_POS_CUR ###    
    ${VLS_PROD_POS_CUR_Column_List}    Split String    ${VLS_PROD_POS_CUR_CSV_File_Content}    ${sDelimiter}
    ${VLS_PROD_POS_CUR_Column_List_Count}    Get Length    ${VLS_PROD_POS_CUR_Column_List}

    ### Get PDC_CDE_PROD_TYPE index ###
    :FOR    ${PDC_CDE_PROD_TYPE_Index}    IN RANGE    ${VLS_PROD_POS_CUR_Column_List_Count}
    \    Log    @{VLS_PROD_POS_CUR_Column_List}[${PDC_CDE_PROD_TYPE_Index}]
    \    ${Column}    Remove String    @{VLS_PROD_POS_CUR_Column_List}[${PDC_CDE_PROD_TYPE_Index}]    "
    \    Exit For Loop If    '${Column}'=='PDC_CDE_PROD_TYPE'

    ### Get PDC_PID_PRODUCT_ID index ###
    :FOR    ${PDC_PID_PRODUCT_ID_Index}    IN RANGE    ${VLS_PROD_POS_CUR_Column_List_Count}
    \    Log    @{VLS_PROD_POS_CUR_Column_List}[${PDC_PID_PRODUCT_ID_Index}]
    \    ${Column}    Remove String    @{VLS_PROD_POS_CUR_Column_List}[${PDC_PID_PRODUCT_ID_Index}]    "
    \    Exit For Loop If    '${Column}'=='PDC_PID_PRODUCT_ID'

    ### Get PDC_AMT_BNK_GR_CMT/PDC_AMT_BNK_NT_CMT index ###
    :FOR    ${PDC_AMT_BNK_GR_NT_CMT_Index}    IN RANGE    ${VLS_PROD_POS_CUR_Column_List_Count}
    \    Log    @{VLS_PROD_POS_CUR_Column_List}[${PDC_AMT_BNK_GR_NT_CMT_Index}]
    \    ${Column}    Remove String    @{VLS_PROD_POS_CUR_Column_List}[${PDC_AMT_BNK_GR_NT_CMT_Index}]    "
    \    Exit For Loop If    '${Column}'=='${Amount_Type}'

    ${Sum_Of_Amount}    Set Variable    0
    ${VLS_PROD_POS_CUR_CSV_File_Content_LineCount}    Get Line Count    ${VLS_PROD_POS_CUR_CSV_File_Content}
    :FOR    ${Index}    IN RANGE    1    ${VLS_PROD_POS_CUR_CSV_File_Content_LineCount}
    \    ${CSV_Line}    Get Line    ${VLS_PROD_POS_CUR_CSV_File_Content}    ${Index}
    \    ${CSV_Line_List}    Split String    ${CSV_Line}    ${sDelimiter}
    \    Log    PDC_CDE_PROD_TYPE : @{CSV_Line_List}[${PDC_CDE_PROD_TYPE_Index}]
    \    Log    PDC_PID_PRODUCT_ID : @{CSV_Line_List}[${PDC_PID_PRODUCT_ID_Index}]
    \    Log    PDC_AMT_BNK_GR_NT_CMT : @{CSV_Line_List}[${PDC_AMT_BNK_GR_NT_CMT_Index}]
    \    ${PDC_CDE_PROD_TYPE_Value}    Remove String    @{CSV_Line_List}[${PDC_CDE_PROD_TYPE_Index}]    "
    \    ${PDC_PID_PRODUCT_ID_Value}    Remove String    @{CSV_Line_List}[${PDC_PID_PRODUCT_ID_Index}]    "
    \    ${PDC_AMT_BNK_GR_NT_CMT_Value}    Remove String    @{CSV_Line_List}[${PDC_AMT_BNK_GR_NT_CMT_Index}]    "
    \    ${IsEqual_PDC_CDE_PROD_TYPE}    Run Keyword And Return Status    Should Be Equal As Strings    ${PDC_CDE_PROD_TYPE_Value.strip()}    DEA
    \    ${IsEqual_PDC_PID_PRODUCT_ID}    Verify If CSV File Have Expected Value    ${Deal_List}    ${PDC_PID_PRODUCT_ID_Value}    ${True}
    \    ${Sum_Of_Amount}    Run Keyword If    ${IsEqual_PDC_CDE_PROD_TYPE}==${True} and ${IsEqual_PDC_PID_PRODUCT_ID}==${True}    Evaluate    ${Sum_Of_Amount}+${PDC_AMT_BNK_GR_NT_CMT_Value}
         ...    ELSE    Set Variable    ${Sum_Of_Amount}
    \    Log    ${Sum_Of_Amount}
    Log    Sum of Amount: ${Sum_Of_Amount}
    ${Sum_Of_Amount}    Evaluate  "%.2f" % (${Sum_Of_Amount})
    [Return]    ${Sum_Of_Amount}

Access Deal and Borrower CSV Files and Return Sum
    [Documentation]    This keyword is used to access VLS_DEAL and VLS_DEAL_BORROWERS csv files and return total count.
    ...    VLS_DEAL: Filter DEA_DTE_DEAL_CLSD by not empty and get DEA_PID_DEAL
    ...    VLS_DEAL_BORROWERS: Validate DBR_PID_DEAL
    ...    NOTE: sBus_Date format should be 2020-01-02
    ...    @author: clanding    20OCT2020    - initial create
    ...    @update: clanding    29NOV2020    - added delimiter argument
    [Arguments]    ${sDWE_Extract_Path}    ${sZone}    ${sBus_Date}    ${sDelimiter}
    
    ${Bus_Date_Converted}    Remove String    ${sBus_Date}    -
    
    ### VLS_DEAL csv file ###
    ${VLS_DEAL_CSV_File}    Run Keyword If    '${sZone}'=='ZONE3'    Set Variable    ${DNA_CCB_LIQ_FILENAME}SYD_VLS_DEAL_${Bus_Date_Converted}.csv
    ...    ELSE IF    '${sZone}'=='ZONE2'    Set Variable    ${DNA_CCB_LIQ_FILENAME}EUR_VLS_DEAL_${Bus_Date_Converted}.csv
    ${VLS_DEAL_CSV_File_Content}    OperatingSystem.Get File    ${sDWE_Extract_Path}/${DNA_CCB_LIQ_FILENAME}SYD_${Bus_Date_Converted}/${VLS_DEAL_CSV_File}
    
    ### Get Column header list - VLS_DEAL ###    
    ${VLS_DEAL_Column_List}    Split String    ${VLS_DEAL_CSV_File_Content}    ${sDelimiter}
    ${VLS_DEAL_Column_List_Count}    Get Length    ${VLS_DEAL_Column_List}

    ### Get DEA_DTE_DEAL_CLSD index ###
    :FOR    ${DEA_DTE_DEAL_CLSD_Index}    IN RANGE    ${VLS_DEAL_Column_List_Count}
    \    Log    @{VLS_DEAL_Column_List}[${DEA_DTE_DEAL_CLSD_Index}]
    \    ${Column}    Remove String    @{VLS_DEAL_Column_List}[${DEA_DTE_DEAL_CLSD_Index}]    "
    \    Exit For Loop If    '${Column}'=='DEA_DTE_DEAL_CLSD'

    ### Get DEA_PID_DEAL index ###
    :FOR    ${DEA_PID_DEAL_Index}    IN RANGE    ${VLS_DEAL_Column_List_Count}
    \    Log    @{VLS_DEAL_Column_List}[${DEA_PID_DEAL_Index}]
    \    ${Column}    Remove String    @{VLS_DEAL_Column_List}[${DEA_PID_DEAL_Index}]    "
    \    Exit For Loop If    '${Column}'=='DEA_PID_DEAL'

    ${Deal_List}    Create List
    ${VLS_DEAL_CSV_File_Content_LineCount}    Get Line Count    ${VLS_DEAL_CSV_File_Content}
    :FOR    ${Index}    IN RANGE    1    ${VLS_DEAL_CSV_File_Content_LineCount}
    \    ${CSV_Line}    Get Line    ${VLS_DEAL_CSV_File_Content}    ${Index}
    \    ${CSV_Line_List}    Split String    ${CSV_Line}    ${sDelimiter}
    \    Log    DEA_DTE_DEAL_CLSD : @{CSV_Line_List}[${DEA_DTE_DEAL_CLSD_Index}]
    \    Log    DEA_PID_DEAL : @{CSV_Line_List}[${DEA_PID_DEAL_Index}]
    \    ${DEA_DTE_DEAL_CLSD_Value}    Remove String    @{CSV_Line_List}[${DEA_DTE_DEAL_CLSD_Index}]    "
    \    ${DEA_PID_DEAL_Value}    Remove String    @{CSV_Line_List}[${DEA_PID_DEAL_Index}]    "
    \    ${IsEqual_DEA_DTE_DEAL_CLSD}    Run Keyword And Return Status    Should Be Equal As Strings    ${DEA_DTE_DEAL_CLSD_Value.strip()}    ${EMPTY}
    \    Run Keyword If    '${DEA_DTE_DEAL_CLSD_Value.strip()}'!=''    Append To List    ${Deal_List}    ${DEA_PID_DEAL_Value}
         ...    ELSE    Append To List    ${Deal_List}
    \    Log    ${Deal_List}
    Log    Deal List: ${Deal_List}

    ### VLS_DEAL_BORROWER csv file ###
    ${VLS_DEAL_BORROWER_CSV_File}    Run Keyword If    '${sZone}'=='ZONE3'    Set Variable    ${DNA_CCB_LIQ_FILENAME}SYD_VLS_DEAL_BORROWER_${Bus_Date_Converted}.csv
    ...    ELSE IF    '${sZone}'=='ZONE2'    Set Variable    ${DNA_CCB_LIQ_FILENAME}EUR_VLS_DEAL_BORROWER_${Bus_Date_Converted}.csv
    ${VLS_DEAL_BORROWER_CSV_File_Content}    OperatingSystem.Get File    ${sDWE_Extract_Path}/${DNA_CCB_LIQ_FILENAME}SYD_${Bus_Date_Converted}/${VLS_DEAL_BORROWER_CSV_File}

    ### Get Column header list - VLS_DEAL_BORROWER ###    
    ${VLS_DEAL_BORROWER_Column_List}    Split String    ${VLS_DEAL_BORROWER_CSV_File_Content}    ${sDelimiter}
    ${VLS_DEAL_BORROWER_Column_List_Count}    Get Length    ${VLS_DEAL_BORROWER_Column_List}
    
    ### Get Column header list - VLS_DEAL_BORROWER ###    
    ${VLS_DEAL_BORROWER_Column_List}    Split String    ${VLS_DEAL_BORROWER_CSV_File_Content}    ${sDelimiter}
    ${VLS_DEAL_BORROWER_Column_List_Count}    Get Length    ${VLS_DEAL_BORROWER_Column_List}

    ### Get DBR_PID_DEAL index ###
    :FOR    ${DBR_PID_DEAL_Index}    IN RANGE    ${VLS_DEAL_BORROWER_Column_List_Count}
    \    Log    @{VLS_DEAL_BORROWER_Column_List}[${DBR_PID_DEAL_Index}]
    \    ${Column}    Remove String    @{VLS_DEAL_BORROWER_Column_List}[${DBR_PID_DEAL_Index}]    "
    \    Exit For Loop If    '${Column}'=='DBR_PID_DEAL'

    ${Total_Count}    Set Variable    0
    ${VLS_DEAL_BORROWER_CSV_File_Content_LineCount}    Get Line Count    ${VLS_DEAL_BORROWER_CSV_File_Content}
    :FOR    ${Index}    IN RANGE    1    ${VLS_DEAL_BORROWER_CSV_File_Content_LineCount}
    \    ${CSV_Line}    Get Line    ${VLS_DEAL_BORROWER_CSV_File_Content}    ${Index}
    \    ${CSV_Line_List}    Split String    ${CSV_Line}    ${sDelimiter}
    \    Log    DBR_PID_DEAL : @{CSV_Line_List}[${DBR_PID_DEAL_Index}]
    \    ${DBR_PID_DEAL_Value}    Remove String    @{CSV_Line_List}[${DBR_PID_DEAL_Index}]    "
    \    ${IsEqual_DBR_PID_DEAL}    Verify If CSV File Have Expected Value    ${Deal_List}    ${DBR_PID_DEAL_Value.strip()}    ${True}
    \    ${Total_Count}    Run Keyword If    ${IsEqual_DBR_PID_DEAL}==${True}    Evaluate    ${Total_Count}+1
         ...    ELSE    Set Variable    ${Total_Count}
    \    Log    ${Total_Count}
    Log    Sum of Amount: ${Total_Count}
    [Return]    ${Total_Count}













