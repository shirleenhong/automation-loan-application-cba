*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
#Test Teardown    Test Suite Tear Down

*** Variables ***
${rowid}    1
${SCENARIO}    2

*** Test Cases ***
Create Comprehensive Repricing - SERV08C
    [Tags]    07 - User is able to create a Comprehensive Reprcing for SYNDICATED deal using PRINCIPAL - SERV08C                                                                                                                                                                                                                                                                            
    Mx Execute Template With Multiple Data    Create Comprehensive Repricing for Syndicated Deal   ${ExcelPath}    ${rowid}    SERV08_ComprehensiveRepricing
    Log to Console    Pause Execution - Run Daily EOD
