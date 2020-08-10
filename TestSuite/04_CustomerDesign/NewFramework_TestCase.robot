*** Settings ***
Resource    ../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${Scenario_Path}    C:\\fms_scotia\\Customization\\LoanIQ\\Initiate_Interest_Payment_TestCase.xlsx

*** Test Cases ***

Test001
    [Documentation]    This test case is used to setup a new Deal.
    ...    @author: dahijara    23MAR2020    - initial create
    
    #Mx Launch UFT    Visibility=True    UFTAddins=Java
    
    Driver Script    ${Scenario_Path}
    
    
    