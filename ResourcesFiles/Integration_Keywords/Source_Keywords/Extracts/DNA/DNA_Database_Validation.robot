*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Get Sum New Funding Amount from LIQ Database
    [Documentation]    This keyword is used to get SUM_NEW_FUNDING_AMOUNT value from LIQ database and return.
    ...    NOTE: sPosting_Date format should be %d-%b-%Y (21-MAY-2020)
    ...    @author: clanding    16OCT2020    - initial create
    [Arguments]    ${sPosting_Date}    ${sCurrency}
    
    ${Query}    Catenate    SELECT SUM(GLE_AMT_ENTRY) FROM ${LIQDBSCHEMA}.VLS_GL_ENTRY WHERE GLE_DTE_POSTING ='${sPosting_Date}' AND GLE_CDE_BUS_TRAN= 'LNDR'
    ...    AND GLE_CDE_ACCTG_OPER= 'DR' AND GLE_CDE_CURRENCY = '${sCurrency}'
    ${Query_Result}    Connect to LIQ Database and Return Results    ${Query}
    ${Query_Result_List}    Convert SQL Result to List and Return    ${Query_Result}
    ${Result_Count}    Get Length    ${Query_Result_List}
    ${Result}    Run Keyword If    '${Result_Count}'!='0'    Get From List    ${Query_Result_List}    0
    ...    ELSE    Set Variable    None
    [Return]    ${Result}

Get Sum of Accrued Fees from LIQ Database
    [Documentation]    This keyword is used to get SUM_OF_ACCRUED_FEES value from LIQ database and return.
    ...    @author: clanding    16OCT2020    - initial create
    [Arguments]    ${sBranch_Code}    ${sCurrency}
    
    ${Query}    Catenate    SELECT SUM(BSG_AMT_PRIOR_EOD) FROM ${LIQDBSCHEMA}.VLS_BAL_SUBLEDGER WHERE BSG_CDE_GL_SHTNAME = 'FEERC' AND BSG_CDE_BRANCH IN (${sBranch_Code})
    ...    AND BSG_CDE_CURRENCY = '${sCurrency}'
    ${Query_Result}    Connect to LIQ Database and Return Results    ${Query}
    ${Query_Result_List}    Convert SQL Result to List and Return    ${Query_Result}
    ${Result_Count}    Get Length    ${Query_Result_List}
    ${Result}    Run Keyword If    '${Result_Count}'!='0'    Get From List    ${Query_Result_List}    0
    ...    ELSE    Set Variable    None
    [Return]    ${Result}
    
Get Sum of Accrued Interest from LIQ Database
    [Documentation]    This keyword is used to get SUM_OF_ACCRUED_INTEREST value from LIQ database and return.
    ...    @author: clanding    16OCT2020    - initial create
    [Arguments]    ${sBranch_Code}    ${sCurrency}
    
    ${Query}    Catenate    SELECT SUM(BSG_AMT_PRIOR_EOD) FROM ${LIQDBSCHEMA}.VLS_BAL_SUBLEDGER WHERE BSG_CDE_GL_SHTNAME = 'INTRC' AND BSG_CDE_BRANCH IN (${sBranch_Code})
    ...    AND BSG_CDE_CURRENCY = '${sCurrency}'
    ${Query_Result}    Connect to LIQ Database and Return Results    ${Query}
    ${Query_Result_List}    Convert SQL Result to List and Return    ${Query_Result}
    ${Result_Count}    Get Length    ${Query_Result_List}
    ${Result}    Run Keyword If    '${Result_Count}'!='0'    Get From List    ${Query_Result_List}    0
    ...    ELSE    Set Variable    None
    [Return]    ${Result}

