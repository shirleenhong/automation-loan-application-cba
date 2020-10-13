*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Correspondence POST API
    [Documentation]    This keyword contains the functional steps used to validate the requested JSON to 
    ...    Fusion Fabric Connect Web UI including the 2 instances (openAPI & distributor/TextJMS)
    ...    @author: cmartill    DDMMMYYYY    - initial create
    ...    @update: jaquitan    21MAR2019    - updated keywords, arguments, and variables
    ...    @update: jloretiz    14JUL2019    - updated keywords and arguments
    ...    @update: kduenas     09SEP2020    - updated keywords and arguments
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sOutputFilePath}    ${sActualOutput}    ${sExpectedOutput}    ${sResponseCode}

    Delete All Sessions
    Create Session Correspondence
    Run Keyword And Continue On Failure    Post Json File    ${sInputFilePath}    ${sInputJson}     
    ...    ${Corres_API}    ${sOutputFilePath}    ${sExpectedOutput}
    Delete File If Exist    ${sInputFilePath}${sExpectedOutput}
    Create File    ${sInputFilePath}${sExpectedOutput}    ${Response_file}
    Verify Json Response Status Code    ${sResponseCode}
    
Correspondence with Technical Validation Error
    [Documentation]    Used to check DB records and delete if record exist, then POST API file and check response error 400.
    ...    This also compares the input error list and output error list.
    ...    @author: cmartill    DDMMMYYYY    - initial create
    ...    @update: jaquitan    21MAR2019    - updated keywords, arguments
    ...    @update: jloretiz    14JUL2019    - updated keywords and arguments
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sOutputFilePath}    ${sActualOutput}    ${sExpectedOutput}    ${Expected_Err_List}   

    Delete All Sessions
    Create Session Correspondence
    Post Json File    ${sInputFilePath}    ${sInputJson}     ${Corres_API}    ${sOutputFilePath}    ${sActualOutput}
    Verify Json Response Status Code    ${RESPONSECODE_400}    
    Compare Expected and Actual Error for Correspondence    ${Actual_Err_List}    ${Expected_Err_List}     ${sOutputFilePath}${sActualOutput} 