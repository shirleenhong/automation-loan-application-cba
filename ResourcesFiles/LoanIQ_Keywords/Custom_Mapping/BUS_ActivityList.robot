*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Navigate to Fee Activity List from Loan
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    04JUN2020    - initial create

    Run Keyword   Navigate to Fee Activity List from Loan
    
BUS_Validate Loan Activity list Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    04JUN2020    - initial create

    Run Keyword   Validate Loan Activity list Tab
    
BUS_Validate Ongoing Fee Income Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    04JUN2020    - initial create

    Run Keyword   Validate Ongoing Fee Income Tab
    
BUS_Validate Ongoing Fee Expense Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    04JUN2020    - initial create

    Run Keyword   Validate Ongoing Fee Expense Tab
    
BUS_Validate Free Form Event Fee Income
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    04JUN2020    - initial create

    Run Keyword   Validate Free Form Event Fee Income
    
BUS_Validate Free Form Event Fee Expense
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    04JUN2020    - initial create

    Run Keyword   Validate Free Form Event Fee Expense