Get Sum of Deal Limits Gross from LIQ Database
    [Documentation]    This keyword is used to get SUM_OF_HB_DEAL_LIMITS_GROSS value from LIQ database and return.
    ...    @author: clanding    16OCT2020    - initial create
    [Arguments]    ${sBranch_Code}    ${sCurrency}
    
    ${Query}    Catenate    SELECT SUM(PDC_AMT_BNK_GR_CMT) FROM ${LIQDBSCHEMA}.VLS_PROD_POS_CUR c JOIN ${LIQDBSCHEMA}.VLS_DEAL a on  a.DEA_PID_DEAL=c.PDC_PID_PRODUCT_ID
    ...    WHERE PDC_CDE_PROD_TYPE ='DEA' AND DEA_CDE_BRANCH IN (${sBranch_Code}) AND DEA_CDE_ORIG_CCY = '${sCurrency}'
    ${Query_Result}    Connect to LIQ Database and Return Results    ${Query}
    ${Query_Result_List}    Convert SQL Result to List and Return    ${Query_Result}
    ${Result_Count}    Get Length    ${Query_Result_List}
    ${Result}    Run Keyword If    '${Result_Count}'!='0'    Get From List    ${Query_Result_List}    0
    ...    ELSE    Set Variable    None
    [Return]    ${Result}

Get Sum of Deal Limits Net from LIQ Database
    [Documentation]    This keyword is used to get SUM_OF_HB_DEAL_LIMITS_NET value from LIQ database and return.
    ...    @author: clanding    16OCT2020    - initial create
    [Arguments]    ${sBranch_Code}    ${sCurrency}
    
    ${Query}    Catenate    SELECT SUM(PDC_AMT_BNK_NT_CMT) FROM ${LIQDBSCHEMA}.VLS_PROD_POS_CUR c JOIN ${LIQDBSCHEMA}.VLS_DEAL a on  a.DEA_PID_DEAL=c.PDC_PID_PRODUCT_ID
    ...    WHERE PDC_CDE_PROD_TYPE ='DEA' AND DEA_CDE_BRANCH IN (${sBranch_Code}) AND DEA_CDE_ORIG_CCY = '${sCurrency}'
    ${Query_Result}    Connect to LIQ Database and Return Results    ${Query}
    ${Query_Result_List}    Convert SQL Result to List and Return    ${Query_Result}
    ${Result_Count}    Get Length    ${Query_Result_List}
    ${Result}    Run Keyword If    '${Result_Count}'!='0'    Get From List    ${Query_Result_List}    0
    ...    ELSE    Set Variable    None
    [Return]    ${Result}

Get Sum of Facility Limits Gross from LIQ Database
    [Documentation]    This keyword is used to get SUM_OF_HB_FAC_LIMITS_GROSS value from LIQ database and return.
    ...    @author: clanding    16OCT2020    - initial create
    [Arguments]    ${sBranch_Code}    ${sCurrency}
    
    ${Query}    Catenate    SELECT SUM(PDC_AMT_BNK_GR_CMT) FROM ${LIQDBSCHEMA}.VLS_PROD_POS_CUR C JOIN ${LIQDBSCHEMA}.VLS_FACILITY A ON A.FAC_PID_FACILITY=C.PDC_PID_PRODUCT_ID JOIN ${LIQDBSCHEMA}.VRP_FAC_STATUS B ON
    ...    B.FSS_PID_FACILITY=A.FAC_PID_FACILITY WHERE C.PDC_CDE_PROD_TYPE = 'FAC' AND A.FAC_CDE_BRANCH IN (${sBranch_Code}) AND A.FAC_CDE_CURRENCY = '${sCurrency}'
    ${Query_Result}    Connect to LIQ Database and Return Results    ${Query}
    ${Query_Result_List}    Convert SQL Result to List and Return    ${Query_Result}
    ${Result_Count}    Get Length    ${Query_Result_List}
    ${Result}    Run Keyword If    '${Result_Count}'!='0'    Get From List    ${Query_Result_List}    0
    ...    ELSE    Set Variable    None
    [Return]    ${Result}

