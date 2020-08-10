*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1
${SCENARIO}    1

*** Test Cases ***
Adjust Resync Settings for a Flex Schedule - MTAM17
    [Tags]    Adjust Resync Settings for a Flex Schedule - MTAM17
    Mx Execute Template With Multiple Data    Adjust Resync Settings for a Flex Schedule    ${ExcelPath}    ${rowid}    MTAM17_AdjResyncSetForFlexSched