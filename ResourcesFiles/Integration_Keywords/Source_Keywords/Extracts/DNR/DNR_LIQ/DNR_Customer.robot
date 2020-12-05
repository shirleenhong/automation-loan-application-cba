*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Add Alerts in Customer for DNR
    [Documentation]    This keyword is used to add comments in active customer.
    ...    @author: clanding    05DEC2020    - initial create.
    [Arguments]    ${ExcelPath}

    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]          
    ${Status_UI}    Get Profile Status from Profiles Tab    &{ExcelPath}[Profile_Type]
    Compare Two Strings    Not In Use    ${Status_UI}
    ${Alerts_Details}    ${Date_Added}    ${Current_Local_Date_WithoutTime}    Add Alerts in Active Customer    &{ExcelPath}[Alerts_ShortDescription]    &{ExcelPath}[Alerts_DetailsPrefix]
    Write Data To Excel    SC1_Customer    Alerts_Details    ${rowid}    ${Alerts_Details}    ${DNR_DATASET}
    Write Data To Excel    SC1_Customer    Alerts_DateAddedAmended    ${rowid}    ${Date_Added}    ${DNR_DATASET}

    ${FName_UI}    ${LName_UI}    Get First Name of a User    ${INPUTTER_USERNAME}

    ### Writing for Alerts Report ###
    Write Data To Excel    ALERT    Customer_Name    ${TestCase_Name}    &{ExcelPath}[LIQCustomer_LegalName]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    CIF_Number    ${TestCase_Name}    &{ExcelPath}[LIQCustomer_ID]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Alert_Heading    ${TestCase_Name}    &{ExcelPath}[Alerts_ShortDescription]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Alert_Content    ${TestCase_Name}    ${Alerts_Details}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    User_Name    ${TestCase_Name}    ${FName_UI}${SPACE}${LName_UI}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Date_Added_Amended    ${TestCase_Name}    ${Date_Added}    ${DNR_DATASET}    bTestCaseColumn=True

    Close All Windows on LIQ
    Logout from Loan IQ

Update Alerts in Customer for DNR
    [Documentation]    This keyword is used to update comments in active customer.
    ...    @author: clanding    05DEC2020    - initial create.
    [Arguments]    ${ExcelPath}

    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]          
    ${Status_UI}    Get Profile Status from Profiles Tab    &{ExcelPath}[Profile_Type]
    Compare Two Strings    Not In Use    ${Status_UI}
    ${Alerts_Details}    ${Date_Added}    ${Current_Local_Date_WithoutTime}    Update Alerts in Active Customer    &{ExcelPath}[Alerts_ShortDescription]

    ${FName_UI}    ${LName_UI}    Get First Name of a User    ${INPUTTER_USERNAME}

    ### Writing for Alerts Report ###
    Write Data To Excel    ALERT    Customer_Name    ${TestCase_Name}    &{ExcelPath}[LIQCustomer_LegalName]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    CIF_Number    ${TestCase_Name}    &{ExcelPath}[LIQCustomer_ID]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Alert_Heading    ${TestCase_Name}    &{ExcelPath}[Alerts_ShortDescription]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Alert_Content    ${TestCase_Name}    ${Alerts_Details}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    User_Name    ${TestCase_Name}    ${FName_UI}${SPACE}${LName_UI}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Date_Added_Amended    ${TestCase_Name}    ${Date_Added}    ${DNR_DATASET}    bTestCaseColumn=True

    Close All Windows on LIQ
    Logout from Loan IQ