Get Sum of Facility Limits Net from LIQ Database
    [Documentation]    This keyword is used to get SUM_OF_HB_FAC_LIMITS_NET value from LIQ database and return.
    ...    @author: clanding    16OCT2020    - initial create
    [Arguments]    ${sBranch_Code}    ${sCurrency}
    
    ${Query}    Catenate    SELECT SUM(PDC_AMT_BNK_NT_CMT) FROM ${LIQDBSCHEMA}.VLS_PROD_POS_CUR C JOIN ${LIQDBSCHEMA}.VLS_FACILITY A ON A.FAC_PID_FACILITY=C.PDC_PID_PRODUCT_ID JOIN ${LIQDBSCHEMA}.VRP_FAC_STATUS B ON
    ...    B.FSS_PID_FACILITY=A.FAC_PID_FACILITY WHERE C.PDC_CDE_PROD_TYPE = 'FAC' AND A.FAC_CDE_BRANCH IN (${sBranch_Code}) AND A.FAC_CDE_CURRENCY = '${sCurrency}'
    ${Query_Result}    Connect to LIQ Database and Return Results    ${Query}
    ${Query_Result_List}    Convert SQL Result to List and Return    ${Query_Result}
    ${Result_Count}    Get Length    ${Query_Result_List}
    ${Result}    Run Keyword If    '${Result_Count}'!='0'    Get From List    ${Query_Result_List}    0
    ...    ELSE    Set Variable    None
    [Return]    ${Result}

Get Sum of Principal Balances from LIQ Database
    [Documentation]    This keyword is used to get SUM_OF_PRINCIPAL_BALANCES value from LIQ database and return.
    ...    @author: clanding    16OCT2020    - initial create
    [Arguments]    ${sBranch_Code}    ${sCurrency}
    
    ${Query}    Catenate    SELECT SUM(BSG_AMT_PRIOR_EOD) FROM ${LIQDBSCHEMA}.VLS_BAL_SUBLEDGER WHERE BSG_CDE_GL_SHTNAME = 'PRINC' AND BSG_CDE_BRANCH IN (${sBranch_Code})
    ...    AND BSG_CDE_CURRENCY = '${sCurrency}'
    ${Query_Result}    Connect to LIQ Database and Return Results    ${Query}
    ${Query_Result_List}    Convert SQL Result to List and Return    ${Query_Result}
    ${Result_Count}    Get Length    ${Query_Result_List}
    ${Result}    Run Keyword If    '${Result_Count}'!='0'    Get From List    ${Query_Result_List}    0
    ...    ELSE    Set Variable    None
    [Return]    ${Result}

Get Sum of Transaction Amount from LIQ Database
    [Documentation]    This keyword is used to get SUM_TRANSACTION_AMOUNT value from LIQ database and return.
    ...    @author: clanding    16OCT2020    - initial create
    [Arguments]    ${sBranch_Code}    ${sCurrency}
    
    ${Query}    Catenate    SELECT SUM(GLE_AMT_ENTRY), MAX(GLE_DTE_POSTING) FROM ${LIQDBSCHEMA}.VLS_GL_ENTRY 
    ...    WHERE GLE_DTE_POSTING IN (SELECT MAX(GLE_DTE_POSTING) FROM ${LIQDBSCHEMA}.VLS_GL_ENTRY WHERE GLE_CDE_CURRENCY='${sCurrency}' AND GLE_CDE_BRANCH IN (${sBranch_Code})) 
    ...    AND GLE_CDE_BRANCH IN (${sBranch_Code}) AND GLE_CDE_CURRENCY = '${sCurrency}'
    ${Query_Result}    Connect to LIQ Database and Return Results    ${Query}
    ${Query_Result_List}    Convert SQL Result to List and Return    ${Query_Result}
    ${Result_Count}    Get Length    ${Query_Result_List}
    ${Result}    Run Keyword If    '${Result_Count}'!='0'    Get From List    ${Query_Result_List}    0
    ...    ELSE    Set Variable    None
    [Return]    ${Result}

