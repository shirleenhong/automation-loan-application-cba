*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    1    

*** Test Cases ***
Resync a Flex Schedule - MTAM16
    [Tags]    Resync a Flex Schedule - MTAM16
    Mx Execute Template With Multiple Data    Resync a Flex Schedule    ${ExcelPath}    ${rowid}    MTAM16_ResyncAFlexSchedule