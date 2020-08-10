*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

***Keyword***

Enable MassSale
    [Documentation]    This keyword is used to Enable MassSale in Deal Notebook
    ...    @ author :Archana
    [Arguments]    ${Excelpath}
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Deal Notebook###
    Open Existing Deal    &{ExcelPath}[Deal_Name]        
    Enable MassSale on DealNotebook
    Close All Windows on LIQ 