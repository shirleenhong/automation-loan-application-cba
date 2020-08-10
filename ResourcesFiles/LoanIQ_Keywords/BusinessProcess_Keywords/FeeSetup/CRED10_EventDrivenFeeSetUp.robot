*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup Event Driven and Collect Agency Fees
    [Documentation]    This keyword is for adding Event Driven Fee and Collect Agency Fee in Event Fees Template under Deal Notebook's Admin/Event Fees tab.
    ...    @author: mgaling
    [Arguments]    ${ExcelPath}
    
    #Event Driven Fee Set-uo (Free Form Event)
    Add Event Fees in Deal Notebook    &{ExcelPath}[EventFee1]    &{ExcelPath}[EventFee_GlobalCurrent1]    Formula
    #Collect Agency Fees (Arranger Fee)
    Add Event Fees in Deal Notebook    &{ExcelPath}[EventFee2]    &{ExcelPath}[EventFee_GlobalCurrent2]    Formula

Setup Deal Event Fees
    [Documentation]    This keyword is for adding Event Fees from the Deal Notebook's Admin/Event Fees tab.
    ...    @author: bernchua
    ...    @update: fmamaril    Added EventFee_DistributeToAllLenders argument for the UAT Deals
    ...    @update: ritragel    30APR2019    Removed login since it is upon the creation of Deal
    [Arguments]    ${ExcelPath}
    Add Event Fees in Deal Notebook    &{ExcelPath}[EventFee]    &{ExcelPath}[EventFee_Amount]    &{ExcelPath}[EventFee_Type]
    
NonAgent-HostBank Syndicated Deal - Setup Event Fees
    [Documentation]    This keyword is for adding Event Fees from the Deal Notebook's Admin/Event Fees tab.
    ...    @author: bernchua
    [Arguments]    ${ExcelPath}
    Add Event Fees in Deal Notebook    &{ExcelPath}[EventFee1]    &{ExcelPath}[EventFee_Amount1]    &{ExcelPath}[EventFee_Type2]
    
Setup Event Fee For Syndicated Deal With Secondary Sale
    [Documentation]    This keyword is for adding Event Fees from the Deal Notebook's Admin/Event Fees tab.
    ...    @author: bernchua
    [Arguments]    ${ExcelPath}
    Add Event Fees in Deal Notebook    &{ExcelPath}[EventFee1]    &{ExcelPath}[EventFee_Amount1]    &{ExcelPath}[EventFee_Type2]
    Add Event Fees in Deal Notebook    &{ExcelPath}[EventFee2]    &{ExcelPath}[EventFee_Amount2]    &{ExcelPath}[EventFee_Type1]
    Add Event Fees in Deal Notebook    &{ExcelPath}[EventFee3]    &{ExcelPath}[EventFee_Amount3]    &{ExcelPath}[EventFee_Type3]    OFF
    
Setup Deal Event Fees for Agency One Deal
    [Documentation]    This keyword is for adding Event Fees from the Deal Notebook's Admin/Event Fees tab.
    ...    @author: fmamaril
    [Arguments]    ${ExcelPath}
    Add Event Fees in Deal Notebook for Agency One Deal    &{ExcelPath}[EventFee1]    &{ExcelPath}[EventFee_Amount1]    &{ExcelPath}[EventFee_Type1]    &{ExcelPath}[EventFee_DistributeToAllLenders]   