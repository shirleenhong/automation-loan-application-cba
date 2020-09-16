*** Settings ***
Resource    ../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Filter in EOD Control and Status Enquiry Page
    [Documentation]    This keyword is used to input values in the EOD Control and Status Enquiry page elements and click Filter button.
    ...    @author: clanding    10SEP2020    - initial create
    [Arguments]    ${sProcess_Status}    ${sActive_Inactive_Flag}    ${sExec_Ord_Operator}=None    ${sExec_Ord}=None
    ...    ${iMicroflow_Called}=None    ${iProcess_Desc}=None

    Run Keyword If    '${sProcess_Status}'!=''    Mx Input Text    ${Essence_EODControlAndStatusEnquiry_ProcessStatus_ComboBox}    ${sProcess_Status}
    ...    ELSE    Log    No data provided for Process Status.
    
    Run Keyword If    '${sActive_Inactive_Flag}'!=''    Mx Input Text    ${Essence_EODControlAndStatusEnquiry_ActiveInactiveFlag_ComboBox}    ${sActive_Inactive_Flag}
    ...    ELSE    Log    No data provided for Process Status.

    Run Keyword If    '${sExec_Ord_Operator}'!='None'    Mx Input Text    ${Essence_EODControlAndStatusEnquiry_ExecutionOrderOperator_ComboBox}    ${sActive_Inactive_Flag}
    ...    ELSE    Log    No data provided for Execution Order dropdown.
    
    Run Keyword If    '${sExec_Ord_Operator}'!='None'    Mx Input Text    ${Essence_EODControlAndStatusEnquiry_ExecutionOrder_TextBox}    ${sExec_Ord}
    ...    ELSE    Log    No data provided for Execution Order textbox.
    
    Run Keyword If    '${iMicroflow_Called}'!='None'    Mx Input Text    ${Essence_EODControlAndStatusEnquiry_MicroflowCalled_TextBox}    ${iMicroflow_Called}
    ...    ELSE    Log    No data provided for Microflow Called textbox.

    Run Keyword If    '${iProcess_Desc}'!='None'    Mx Input Text    ${Essence_EODControlAndStatusEnquiry_ProcessDescription_TextBox}    ${iProcess_Desc}
    ...    ELSE    Log    No data provided for Process Description textbox.
    
    Click Element    ${Essence_EODControlAndStatusEnquiry_Filter_Button}
    Wait Until Browser Ready State
    Wait Until Element Is Enabled    ${Essence_EODControlAndStatusEnquiry_Filter_Button}
    Mx Scroll Element Into View    ${Essence_EODControlAndStatusEnquiry_ProcessStatus_ComboBox}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/GL/Essence_EODControlAndStatusEnquiryPage-{index}.png
    
Validate Execution Order if Correct
    [Documentation]    This keyword is used to get Execution Order in the table using Process Description value.
    ...    Then compare table and database value for Execution Order.
    ...    @author: clanding    10SEP2020    - initial create
    [Arguments]    ${sProcess_Description}    ${iDB_Exec_Order}

    ${Table_Execution_Order}    Get Table Value Containing Row Value in Essence    ${Essence_EODControlAndStatusEnquiry_TableHeader_Locator}    ${Essence_EODControlAndStatusEnquiry_TableRow_Locator}
    ...    ${HEADER_PROCESS_DESCRIPTION}    ${sProcess_Description}    ${HEADER_EXECUTION_ORDER}
    Compare Two Strings    ${iDB_Exec_Order}    ${Table_Execution_Order}

Connect to Essence Database and Get Execution Order
    [Documentation]    This keyword is used to connect to Essence database to get execution order.  
    ...    @author: clanding    10AUG2020    - initial create
    [Arguments]    ${sProcess_Description}    ${sZoneAndCode}
    
    ${ESS_WASADMIN_SCHEMA}    Run Keyword If    '${sZoneAndCode}'=='${LIQ_ZONEANDCODE_AU}'    Set Variable    ${ESS_AUWASADMIN_SCHEMA}
    ...    ELSE IF    '${sZoneAndCode}'=='${LIQ_ZONEANDCODE_EU}'    Set Variable    ${ESS_EUWASADMIN_SCHEMA}
    ...    ELSE    FAIL    '${sZoneAndCode}' is NOT yet configured.
    
    ${Query_GetExecOrder}    Catenate    SELECT UBORDER FROM ${ESS_WASADMIN_SCHEMA}.CLOSEOFF WHERE DESCRIPTION = '${sProcess_Description}' AND ACTIVE = 'Y'
    ${Query_Results_List}    Connect to Essence Database and Execute Query and Return List    ${Query_GetExecOrder}
    ${Query_Results_List}    Get From List    ${Query_Results_List}    0
    ${DB_Execution_Order}    Get From List    ${Query_Results_List}    0
    
    [Return]    ${DB_Execution_Order}
