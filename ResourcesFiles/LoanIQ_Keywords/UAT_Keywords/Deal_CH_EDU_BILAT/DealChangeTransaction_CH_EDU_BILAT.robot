*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Update Leverage Ratio for CH EDu Bilateral Deal
    [Documentation]    This keyword is used to peform deal change transaction for updating deal leverage ration 
    ...    @author:    dahijara    07JAN2021    initial create
    ...    @update:    dahijara    29JAN2021    Updated rovw value in getting deal name.
    [Arguments]    ${ExcelPath}

    ### Read Excel Data ###
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1

    ### LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Deal Notebook ###
    Search for Deal    ${Deal_Name}
    Navigate to Deal Ratios/Conds Tab
    ${OldRatioValue}    Get Existing Deal Ratio    &{ExcelPath}[Deal_RatioType]

    ### Deal Change Transaction Notebook ###
    Navigate to Deal Change Transaction
    Verify If Warning Is Displayed

    ### Deal Change Transaction - Ratios ###      
    Insert Financial Ratio via Deal Change Transaction    &{ExcelPath}[NewFinancial_Ratio]    &{ExcelPath}[Deal_RatioType]    &{ExcelPath}[FinancialRatio_StartDate]

    ### Send to Approval ###
    Navigate to Deal Change Transaction Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}

    ### Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${DEALS_CATEGORY}    ${AWAITING_APPROVAL_STATUS}    ${DEAL_CHANGE_TRANSACTION}    ${Deal_Name}
    Navigate to Deal Change Transaction Workflow and Proceed With Transaction    ${APPROVAL_STATUS}

    ### Release ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP    ${DEALS_CATEGORY}    ${AWAITING_RELEASE_STATUS}    ${DEAL_CHANGE_TRANSACTION}    ${Deal_Name}
    Navigate to Deal Change Transaction Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    Close All Windows on LIQ

    ### Validation ###
    Search for Deal    ${Deal_Name}
    Validate Deal Events Tab    &{ExcelPath}[DealEventStatus1]
    Validate Deal Events Tab    &{ExcelPath}[DealEventStatus2]
    Navigate to Deal Ratios/Conds Tab
    Validate Updated Financial Ratio    &{ExcelPath}[Deal_RatioType]    &{ExcelPath}[NewFinancial_Ratio]
    Close All Windows on LIQ