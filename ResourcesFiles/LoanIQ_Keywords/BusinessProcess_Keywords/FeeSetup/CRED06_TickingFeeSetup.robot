*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup Ticking Fee
    [Documentation]    This high-level keyword sets up the Ticking Fee from the Deal Notebook.
    ...    @author: bernchua
    [Arguments]    ${ExcelPath}
    ${EffectiveDate}    Get Back Dated Current Date    &{ExcelPath}[NumberOfDays_ToBackDate]
    Set Ticking Fee Definition Details    &{ExcelPath}[TickingFee_XRate]    ${EffectiveDate}    &{ExcelPath}[Deal_ProposedCmt]    &{ExcelPath}[TickingFee_RateBasis]    &{ExcelPath}[Deal_Currency]
    ...    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_SGName]    &{ExcelPath}[Borrower_SGAlias]    &{ExcelPath}[Borrower_Location]            
    Validate Ticking Fee 'to Today' Projected Amount
    Validate Ticking Fee 'to Proj Deal Close Date' Projected Amount
    Complete Ticking Fee Definition Setup
