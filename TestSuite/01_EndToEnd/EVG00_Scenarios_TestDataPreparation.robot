*** Settings ***
Resource    ../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
###___Start of Day 1
#####Create Quick Party Onboarding - PTY001
    #####[Tags]    01 Create Party within Essence - PTY001
    #####Mx Execute Template With Multiple Data    Create Party in Quick Party Onboarding    ${ExcelPath}    ${rowid}    PTY001_QuickPartyOnboarding

Create Customer within Loan IQ_TDP - ORIG03
    [Documentation]    This keyword creates Customer within LoanIQ as part of test data preparation (excluded in the main scenarios)
    ...    @author: ghabal
    [Tags]    01 Create Customer within Loan IQ - ORIG03
    Mx Execute Template With Multiple Data    Create Customer within Loan IQ_TDP    ${ExcelPath}    ${rowid}    TDP_ORIG03Customer
    
Search Customer and Complete its Lender Profile Creation - ORIG03
    [Documentation]    This keyword searches a customer and complete its Lender Profile creation
    ...    @author: ghabal
    [Tags]    02 Complete Lender's Profile - 0RIG03
    Mx Execute Template With Multiple Data    Search Customer and Complete its Lender Profile Creation    ${ExcelPath}    ${rowid}    TDP_ORIG03Customer
    
