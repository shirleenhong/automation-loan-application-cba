*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${SCENARIO}

*** Keywords ***
### Sample ###
Commitment Fee Payment for D00000454
    [Documentation]    This keyword collects the commitment fee payment of the facility
    ...    @author:fmamaril    03SEP2019    Intial Create
    [Arguments]    ${ExcelPath}

    ${Date}    Get System Date
    
    ### Navigate to Commitment Fee Notebook ###
    Search Existing Deal    &{ExcelPath}[Deal_Name]    