Get Total Active Deal Borrowers from LIQ Database
    [Documentation]    This keyword is used to get TOTAL_ACTIVE_DEAL_BORROWERS value from LIQ database and return.
    ...    NOTE: sExtract_Date format should be %d-%b-%Y (21-MAY-2020)
    ...    @author: clanding    16OCT2020    - initial create
    [Arguments]    ${sBranch_Code}    ${sExtract_Date}
    
    ${Query}    Catenate    SELECT COUNT(*) FROM ${LIQDBSCHEMA}.VLS_DEAL_BORROWER JOIN  ${LIQDBSCHEMA}.VLS_DEAL ON ${LIQDBSCHEMA}.VLS_DEAL_BORROWER.DBR_PID_DEAL = ${LIQDBSCHEMA}.VLS_DEAL.DEA_PID_DEAL
    ...    WHERE DEA_IND_ACTIVE='Y' AND DEA_DTE_DEAL_CLSD <= '${sExtract_Date}' AND DEA_DTE_TERM_EFF IS NULL AND DEA_DTE_CANCEL_EFF IS NULL AND DEA_CDE_BRANCH IN (${sBranch_Code})
    ${Query_Result}    Connect to LIQ Database and Return Results    ${Query}
    ${Query_Result_List}    Convert SQL Result to List and Return    ${Query_Result}
    ${Result_Count}    Get Length    ${Query_Result_List}
    ${Result}    Run Keyword If    '${Result_Count}'!='0'    Get From List    ${Query_Result_List}    0
    ...    ELSE    Set Variable    None
    [Return]    ${Result}

Get Total Active Deal Count from LIQ Database
    [Documentation]    This keyword is used to get TOTAL_ACTIVE_DEAL_COUNT value from LIQ database and return.
    ...    NOTE: sExtract_Date format should be %d-%b-%Y (21-MAY-2020)
    ...    @author: clanding    16OCT2020    - initial create
    [Arguments]    ${sBranch_Code}    ${sExtract_Date}
    
    ${Query}    Catenate    SELECT COUNT(*) FROM ${LIQDBSCHEMA}.VLS_DEAL WHERE DEA_IND_ACTIVE='Y' AND DEA_DTE_DEAL_CLSD <= '${sExtract_Date}' AND DEA_DTE_TERM_EFF IS NULL 
    ...    AND DEA_DTE_CANCEL_EFF IS NULL AND DEA_CDE_BRANCH IN (${sBranch_Code})
    ${Query_Result}    Connect to LIQ Database and Return Results    ${Query}
    ${Query_Result_List}    Convert SQL Result to List and Return    ${Query_Result}
    ${Result_Count}    Get Length    ${Query_Result_List}
    ${Result}    Run Keyword If    '${Result_Count}'!='0'    Get From List    ${Query_Result_List}    0
    ...    ELSE    Set Variable    None
    [Return]    ${Result}

Get Total Active Facility Borrowers from LIQ Database
    [Documentation]    This keyword is used to get TOTAL_ACTIVE_FAC_BORROWERS value from LIQ database and return.
    ...    @author: clanding    16OCT2020    - initial create
    [Arguments]    ${sBranch_Code}
    
    ${Query}    Catenate    SELECT COUNT(*) FROM ${LIQDBSCHEMA}.VLS_FAC_BORR_DETL A JOIN ${LIQDBSCHEMA}.VRP_FAC_STATUS B ON A.FBD_PID_FACILITY=B.FSS_PID_FACILITY JOIN ${LIQDBSCHEMA}.VLS_FACILITY C ON A.FBD_PID_FACILITY=C.FAC_PID_FACILITY
    ...    WHERE FSS_DSC_STATUS='ACTIVE' AND FBD_IND_ACTIVE = 'Y' AND FAC_CDE_BRANCH IN (${sBranch_Code})
    ${Query_Result}    Connect to LIQ Database and Return Results    ${Query}
    ${Query_Result_List}    Convert SQL Result to List and Return    ${Query_Result}
    ${Result_Count}    Get Length    ${Query_Result_List}
    ${Result}    Run Keyword If    '${Result_Count}'!='0'    Get From List    ${Query_Result_List}    0
    ...    ELSE    Set Variable    None
    [Return]    ${Result}

