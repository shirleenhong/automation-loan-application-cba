*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Setup Caps and Floors
    [Documentation]    This keyword is used to setup caps and floors at outstanding and facility level.
    ...    @author: hstone    03JUN2020     - Initial Create
    [Arguments]    ${ExcelPath}
    
    ### Inputter: Facility Caps and Floors Setup ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Facility Caps and Floors Setup Process and Validation ###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Go to Facility Notebook Update Mode
    Navigate to Facility Interest Pricing Option Details    &{ExcelPath}[Pricing_Option]
    Setup Facility All-In Rate Cap    &{ExcelPath}[All_In_Rate_Cap]    &{ExcelPath}[Cap_Rate_Change_Method]    &{ExcelPath}[Cap_Start_Date]    &{ExcelPath}[Cap_End_Date]
    Setup Facility All-In Rate Floor    &{ExcelPath}[All_In_Rate_Floor]    &{ExcelPath}[Floor_Rate_Change_Method]    &{ExcelPath}[Floor_Start_Date]    &{ExcelPath}[Floor_End_Date]
    Confirm Facility Interest Pricing Options Settings
    Save Facility Notebook Transaction
    Navigate to Facility Interest Pricing Option Details    &{ExcelPath}[Pricing_Option]
    Validate Facility Cap Settings    &{ExcelPath}[All_In_Rate_Cap]    &{ExcelPath}[Cap_Rate_Change_Method]    &{ExcelPath}[Cap_Start_Date]    &{ExcelPath}[Cap_End_Date]    &{ExcelPath}[Pricing_Option]
    Validate Facility Floor Settings    &{ExcelPath}[All_In_Rate_Floor]    &{ExcelPath}[Floor_Rate_Change_Method]    &{ExcelPath}[Floor_Start_Date]    &{ExcelPath}[Floor_End_Date]    &{ExcelPath}[Pricing_Option]
    Confirm Facility Interest Pricing Options Settings
    Validate Facility
    Close Facility Navigator Window
    Navigate to Deal Notebook Workflow and Proceed With Transaction    Send To Approval

    ### Approver: Deal Approval and Close ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    Deals    Awaiting Approval    Deal    &{ExcelPath}[Deal_Name]
    Approve the Deal    &{ExcelPath}[Deal_Approval_Date]
    Close the Deal    &{ExcelPath}[Deal_Close_Date]
    Close All Windows on LIQ

    ### Login Back to Inputter ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}