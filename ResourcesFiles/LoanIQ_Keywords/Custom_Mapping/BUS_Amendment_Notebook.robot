*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
BUS_Populate General Tab in Amendment Notebook
     [Documentation]    This keyword populates fields under General Tab.
    ...    @author:mgaling
    Run Keyword    Populate General Tab in Amendment Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Validate the Entered Values in Amendment Notebook - General Tab
      [Documentation]    This keyword validates if the entered data in Amendment Notebook- General Tab Window are matched with the data in Test Data sheet.
    ...    @author: mgaling
    ...    @update: clanding    30JUL2020    - refactor keyword name
    Run Keyword    Validate the Entered Values in Amendment Notebook - General Tab    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Add Facility in Amendment Transaction
       [Documentation]    This keyword add the facility and Transaction Type.
    ...    @author: mgaling
   Run Keyword    Add Facility in Amendment Transaction    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Covenant Change in Facility Notebook
    [Documentation]    This keyword is used to adjust shares in Facility Notebook
    ...    @author: Archana  
    Run Keyword    Covenant Change in Facility Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Amendment Approval
    [Documentation]    This keyword is for approval of Amendment Notebook.
    ...    @author: mgaling
    Run Keyword    Amendment Approval    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Amendment Release
     [Documentation]    This keyword is for the release of Amendment Notebook.
    ...    @author: mgaling
    Run keyword    Amendment Release    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}     
    
BUS_Populate Amendment Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    25JUN2020    - initial create

    Run Keyword   Populate Amendment Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Populate Facility Select Window - Amendment Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    25JUN2020    - initial create

    Run Keyword   Populate Facility Select Window - Amendment Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Validate the Entered Values in Facility Select Window - Amendment Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    25JUN2020    - initial create
    ...    @update: clanding    30JUL2020    - refactor keyword name

    Run Keyword   Validate the Entered Values in Facility Select Window - Amendment Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Populate the Fields in Facility Notebook - Summary Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    25JUN2020    - initial create
    ...    @update: clanding    30JUL2020    - refactor keyword name

    Run Keyword   Populate the Fields in Facility Notebook - Summary Tab    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Validate the Entered Values in Facility Notebook - Summary Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    25JUN2020    - initial create
    ...    @update: clanding    30JUL2020    - refactor keyword name

    Run Keyword   Validate the Entered Values in Facility Notebook - Summary Tab    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Add Currency in Facility Notebook - Restriction Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    25JUN2020    - initial create

    Run Keyword   Add Currency in Facility Notebook - Restriction Tab    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Add Borrower in Facility Notebook - SublimitCust Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    25JUN2020    - initial create

    Run Keyword   Add Borrower in Facility Notebook - SublimitCust Tab

BUS_Modify Ongoing Fee - Insert After
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    25JUN2020    - initial create

    Run Keyword   Modify Ongoing Fee - Insert After    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Validate Ongoing Fee Values
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    25JUN2020    - initial create
    ...    @update: clanding    30JUL2020    - refactor keyword name

    Run Keyword   Validate Ongoing Fee Values

BUS_Modify Interest Pricing - Insert Add (Options Item)
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    25JUN2020    - initial create

    Run Keyword   Modify Interest Pricing - Insert Add (Options Item)    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}

BUS_Validate Interest Pricing Values
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    25JUN2020    - initial create
    ...    @update: clanding    30JUL2020    - refactor keyword name

    Run Keyword   Validate Interest Pricing Values

BUS_Populate Add Transaction Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    25JUN2020    - initial create

    Run Keyword   Populate Add Transaction Window    ${ARGUMENT_1}    ${ARGUMENT_2}  

BUS_Add a Schedule Item
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    25JUN2020    - initial create
    ...    @update: clanding    20AUG2020    - added new argument

    Run Keyword   Add a Schedule Item    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}
    ...    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}

BUS_Amendment Send to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    25JUN2020    - initial create

    Run Keyword   Amendment Send to Approval

BUS_Search the Newly Added Facility
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    25JUN2020    - initial create

    Run Keyword   Search the Newly Added Facility    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Populate Add Transaction Window for the Facility Increase
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword   Populate Add Transaction Window for the Facility Increase    ${ARGUMENT_1}    ${ARGUMENT_2} 
    
BUS_Populate Amortization Schedule Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword   Populate Amortization Schedule Window    ${ARGUMENT_1} 
    
BUS_Navigate to Unscheduled Commitment Increase Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword   Navigate to Unscheduled Commitment Increase Notebook 
    
BUS_Create Notices for Unscheduled Item
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword   Create Notices for Unscheduled Item
    
BUS_Equalize Amounts under Current Schedule Section
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    06AUG2020    - initial create

    Run Keyword   Equalize Amounts under Current Schedule Section 
    
BUS_Set Facility Loan Purpose
    [Documentation]    This keyword is used to adds Loan Purpose Type.
    ...    @author: clanding    31JUL2020    - initial create

    Run Keyword   Set Facility Loan Purpose    ${ARGUMENT_1}    
        