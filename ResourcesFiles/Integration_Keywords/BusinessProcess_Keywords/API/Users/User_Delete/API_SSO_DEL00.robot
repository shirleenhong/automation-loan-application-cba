*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
DELETE User in LIQ Without FFC Validation
    [Documentation]    This keyword is used to delete user in LIQ without FFC Validation.
    ...    @author: jloretiz    20AUG2019    - initial create
    [Arguments]    ${APIDataSet}
    
    Update Expected XML Elements for wsFinalLIQDestination - Delete    &{APIDataSet}[InputFilePath]    &{APIDataSet}[Expected_wsFinalLIQDestination]    
    ...    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[loginId]
     
    Run Keyword And Continue On Failure    Validate Loan IQ for Users with INACTIVE Status    &{APIDataSet}[loginId]