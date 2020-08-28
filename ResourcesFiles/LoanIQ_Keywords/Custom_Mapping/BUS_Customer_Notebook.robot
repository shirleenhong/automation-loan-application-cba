*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Create New Customer
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Create New Customer

BUS_Get Customer ID and Save it to Excel
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Get Customer ID and Save it to Excel    ${ARGUMENT_1}

BUS_Create Customer and Enter Customer ShortName and Legal Name
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Create Customer and Enter Customer ShortName and Legal Name    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Add Customer Legal Address Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

     Run Keyword    Add Customer Legal Address Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}

BUS_Assign Primary SIC Code
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

     Run Keyword    Assign Primary SIC Code    ${ARGUMENT_1}

BUS_Save Customer Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

     Run Keyword    Save Customer Details

BUS_Search Customer
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Search Customer    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Select Customer Notice Type Method
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Select Customer Notice Type Method    ${ARGUMENT_1}

BUS_Add Expense Code Details under General tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Add Expense Code Details under General tab    ${ARGUMENT_1}

BUS_Add Department Code Details under General tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Add Department Code Details under General tab    ${ARGUMENT_1}

BUS_Add Classification Code Details under General tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Add Classification Code Details under General tab    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Uncheck "Subject to GST" checkbox
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Uncheck "Subject to GST" checkbox

BUS_Add Province Details in the Legal Address
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Add Province Details in the Legal Address    ${ARGUMENT_1}

BUS_Navigate to "SIC" tab and Validate Primary SIC Code
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Navigate to "SIC" tab and Validate Primary SIC Code    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Navigate to "Profiles" tab and Validate "Add Profile" Button
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Navigate to "Profiles" tab and Validate "Add Profile" Button

BUS_Add Profile under Profiles Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Add Profile under Profiles Tab    ${ARGUMENT_1}

BUS_Add Borrower Profile Details under Profiles Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Add Borrower Profile Details under Profiles Tab    ${ARGUMENT_1}

BUS_Validate Only "Add Profile" and "Add Location" and "Delete" Buttons are Enabled in Profile Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Validate Only "Add Profile" and "Add Location" and "Delete" Buttons are Enabled in Profile Tab

BUS_Add Location under Profiles Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Add Location under Profiles Tab    ${ARGUMENT_1}

BUS_Add Borrower/Location Details under Profiles Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Add Borrower/Location Details under Profiles Tab    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Validate If All Buttons are Enabled
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Validate If All Buttons are Enabled

BUS_Add Fax Details under Profiles Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Add Fax Details under Profiles Tab    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Add Contact under Profiles Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Add Contact under Profiles Tab    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}
    ...    ${ARGUMENT_9}    ${ARGUMENT_10}    ${ARGUMENT_11}    ${ARGUMENT_12}    ${ARGUMENT_13}    ${ARGUMENT_14}    ${ARGUMENT_15}    ${ARGUMENT_16}

BUS_Complete Location under Profile Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Complete Location under Profile Tab    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Navigate to Remittance List Page
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Navigate to Remittance List Page

BUS_Add DDA Remittance Instruction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Add DDA Remittance Instruction    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}
    ...    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}    ${ARGUMENT_11}    ${ARGUMENT_12}    ${ARGUMENT_13}    ${ARGUMENT_14}

BUS_Add IMT Remittance Instruction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Add IMT Remittance Instruction    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}

BUS_Add RTGS Remittance Instruction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Add RTGS Remittance Instruction    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}

BUS_Access Remittance List upon Login
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Access Remittance List upon Login    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Approving Remittance Instruction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Approving Remittance Instruction    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Releasing Remittance Instruction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Releasing Remittance Instruction    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Add Servicing Groups Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Add Servicing Groups Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Add Remittance Instruction to Servicing Group
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Add Remittance Instruction to Servicing Group    ${ARGUMENT_1}

BUS_Close Servicing Group Remittance Instructions Selection List Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Close Servicing Group Remittance Instructions Selection List Window    ${ARGUMENT_1}

BUS_Switch Customer Notebook to Update Mode
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Switch Customer Notebook to Update Mode

BUS_Close Remittance List Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Close Remittance List Window

BUS_Adding Beneficiary Profile Details under Profiles Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    20MAY2020    - initial create

    Run Keyword    Adding Beneficiary Profile Details under Profiles Tab    ${ARGUMENT_1}

BUS_Adding Guarantor Profile Details under Profiles Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    20MAY2020    - initial create

    Run Keyword    Adding Guarantor Profile Details under Profiles Tab    ${ARGUMENT_1}

BUS_Adding Lender Profile Details under Profiles Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    20MAY2020    - initial create

    Run Keyword    Adding Lender Profile Details under Profiles Tab    ${ARGUMENT_1}

BUS_Validate 'Active Customer' Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    21MAY2020    - initial create

    Run Keyword    Validate 'Active Customer' Window    ${ARGUMENT_1}

BUS_Adding Beneficiary/Location Details under Profiles Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    21MAY2020    - initial create

    Run Keyword    Adding Beneficiary/Location Details under Profiles Tab    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Adding Guarantor/Location Details under Profiles Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    21MAY2020    - initial create

    Run Keyword    Adding Guarantor/Location Details under Profiles Tab    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Adding Lender/Location Details under Profiles Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    21MAY2020    - initial create

    Run Keyword    Adding Lender/Location Details under Profiles Tab    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Search by Customer Short Name
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    10JUN2020    - initial create

    Run Keyword    Search by Customer Short Name    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Add Internal Risk Rating
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    10JUN2020    - initial create

    Run Keyword    Add Internal Risk Rating    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Validate Internal Risk Rating Table
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    10JUN2020    - initial create

    Run Keyword    Validate Internal Risk Rating Table    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Add External Risk Rating
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    10JUN2020    - initial create

    Run Keyword    Add External Risk Rating    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Validate External Risk Rating Table
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    10JUN2020    - initial create

    Run Keyword    Validate External Risk Rating Table    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Validate Details on Customer Remittance Instruction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ritragel    17AUG2020    - initial create
    
    Run Keyword    Populate Details on Customer Remittance Instructions    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}
    ...    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}    ${ARGUMENT_11}    ${ARGUMENT_12}

BUS_Add IMT Message in Remittance Instruction Detail
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ritragel    17AUG2020    - initial create
    
    Run Keyword    Add IMT Message in Remittance Instructions Detail    ${ARGUMENT_1}
    
BUS_Add Swift Role in IMT message
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ritragel    17AUG2020    - initial create
    
    Run Keyword    Add Swift Role in IMT message    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}
           
BUS_Update Swift Role in IMT message
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ritragel    17AUG2020    - initial create
    
    Run Keyword    Update Swift Role in IMT message    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}   
    
BUS_Populate Details on IMT
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ritragel    17AUG2020    - initial create
    
    Run Keyword    Populate Details on IMT   ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}
