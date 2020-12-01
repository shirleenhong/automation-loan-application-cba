*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Verify that No Notification Message Generated for Data Net Assurance Extract
    [Documentation]    This keyword is used to login to ffc and validate Data Net Assurance DAT file is not in FFC.
    ...    @author: clanding    30NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Login to MCH UI

    Go to Dashboard and Click Source API Name    ${NOTIFICATIONSOURCEJMS_SOURCENAME}    ${DWE_NOTIFICATION_INSTANCE}
    Filter by Reference Name and Validate Text in Response Message    ${HEADER_QUEUENAME}    ${RESTNOTIFICATIONDEST}    ${ExcelPath}[DAT_File]    ${False}

    Logout to MCH UI and Close Browser