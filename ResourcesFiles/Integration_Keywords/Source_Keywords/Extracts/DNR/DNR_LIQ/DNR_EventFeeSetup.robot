*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Setup Deal Event Fees for DNR
    [Documentation]    This keyword is for adding Event Fees from the Deal Notebook's Admin/Event Fees tab.
    ...    @author: songchan    - initial create
    [Arguments]    ${ExcelPath}
    Add Event Fees in Deal Notebook    &{ExcelPath}[EventFee]    &{ExcelPath}[EventFee_Amount]    &{ExcelPath}[EventFee_Type]