Get Total Active Facility Count from LIQ Database
    [Documentation]    This keyword is used to get TOTAL_ACTIVE_FAC_COUNT value from LIQ database and return.
    ...    @author: clanding    16OCT2020    - initial create
    [Arguments]    ${sBranch_Code}
    
    ${Query}    Catenate    SELECT COUNT(*) FROM ${LIQDBSCHEMA}.VLS_FACILITY JOIN ${LIQDBSCHEMA}.VRP_FAC_STATUS ON ${LIQDBSCHEMA}.VRP_FAC_STATUS.FSS_PID_FACILITY=${LIQDBSCHEMA}.VLS_FACILITY.FAC_PID_FACILITY
    ...    WHERE FSS_DSC_STATUS='ACTIVE' AND FAC_CDE_BRANCH IN (${sBranch_Code})
    ${Query_Result}    Connect to LIQ Database and Return Results    ${Query}
    ${Query_Result_List}    Convert SQL Result to List and Return    ${Query_Result}
    ${Result_Count}    Get Length    ${Query_Result_List}
    ${Result}    Run Keyword If    '${Result_Count}'!='0'    Get From List    ${Query_Result_List}    0
    ...    ELSE    Set Variable    None
    [Return]    ${Result}

Get Total Active OST Borrowers from LIQ Database
    [Documentation]    This keyword is used to get TOTAL_ACTIVE_OST_BORROWERS value from LIQ database and return.
    ...    @author: clanding    16OCT2020    - initial create
    [Arguments]    ${sBranch_Code}
    
    ${Query}    Catenate    SELECT COUNT(*) FROM ${LIQDBSCHEMA}.VLS_OUTSTANDING A JOIN ${LIQDBSCHEMA}.VLS_FAC_BORR_DETL B ON A.OST_PID_FACILITY=B.FBD_PID_FACILITY JOIN ${LIQDBSCHEMA}.VLS_FACILITY C ON A.OST_PID_FACILITY=C.FAC_PID_FACILITY
    ...    WHERE OST_CDE_OB_ST_CTG = 'ACTUA' AND FAC_CDE_BRANCH IN (${sBranch_Code})
    ${Query_Result}    Connect to LIQ Database and Return Results    ${Query}
    ${Query_Result_List}    Convert SQL Result to List and Return    ${Query_Result}
    ${Result_Count}    Get Length    ${Query_Result_List}
    ${Result}    Run Keyword If    '${Result_Count}'!='0'    Get From List    ${Query_Result_List}    0
    ...    ELSE    Set Variable    None
    [Return]    ${Result}

Get Total Active OST Count from LIQ Database
    [Documentation]    This keyword is used to get TOTAL_ACTIVE_OST_COUNT value from LIQ database and return.
    ...    @author: clanding    16OCT2020    - initial create
    [Arguments]    ${sBranch_Code}
    
    ${Query}    Catenate    SELECT COUNT(*) FROM ${LIQDBSCHEMA}.VLS_OUTSTANDING A JOIN ${LIQDBSCHEMA}.VLS_DEAL B ON A.OST_PID_DEAL=B.DEA_PID_DEAL
    ...    WHERE OST_CDE_OB_ST_CTG = 'ACTUA' AND DEA_CDE_BRANCH IN (${sBranch_Code})
    ${Query_Result}    Connect to LIQ Database and Return Results    ${Query}
    ${Query_Result_List}    Convert SQL Result to List and Return    ${Query_Result}
    ${Result_Count}    Get Length    ${Query_Result_List}
    ${Result}    Run Keyword If    '${Result_Count}'!='0'    Get From List    ${Query_Result_List}    0
    ...    ELSE    Set Variable    None
    [Return]    ${Result}








