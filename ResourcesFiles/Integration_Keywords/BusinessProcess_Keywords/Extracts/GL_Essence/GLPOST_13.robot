*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate Essence EOD Control and System Date have Correct Entity
    [Documentation]    This keyword is used to login to Essence and go to EOD Control & Status Enquiry and validate if Execution Order for
    ...    GL Transaction Extract Process and Clear Daily Transactions are correct against DB values.
    ...    @author: clanding    10SEP2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Change FBE Zone    &{ExcelPath}[ZoneAndCode]    &{ExcelPath}[Zone]    &{ExcelPath}[Branch]
    Search Process in Essence    ${EOD_CONTROL_AND_STATUS_ENQUIRY}
    Filter in EOD Control and Status Enquiry Page    &{ExcelPath}[Process_Status]    &{ExcelPath}[Active_Inactive_Flag]
    ${DB_Execution_Order_CLEAR_DAILY_TRANS}    Connect to Essence Database and Get Execution Order    ${PROCESSDESCRIPTION_CLEAR_DAILY_TRANS}    &{ExcelPath}[ZoneAndCode]
    Validate Execution Order if Correct    ${PROCESSDESCRIPTION_CLEAR_DAILY_TRANS}    ${DB_Execution_Order_CLEAR_DAILY_TRANS}
    ${DB_Execution_Order_GL_TRANS_EXTRACT_PROCESS}    Connect to Essence Database and Get Execution Order    ${PROCESSDESCRIPTION_GL_TRANS_EXTRACT_BATCH_PROCESS}    &{ExcelPath}[ZoneAndCode]
    Validate Execution Order if Correct    ${PROCESSDESCRIPTION_GL_TRANS_EXTRACT_PROCESS}    ${DB_Execution_Order_GL_TRANS_EXTRACT_PROCESS}
    Exit Displayed Process
