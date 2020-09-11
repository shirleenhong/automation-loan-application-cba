*** Settings***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords***
Verify Response of Deal Facility 404 Response 
    [Documentation]    This keyword is to validate GET response of 404 code. 
    ...    @author: sacuisia    15AUG2019
    [Arguments]    ${COMID}    ${Headers}    ${sResponseFilePath}    ${sResponseJson}   

    Delete All Sessions
    Create Session    COMHOST    ${COM_HOST}
    ${REQUEST_DATA}    GET Request API for Comsee Deal Facility 404 Response    COMHOST    ${MDM_COM_API}${COMID}    ${Headers}
    ${JSON_File}    Set Variable    ${sResponseFilePath}${sResponseJson}.json
    Create File    ${dataset_path}${JSON_File}
    ${Content}    Convert to String    ${GET_response.content}
    Append To File    ${dataset_path}${JSON_File}    ${Content}

Validation for CommSee 
    [Documentation]     This keyword is to get token and create session for CommSEE and Get Request 200 Response Ok.
    ...    @author: sacuisia
    [Arguments]   ${COMID}    ${Headers}    ${sResponseFilePath}    ${sResponseJson}    ${dataExtracted}    ${sDealName}    ${sdealTrackingNumber}    ${sdealclosedDate}    ${sdealCurrency}    ${sdealHostBankCom}
    ...    ${sdealCode}    ${sdealDesc}    ${sdealExpenseCode}    ${sdealExpenseDesc}    ${sdealNoFacilities}    ${sdealNolenders}    ${sdealNoBorrowers}
    ...    ${sdealHostClosingBankCom}    ${sdealGlobalClosing}    ${sdealGobalCurrent}    ${sdealDepartmentCode}    ${sdealDepartmentDesc}    ${sfacilityName}    ${sfacilityCN}
    ...    ${sfacilityeffectiveDate}    ${sfacilityMaturityDate}    ${sfacilityCurr}    ${sfacilityMultiCCY}    ${sfacilityType}
    ...    ${sfacilityHostBankComm}    ${sfacilityBankOutstanding}    ${sfacilityHostAvailableDraw}    ${sfacilityExpenseCode}   
    ...    ${sfacilityProCode}    ${sfacilityProDesc}    ${sfacilityNoLenders}    ${sfacilityBorrowers}    ${facilityOutstanding}    ${facilityFundableCom}
    ...    ${sfacilityGlobalCom}    ${sfacilityCurrCom}    ${sfacilityGlobalOust}    ${sfacilityAvailableDraw}    ${sfacilityPortCode}    ${facilityPortDesc}
    ...    ${sfacilityOwningBranchCode}    ${sfacilityOwningBranchDesc}    ${sfundingCode}    ${sfundingDesc}    ${sexpiryDate} 

    ###GET RESOPONSE###           
    Delete All Sessions
    Create Session    COMHOST    ${COM_HOST}
    ${REQUEST_DATA}    GET Request API for Comsee Deal Facility    COMHOST    ${MDM_COM_API}${COMID}    ${Headers}        

    ###FIELDS VALIDATION###
    ${Expect_dataExtract}    Run Keyword If    '${dataExtracted}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${dataExtracted}   
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['dealDetails']['dataExtractDate']}    ${Expect_dataExtract}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal    ${REQUEST_DATA['dealDetails']['dataExtractDate']}    ${Expect_dataExtract}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${dataExtracted} = ${Expect_dataExtract}
    ...    ELSE    Log    Not Equal! ${dataExtracted}!=${Expect_dataExtract}    level=ERROR    

    ${Expect_DealName}    Run Keyword If    '${sDealName}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sDealName}  
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['dealDetails']['dealName']}    ${Expect_DealName}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal    ${REQUEST_DATA['dealDetails']['dealName']}    ${Expect_DealName} 
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sDealName} =${Expect_DealName}
    ...    ELSE    Log    NotEqual! ${sDealName} !=${Expect_DealName}    level=ERROR

    ${Expect_DealTrackingNumeber}    Run Keyword If    '${sdealTrackingNumber}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sdealTrackingNumber}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['dealDetails']['dealTrackingNumber']}    ${Expect_DealTrackingNumeber} 
    ${Stat}    Run Keyword and Return Status    Should Be Equal    ${REQUEST_DATA['dealDetails']['dealTrackingNumber']}    ${Expect_DealTrackingNumeber}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sdealTrackingNumber} = ${Expect_DealTrackingNumeber}
    ...    ELSE    Log    Not Equal ${sdealTrackingNumber} != ${Expect_DealTrackingNumeber}    level=ERROR

    ${Expect_closedDate}    Run Keyword If    '${sdealclosedDate}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sdealclosedDate}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['dealDetails']['closedDate']}    ${sdealclosedDate}
    ${Stat}    Run Keyword and Return Status    Should Be Equal    ${REQUEST_DATA['dealDetails']['closedDate']}    ${sdealclosedDate}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sdealclosedDate} = ${Expect_closedDate}
    ...    ELSE    Log    Not Equal ${sdealclosedDate} != ${Expect_closedDate}    level=ERROR

    ${Expect_currency}    Run Keyword If    '${sdealCurrency}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sdealCurrency}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['dealDetails']['currency']}    ${sdealCurrency}
    ${Stat}    Run Keyword and Return Status    Should Be Equal    ${REQUEST_DATA['dealDetails']['currency']}    ${sdealCurrency}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sdealCurrency}=${Expect_currency}   
    ...    ELSE    Log    Not Equal ${sdealCurrency} != ${Expect_currency}    level=ERROR

    ${Expect_hostBankCommitment}    Run Keyword If    '${sdealHostBankCom}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sdealHostBankCom}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers    ${REQUEST_DATA['dealDetails']['hostBankNetCommitment']}    ${sdealHostBankCom}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers    ${REQUEST_DATA['dealDetails']['hostBankNetCommitment']}    ${sdealHostBankCom}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sdealHostBankCom}=${Expect_hostBankCommitment}    
    ...    ELSE    Log    Not Equal ${sdealHostBankCom} != ${Expect_hostBankCommitment}    level=ERROR

    ${Expect_processCode}    Run Keyword If    '${sdealCode}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sdealCode}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['dealDetails']['processingArea']['code']}    ${sdealCode}
    ${Stat}    Run Keyword and Return Status    Should Be Equal    ${REQUEST_DATA['dealDetails']['processingArea']['code']}    ${sdealCode}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sdealCode}=${Expect_processCode}    
    ...    ELSE    Log    Not Equal ${sdealCode} != ${Expect_processCode}    level=ERROR

    ${Expect_processDesc}    Run Keyword If    '${sdealDesc}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sdealDesc}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['dealDetails']['processingArea']['description']}    ${sdealDesc}
    ${Stat}    Run Keyword and Return Status    Should Be Equal    ${REQUEST_DATA['dealDetails']['processingArea']['description']}    ${sdealDesc}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sdealDesc}=${Expect_processDesc}    
    ...    ELSE    Log    Not Equal ${sdealDesc} != ${Expect_processDesc}    level=ERROR

    ${Expect_expenseCode}    Run Keyword If    '${sdealExpenseCode}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sdealExpenseCode}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['dealDetails']['expense']['code']}    ${sdealExpenseCode}
    ${Stat}    Run Keyword and Return Status    Should Be Equal    ${REQUEST_DATA['dealDetails']['expense']['code']}    ${sdealExpenseCode}
    Run Keyword If    ${Stat}==${True}    Log    Correct!${sdealExpenseCode}=${Expect_expenseCode}    
    ...    ELSE    Log    Not Equal ${sdealExpenseCode} != ${Expect_expenseCode}    level=ERROR

    ${Expect_expenseDesc}    Run Keyword If    '${sdealExpenseDesc}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sdealExpenseDesc}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['dealDetails']['expense']['description']}    ${sdealExpenseDesc}
    ${Stat}    Run Keyword and Return Status    Should Be Equal    ${REQUEST_DATA['dealDetails']['expense']['description']}    ${sdealExpenseDesc}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sdealExpenseDesc}=${Expect_expenseDesc}    
    ...    ELSE    Log    Not Equal ${sdealExpenseDesc} != ${Expect_expenseDesc}    level=ERROR

    ${Expect_noFacilities}    Run Keyword If    '${sdealNoFacilities}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sdealNoFacilities}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers    ${REQUEST_DATA['dealDetails']['noOfFacilities']}    ${sdealNoFacilities}
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers    ${REQUEST_DATA['dealDetails']['noOfFacilities']}    ${sdealNoFacilities}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sdealNoFacilities}=${Expect_noFacilities}    
    ...    ELSE    Log    Not Equal ${sdealNoFacilities} != ${Expect_noFacilities}    level=ERROR

    ${Expect_noLenders}    Run Keyword If    '${sdealNolenders}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sdealNolenders}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers    ${REQUEST_DATA['dealDetails']['noOfLenders']}    ${sdealNolenders}
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers    ${REQUEST_DATA['dealDetails']['noOfLenders']}    ${sdealNolenders}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sdealNolenders}=${Expect_noLenders}   
    ...    ELSE    Log    Not Equal ${sdealNolenders} != ${Expect_noLenders}    level=ERROR

    ${Expect_noBorrowers}    Run Keyword If    '${sdealNoBorrowers}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sdealNoBorrowers}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers    ${REQUEST_DATA['dealDetails']['noOfLenders']}    ${sdealNolenders}
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers    ${REQUEST_DATA['dealDetails']['noOfLenders']}    ${sdealNolenders}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sdealNoBorrowers}=Expect_noBorrowers    
    ...    ELSE    Log    Not Equal ${sdealNoBorrowers} != ${Expect_noBorrowers}    level=ERROR

    ${Expect_hostClosingCommitment}    Run Keyword If    '${sdealHostClosingBankCom}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sdealHostClosingBankCom}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers    ${REQUEST_DATA['dealDetails']['hostBankClosingCommitment']}    ${sdealHostClosingBankCom}
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers    ${REQUEST_DATA['dealDetails']['hostBankClosingCommitment']}    ${sdealHostClosingBankCom}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sdealHostClosingBankCom}=${Expect_hostClosingCommitment}    
    ...    ELSE    Log    Not Equal ${sdealHostClosingBankCom} != ${Expect_hostClosingCommitment}    level=ERROR

    ${Expect_globalDealCommitmment}    Run Keyword If    '${sdealGlobalClosing}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sdealGlobalClosing}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers    ${REQUEST_DATA['dealDetails']['globalDealClosingCommitment']}    ${sdealGlobalClosing}
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers    ${REQUEST_DATA['dealDetails']['globalDealClosingCommitment']}    ${sdealGlobalClosing}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sdealGlobalClosing}=${Expect_globalDealCommitmment}    
    ...    ELSE    Log    Not Equal ${sdealGlobalClosing} != ${Expect_globalDealCommitmment}    level=ERROR

    ${Expect_globalDealCurr}    Run Keyword If    '${sdealGobalCurrent}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sdealGobalCurrent}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers    ${REQUEST_DATA['dealDetails']['globalDealCurrentCommitment']}    ${sdealGobalCurrent}
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers    ${REQUEST_DATA['dealDetails']['globalDealCurrentCommitment']}    ${sdealGobalCurrent}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sdealGobalCurrent}=${Expect_globalDealCurr}    
    ...    ELSE    Log    Not Equal ${sdealGobalCurrent} != ${Expect_globalDealCurr}    level=ERROR
    
    ${Expect_dealDeptCode}    Run Keyword If    '${sdealDepartmentCode}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sdealDepartmentCode}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['dealDetails']['department']['code']}    ${sdealDepartmentCode}
    ${Stat}    Run Keyword and Return Status    Should Be Equal    ${REQUEST_DATA['dealDetails']['department']['code']}    ${sdealDepartmentCode}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sdealDepartmentCode} = ${Expect_dealDeptCode}
    ...    ELSE    Log    Not Equal ${sdealDepartmentCode} != ${Expect_dealDeptCode}    level=ERROR

    ${Expect_dealDeptDesc}    Run Keyword If    '${sdealDepartmentDesc}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sdealDepartmentDesc}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['dealDetails']['department']['description']}    ${sdealDepartmentDesc}
    ${Stat}    Run Keyword and Return Status    Should Be Equal    ${REQUEST_DATA['dealDetails']['department']['description']}    ${sdealDepartmentDesc}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['dealDetails']['department']['description']}
    ...    ELSE    Log    Not Equal ${sdealDepartmentDesc} != ${Expect_dealDeptDesc}    level=ERROR

    ${Expect_facilityName}    Run Keyword If    '${sfacilityName}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityName}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['facilityDetails']['facilityName']}    ${sfacilityName}
    ${Stat}    Run Keyword and Return Status    Should Be Equal    ${REQUEST_DATA['facilityDetails']['facilityName']}    ${sfacilityName}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['facilityName']}
    ...    ELSE    Log    Not Equal ${sfacilityName} != ${Expect_facilityName}    level=ERROR

    ${Expect_facilityNo}    Run Keyword If    '${sfacilityCN}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityCN}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['facilityDetails']['facilityControlNumber']}    ${sfacilityCN}
    ${Stat}    Run Keyword and Return Status    Should Be Equal    ${REQUEST_DATA['facilityDetails']['facilityControlNumber']}    ${sfacilityCN}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['facilityControlNumber']}
    ...    ELSE    Log    Not Equal ${sfacilityCN} != ${Expect_facilityNo}    level=ERROR

    ${Expect_facilityDate}    Run Keyword If    '${sfacilityeffectiveDate}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityeffectiveDate}
    Run Keyword and Continue on Failure    Should Be Equal     ${REQUEST_DATA['facilityDetails']['effectiveDate']}    ${sfacilityeffectiveDate}
    ${Stat}    Run Keyword and Return Status    Should Be Equal     ${REQUEST_DATA['facilityDetails']['effectiveDate']}    ${sfacilityeffectiveDate}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['effectiveDate']}
    ...    ELSE    Log    Not Equal ${sfacilityeffectiveDate} != ${Expect_facilityDate}    level=ERROR

    ${Expect_facilityMaturityDate}    Run Keyword If    '${sfacilityMaturityDate}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityMaturityDate}
    Run Keyword and Continue on Failure    Should Be Equal     ${REQUEST_DATA['facilityDetails']['finalMaturityDate']}    ${sfacilityMaturityDate}
    ${Stat}    Run Keyword and Return Status    Should Be Equal    ${REQUEST_DATA['facilityDetails']['finalMaturityDate']}    ${sfacilityMaturityDate}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['finalMaturityDate']}
    ...    ELSE    Log    Not Equal ${sfacilityMaturityDate} != ${Expect_facilityMaturityDate}    level=ERROR

    ${Expect_facilityCurr}    Run Keyword If    '${sfacilityCurr}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityCurr}
    Run Keyword and Continue on Failure    Should Be Equal     ${REQUEST_DATA['facilityDetails']['currency']}    ${sfacilityCurr}
    ${Stat}    Run Keyword and Return Status    Should Be Equal    ${REQUEST_DATA['facilityDetails']['currency']}    ${sfacilityCurr}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['currency']}    
    ...    ELSE    Log    Not Equal ${sfacilityCurr} != ${Expect_facilityCurr}    level=ERROR
    
    ${Expect_facilityMultiCCY}    Run Keyword If    '${sfacilityMultiCCY}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityMultiCCY}
    ${exist}    Run Keyword and Return Status    Should Be Equal    ${REQUEST_DATA['facilityDetails']['multiCCY']}    ${Expect_facilityMultiCCY}    
    Run Keyword If    ${exist}==True    Should Be Equal    ${REQUEST_DATA['facilityDetails']['multiCCY']}    ${Expect_facilityMultiCCY}
    Run Keyword If    ${exist}==False    Log    False!${sfacilityMultiCCY} != ${Expect_facilityMultiCCY}    

    ${Expect_facilityType}    Run Keyword If    '${sfacilityType}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityType}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['facilityDetails']['facilityType']}    ${sfacilityType}    
    ${Stat}    Run Keyword and Return Status    Should Be Equal    ${REQUEST_DATA['facilityDetails']['facilityType']}    ${sfacilityType}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['facilityType']}
    ...    ELSE    Log    Not Equal ${sfacilityType} != ${Expect_facilityType}    level=ERROR

    ${Expect_facilityHostNet}    Run Keyword If    '${sfacilityHostBankComm}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityHostBankComm}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers    ${REQUEST_DATA['facilityDetails']['hostBankNetCommitment']}    ${sfacilityHostBankComm}    
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers    ${REQUEST_DATA['facilityDetails']['hostBankNetCommitment']}    ${sfacilityHostBankComm}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['hostBankNetCommitment']}
    ...    ELSE    Log    Not Equal ${sfacilityHostBankComm} != ${Expect_facilityHostNet}    level=ERROR

    ${Expect_facilityHostOust}    Run Keyword If    '${sfacilityBankOutstanding}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityBankOutstanding}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers    ${REQUEST_DATA['facilityDetails']['hostBankNetOutstandings']}    ${sfacilityBankOutstanding}    
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers    ${REQUEST_DATA['facilityDetails']['hostBankNetOutstandings']}    ${sfacilityBankOutstanding}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['hostBankNetOutstandings']}
    ...    ELSE    Log    Not Equal ${sfacilityBankOutstanding} != ${Expect_facilityHostOust}    level=ERROR

    ${Expect_facilityAvailDraw}    Run Keyword If    '${sfacilityHostAvailableDraw}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityHostAvailableDraw}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers    ${REQUEST_DATA['facilityDetails']['hostBankNetAvailableToDraw']}    ${sfacilityHostAvailableDraw}    
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers    ${REQUEST_DATA['facilityDetails']['hostBankNetAvailableToDraw']}    ${sfacilityHostAvailableDraw}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['hostBankNetAvailableToDraw']}
    ...    ELSE    Log    Not Equal ${sfacilityHostAvailableDraw} != ${Expect_facilityAvailDraw}    level=ERROR

    ${Expect_facilityProCode}    Run Keyword If    '${sfacilityProCode}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityProCode}
    Run Keyword and Continue on Failure    Should Be Equal     ${REQUEST_DATA['facilityDetails']['processingArea']['code']}    ${sfacilityProCode}    
    ${Stat}    Run Keyword and Return Status    Should Be Equal     ${REQUEST_DATA['facilityDetails']['processingArea']['code']}    ${sfacilityProCode}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['processingArea']['code']}
    ...    ELSE    Log    Not Equal ${sfacilityProCode} != ${Expect_facilityProCode}    level=ERROR

    ${Expect_facilityProDesc}    Run Keyword If    '${sfacilityProDesc}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityProDesc}
    Run Keyword and Continue on Failure    Should Be Equal     ${REQUEST_DATA['facilityDetails']['processingArea']['description']}    ${sfacilityProDesc}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal     ${REQUEST_DATA['facilityDetails']['processingArea']['description']}    ${sfacilityProDesc}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['processingArea']['description']}
    ...    ELSE    Log    Not Equal ${sfacilityProDesc} != ${Expect_facilityProDesc}    level=ERROR

    ${Expect_facilityNoLenders}    Run Keyword If    '${sfacilityNoLenders}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityNoLenders}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers     ${REQUEST_DATA['facilityDetails']['noOfLenders']}    ${sfacilityNoLenders}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers     ${REQUEST_DATA['facilityDetails']['noOfLenders']}    ${sfacilityNoLenders}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['noOfLenders']}
    ...    ELSE    Log    Not Equal ${sfacilityNoLenders} != ${Expect_facilityNoLenders}    level=ERROR

    ${Expect_facilityNoBorrowers}    Run Keyword If    '${sfacilityBorrowers}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityBorrowers}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers     ${REQUEST_DATA['facilityDetails']['noOfBorrowers']}    ${sfacilityBorrowers}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers     ${REQUEST_DATA['facilityDetails']['noOfBorrowers']}    ${sfacilityBorrowers}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['noOfBorrowers']}
    ...    ELSE    Log    Not Equal ${sfacilityBorrowers} != ${Expect_facilityNoBorrowers}    level=ERROR

    ${Expect_facilityOustandings}    Run Keyword If    '${facilityOutstanding}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${facilityOutstanding}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers     ${REQUEST_DATA['facilityDetails']['noOfOutstanding']}    ${facilityOutstanding}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers     ${REQUEST_DATA['facilityDetails']['noOfOutstanding']}    ${facilityOutstanding}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['noOfOutstanding']}
    ...    ELSE    Log    Not Equal ${facilityOutstanding} != ${Expect_facilityOustandings}    level=ERROR

    ${Expect_facilityFundCom}    Run Keyword If    '${facilityFundableCom}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${facilityFundableCom}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers     ${REQUEST_DATA['facilityDetails']['hostBankFundableCommitment']}    ${facilityFundableCom}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers     ${REQUEST_DATA['facilityDetails']['hostBankFundableCommitment']}    ${facilityFundableCom}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['hostBankFundableCommitment']}
    ...    ELSE    Log    Not Equal ${facilityFundableCom} != ${Expect_facilityFundCom}    level=ERROR

    ${Expect_facilityGlobalCom}    Run Keyword If    '${sfacilityGlobalCom}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityGlobalCom}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers     ${REQUEST_DATA['facilityDetails']['globalClosingCommitment']}    ${sfacilityGlobalCom}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers     ${REQUEST_DATA['facilityDetails']['globalClosingCommitment']}    ${sfacilityGlobalCom}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['globalClosingCommitment']}
    ...    ELSE    Log    Not Equal ${sfacilityGlobalCom} != ${Expect_facilityFundCom}    level=ERROR

    ${Expect_facilityCurrCom}    Run Keyword If    '${sfacilityCurrCom}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityCurrCom}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers     ${REQUEST_DATA['facilityDetails']['globalCurrentCommitment']}    ${sfacilityCurrCom}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers     ${REQUEST_DATA['facilityDetails']['globalCurrentCommitment']}    ${sfacilityCurrCom}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['globalCurrentCommitment']}
    ...    ELSE    Log    Not Equal ${sfacilityCurrCom} != ${Expect_facilityCurrCom}    level=ERROR

    ${Expect_facilityGlobalOust}    Run Keyword If    '${sfacilityGlobalOust}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityGlobalOust}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers     ${REQUEST_DATA['facilityDetails']['globalOutstandings']}    ${sfacilityGlobalOust}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers     ${REQUEST_DATA['facilityDetails']['globalOutstandings']}    ${sfacilityGlobalOust}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['globalOutstandings']}
    ...    ELSE    Log    Not Equal ${sfacilityGlobalOust} != ${Expect_facilityGlobalOust}    level=ERROR

    ${Expect_facilityGlobaAvailDraw}    Run Keyword If    '${sfacilityAvailableDraw}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityAvailableDraw}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers     ${REQUEST_DATA['facilityDetails']['globalAvailableToDraw']}    ${sfacilityAvailableDraw}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers     ${REQUEST_DATA['facilityDetails']['globalAvailableToDraw']}    ${sfacilityAvailableDraw}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['globalAvailableToDraw']}
    ...    ELSE    Log    Not Equal ${sfacilityAvailableDraw} != ${Expect_facilityGlobaAvailDraw}    level=ERROR
    
    ${Expect_facilityPortCode}    Run Keyword If    '${sfacilityPortCode}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityPortCode}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['facilityDetails']['portfolio']['code']}    ${sfacilityPortCode}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal    ${REQUEST_DATA['facilityDetails']['portfolio']['code']}    ${sfacilityPortCode}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['portfolio']['code']}
    ...    ELSE    Log    Not Equal ${sfacilityPortCode} != ${Expect_facilityPortCode}    level=ERROR

    ${Expect_facilityPortDesc}    Run Keyword If    '${facilityPortDesc}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${facilityPortDesc}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['facilityDetails']['portfolio']['description']}    ${facilityPortDesc}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal     ${REQUEST_DATA['facilityDetails']['portfolio']['description']}    ${facilityPortDesc}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['portfolio']['description']}
    ...    ELSE    Log    Not Equal ${facilityPortDesc} != ${Expect_facilityPortDesc}    level=ERROR

    ${Expect_facilityBranchCode}    Run Keyword If    '${sfacilityOwningBranchCode}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityOwningBranchCode}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['facilityDetails']['owningBranch']['code']}    ${sfacilityOwningBranchCode}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal     ${REQUEST_DATA['facilityDetails']['owningBranch']['code']}    ${sfacilityOwningBranchCode}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['owningBranch']['code']}
    ...    ELSE    Log    Not Equal ${sfacilityOwningBranchCode} != ${Expect_facilityBranchCode}    level=ERROR
    
    ${Expect_facilityBranchDesc}    Run Keyword If    '${sfacilityOwningBranchDesc}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfacilityOwningBranchDesc}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['facilityDetails']['owningBranch']['description']}    ${sfacilityOwningBranchDesc}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal     ${REQUEST_DATA['facilityDetails']['owningBranch']['description']}    ${sfacilityOwningBranchDesc}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['owningBranch']['description']}
    ...    ELSE    Log    Not Equal ${sfacilityOwningBranchDesc} != ${Expect_facilityBranchDesc}    level=ERROR

    ${Expect_fundingCode}    Run Keyword If    '${sfundingCode}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfundingCode}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['facilityDetails']['fundingDesk']['code']}    ${sfundingCode}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal     ${REQUEST_DATA['facilityDetails']['fundingDesk']['code']}    ${sfundingCode}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['fundingDesk']['code']}
    ...    ELSE    Log    Not Equal ${sfundingCode} != ${Expect_fundingCode}    level=ERROR

    ${Expect_fundingDesc}    Run Keyword If    '${sfundingDesc}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sfundingDesc}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['facilityDetails']['fundingDesk']['description']}    ${sfundingDesc}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal     ${REQUEST_DATA['facilityDetails']['fundingDesk']['description']}    ${sfundingDesc}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['fundingDesk']['description']}
    ...    ELSE    Log    Not Equal ${sfundingDesc} != ${Expect_fundingDesc}    level=ERROR

    ${Expect_ExpiryDate}    Run Keyword If    '${sexpiryDate}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sexpiryDate}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA['facilityDetails']['expiryDate']}    ${sexpiryDate}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal     ${REQUEST_DATA['facilityDetails']['expiryDate']}    ${sexpiryDate}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${REQUEST_DATA['facilityDetails']['expiryDate']}
    ...    ELSE    Log    Not Equal ${sexpiryDate} != ${Expect_ExpiryDate}    level=ERROR

    ##Get facility field values
    ${Expense_list}    Split String    ${sfacilityExpenseCode}    ,
    ${Expense_count}    Get Length    ${Expense_list}
    ${expenseDictionaryCode}    Create Dictionary
    :FOR    ${INDEX}    IN RANGE    ${Expense_count}
    \    ${val_expense}    Get From List    ${Expense_list}    ${INDEX}
    \    
    \    ${val_expense_List}    Split String    ${val_expense}    |
    \    ${Code}    Get From List    ${val_expense_List}    0
    \    ${Desc}    Get From List    ${val_expense_List}    1
    \    
    \    Set To Dictionary    ${expenseDictionaryCode}    code=${Code}
    \    Set To Dictionary    ${expenseDictionaryCode}    description=${Desc}
    \    Log    ${expenseDictionaryCode}
    \    Log    ${REQUEST_DATA['facilityDetails']['expense']}
    \    
    \    Run Keyword And Continue On Failure    Should Contain    ${REQUEST_DATA['facilityDetails']['expense']}    ${expenseDictionaryCode}
    \    ${Stat}    Run Keyword And Return Status    Should Contain    ${REQUEST_DATA['facilityDetails']['expense']}    ${expenseDictionaryCode}
    \    Run Keyword If    ${Stat}==${True}    Log     '${expenseDictionaryCode}' is existing in '${REQUEST_DATA['facilityDetails']['expense']}'
         ...    ELSE    Log    '${expenseDictionaryCode}' is NOT existing in '${REQUEST_DATA['facilityDetails']['expense']}'    level=ERROR
    \    Exit For Loop If    ${INDEX_0}==${Expense_count} or '${sfacilityExpenseCode}'==''

    ${JSON_File}    Set Variable    ${sResponseFilePath}${sResponseJson}.json
    Create File    ${dataset_path}${JSON_File}
    ${Content}    Convert To String    ${GET_response.content}
    Append To File    ${dataset_path}${JSON_File}    ${Content}

Validation for Outstandings 
    [Documentation]    This keyword is used to create session and get request for Outstanding 
    ...    @author: sacuisia    01AUG2019
    [Arguments]    ${COMID}    ${headers}    ${sResponseFilePath}    ${sResponseJson}    ${outstandingNo}    ${salias}
    ...    ${sriskType}    ${scurrency}    ${sEffectiveDate}    ${shostbanknet}    ${shostBankNetFacilityCCY}    ${smaturityExpiryDate}
    ...    ${scode}    ${sdescription}    ${smargin}    ${sallInRate}    ${saccruedInterest}    ${shostBankGross}    ${sglobalOriginal}
    ...    ${sglobalCurrent}    ${spaymentMode}    ${sintCycleFreq}            

    Delete All Sessions
    Create Session    COMHOST    ${COM_HOST}
    ${REQUEST_DATA_VAL}    GET Request API for Comsee Outstandings and Fees    COMHOST    ${MDM_COM_API_0}${COMID}/${outstandingNo}${MDM_COM_API_00}    ${Headers} 
   
    ${Expect_alias}    Run Keyword If    '${salias}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${salias}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA_VAL[0]['alias']}    ${salias}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal     ${REQUEST_DATA_VAL[0]['alias']}    ${salias}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${salias} =${Expect_alias}
    ...    ELSE    Log    Not Equal ${salias} != ${Expect_alias}    level=ERROR
    
    ${Expect_riskType}    Run Keyword If    '${sriskType}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sriskType}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA_VAL[0]['riskType']}    ${sriskType}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal     ${REQUEST_DATA_VAL[0]['riskType']}    ${sriskType}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sriskType} =${Expect_riskType}
    ...    ELSE    Log    Not Equal ${sriskType} != ${Expect_riskType}    level=ERROR

    ${Expect_currency}    Run Keyword If    '${scurrency}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${scurrency}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA_VAL[0]['currency']}    ${scurrency}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal     ${REQUEST_DATA_VAL[0]['currency']}    ${scurrency}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${scurrency} =${Expect_currency}
    ...    ELSE    Log    Not Equal ${scurrency} != ${Expect_currency}    level=ERROR

    ${Expect_effectivedate}    Run Keyword If    '${sEffectiveDate}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sEffectiveDate}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA_VAL[0]['effectiveDate']}    ${sEffectiveDate}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal     ${REQUEST_DATA_VAL[0]['effectiveDate']}    ${sEffectiveDate}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sEffectiveDate} =${Expect_effectivedate}
    ...    ELSE    Log    Not Equal ${sEffectiveDate} != ${Expect_effectivedate}    level=ERROR
    
    ${Expect_hostbanknet}    Run Keyword If    '${shostbanknet}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${shostbanknet}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers    ${REQUEST_DATA_VAL[0]['hostBankNet']}    ${shostbanknet}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers     ${REQUEST_DATA_VAL[0]['hostBankNet']}    ${shostbanknet}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${shostbanknet} =${Expect_hostbanknet}
    ...    ELSE    Log    Not Equal ${shostbanknet} != ${Expect_hostbanknet}    level=ERROR

    ${Expect_hostbanknetCCY}    Run Keyword If    '${shostBankNetFacilityCCY}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${shostBankNetFacilityCCY}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers    ${REQUEST_DATA_VAL[0]['hostBankNetFacilityCCY']}    ${shostBankNetFacilityCCY}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers     ${REQUEST_DATA_VAL[0]['hostBankNetFacilityCCY']}    ${shostBankNetFacilityCCY}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${shostBankNetFacilityCCY} =${Expect_hostbanknetCCY}
    ...    ELSE    Log    Not Equal ${shostBankNetFacilityCCY} != ${Expect_hostbanknetCCY}    level=ERROR

    ${Expect_maturityExpiryDate}    Run Keyword If    '${smaturityExpiryDate}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${smaturityExpiryDate}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA_VAL[0]['maturityExpiryDate']}    ${smaturityExpiryDate}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal     ${REQUEST_DATA_VAL[0]['maturityExpiryDate']}    ${smaturityExpiryDate}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${smaturityExpiryDate} =${Expect_maturityExpiryDate}
    ...    ELSE    Log    Not Equal ${smaturityExpiryDate} != ${Expect_maturityExpiryDate}    level=ERROR

    ${Expect_code}    Run Keyword If    '${scode}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${scode}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA_VAL[0]['pricingOption']['code']}    ${scode}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal     ${REQUEST_DATA_VAL[0]['pricingOption']['code']}    ${scode}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${scode} =${Expect_code}
    ...    ELSE    Log    Not Equal ${scode} != ${Expect_code}    level=ERROR

    ${Expect_desc}    Run Keyword If    '${sdescription}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sdescription}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA_VAL[0]['pricingOption']['description']}    ${sdescription}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal     ${REQUEST_DATA_VAL[0]['pricingOption']['description']}    ${sdescription}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sdescription} =${Expect_desc}
    ...    ELSE    Log    Not Equal ${sdescription} != ${Expect_desc}    level=ERROR

    ${Expect_margin}    Run Keyword If    '${smargin}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${smargin}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers    ${REQUEST_DATA_VAL[0]['margin']}    ${smargin}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers     ${REQUEST_DATA_VAL[0]['margin']}    ${smargin}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${smargin} =${Expect_margin}
    ...    ELSE    Log    Not Equal ${smargin} != ${Expect_margin}    level=ERROR

    ${Expect_allInRate}    Run Keyword If    '${sallInRate}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sallInRate}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers    ${REQUEST_DATA_VAL[0]['allInRate']}    ${sallInRate}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers     ${REQUEST_DATA_VAL[0]['allInRate']}    ${sallInRate}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sallInRate} =${Expect_allInRate}
    ...    ELSE    Log    Not Equal ${sallInRate} != ${Expect_allInRate}    level=ERROR

    ${Expect_accruedInterest}    Run Keyword If    '${saccruedInterest}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${saccruedInterest}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers    ${REQUEST_DATA_VAL[0]['accruedInterest']}    ${saccruedInterest}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers    ${REQUEST_DATA_VAL[0]['accruedInterest']}    ${saccruedInterest}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${saccruedInterest} =${Expect_accruedInterest}
    ...    ELSE    Log    Not Equal ${saccruedInterest} != ${Expect_accruedInterest}    level=ERROR

    ${Expect_hostBankGross}    Run Keyword If    '${shostBankGross}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${shostBankGross}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers    ${REQUEST_DATA_VAL[0]['hostBankGross']}    ${shostBankGross}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers     ${REQUEST_DATA_VAL[0]['hostBankGross']}    ${shostBankGross}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${shostBankGross} =${Expect_hostBankGross}
    ...    ELSE    Log    Not Equal ${shostBankGross} != ${Expect_hostBankGross}    level=ERROR

    ${Expect_globalOriginal}    Run Keyword If    '${sglobalOriginal}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sglobalOriginal}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers    ${REQUEST_DATA_VAL[0]['globalOriginal']}    ${sglobalOriginal}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers     ${REQUEST_DATA_VAL[0]['globalOriginal']}    ${sglobalOriginal}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sglobalOriginal} =${Expect_globalOriginal}
    ...    ELSE    Log    Not Equal ${sglobalOriginal} != ${Expect_globalOriginal}    level=ERROR

    ${Expect_globalCurrent}    Run Keyword If    '${sglobalCurrent}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sglobalCurrent}
    Run Keyword and Continue on Failure    Should Be Equal As Numbers    ${REQUEST_DATA_VAL[0]['globalCurrent']}    ${sglobalCurrent}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal As Numbers     ${REQUEST_DATA_VAL[0]['globalCurrent']}    ${sglobalCurrent}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sglobalCurrent} =${Expect_globalCurrent}
    ...    ELSE    Log    Not Equal ${sglobalCurrent} != ${Expect_globalOriginal}    level=ERROR

    ${Expect_paymentMode}    Run Keyword If    '${spaymentMode}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${spaymentMode}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA_VAL[0]['paymentMode']}    ${spaymentMode}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal     ${REQUEST_DATA_VAL[0]['paymentMode']}    ${spaymentMode}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${spaymentMode} =${Expect_paymentMode}
    ...    ELSE    Log    Not Equal ${spaymentMode} != ${Expect_paymentMode}    level=ERROR

    ${Expect_intCycleFreq}    Run Keyword If    '${sintCycleFreq}'==''    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${sintCycleFreq}
    Run Keyword and Continue on Failure    Should Be Equal    ${REQUEST_DATA_VAL[0]['intCycleFreq']}    ${sintCycleFreq}   
    ${Stat}    Run Keyword and Return Status    Should Be Equal     ${REQUEST_DATA_VAL[0]['intCycleFreq']}    ${sintCycleFreq}
    Run Keyword If    ${Stat}==${True}    Log    Correct! ${sintCycleFreq} =${Expect_intCycleFreq}
    ...    ELSE    Log    Not Equal ${sintCycleFreq} != ${Expect_intCycleFreq}    level=ERROR

    ${JSON_File}    Set Variable    ${sResponseFilePath}${sResponseJson}.json
    Create File    ${dataset_path}${JSON_File}
    Append To File    ${dataset_path}${JSON_File}    ${GET_response.content}

Validate JSON fields for Outstandings  
    [Documentation]    This keyword is used to validate  different payload in Outstandings.
    ...    @author: sacuisia 16AUG2019
    [Arguments]    ${COMID}    ${headers}    ${sResponseFilePath}    ${sResponseJson}    ${outstandingNo}    ${sOutstanding0}    

    Delete All Sessions
    Create Session    COMHOST    ${COM_HOST}
    ${REQUEST_DATA_VAL}    GET Request API for Comsee Outstandings and Fees    COMHOST    ${MDM_COM_API_0}${COMID}/${outstandingNo}${MDM_COM_API_00}    ${Headers} 
    
    ${soustlist_0}    Split String    ${sOutstanding0}    ,
    ${soustcount0}    Get Length    ${soustlist_0}
    ${oustDict}    Create Dictionary

    :FOR    ${INDEX}    IN RANGE    ${soustcount0}
    \    ${soust_val}    Get From List    ${soustlist_0}    ${INDEX}
    \    
    \    ${vallist0}    Split String    ${soust_val}    |
    \    ${val_alias}    Get From List    ${vallist0}    0
    \    ${val_riskType}    Get From List    ${vallist0}    1
    \    ${val_curr}    Get From List    ${vallist0}    2
    \    ${val_effectiveDate}    Get From List    ${vallist0}    3
    \    ${val_hostBankNet}    Get From List    ${vallist0}    4
    \    ${val_hostNetFacility}    Get From List    ${vallist0}    5
    \    ${val_maturityExpiryDate}    Get From List    ${vallist0}    6
    \    ${val_favoruee}    Get From List    ${vallist0}    7
    \    ${val_hostBankGross}    Get From List    ${vallist0}    8
    \    ${val_globalOrigin}    Get From List    ${vallist0}    9
    \    ${val_globalCurrent}    Get From List    ${vallist0}    10
    \    
    \    Set To Dictionary    ${oustDict}    alias=${val_alias}
    \    Set To Dictionary    ${oustDict}    riskType=${val_riskType}
    \    Set To Dictionary    ${oustDict}    currency=${val_curr}
    \    Set To Dictionary    ${oustDict}    effectiveDate=${val_effectiveDate}
    \    Set To Dictionary    ${oustDict}    hostBankNet=${val_hostBankNet}
    \    Set To Dictionary    ${oustDict}    hostBankNetFacilityCCY=${val_hostNetFacility}
    \    Set To Dictionary    ${oustDict}    maturityExpiryDate=${val_maturityExpiryDate}
    \    Set To Dictionary    ${oustDict}    favouree=${val_favoruee}
    \    Set To Dictionary    ${oustDict}    hostBankGross=${val_hostBankGross}
    \    Set To Dictionary    ${oustDict}    globalOriginal=${val_globalOrigin}
    \    Set To Dictionary    ${oustDict}    globalCurrent=${val_globalCurrent}
    \    
    \    
    \    Log    ${oustDict} 

    ${JSON_File}    Set Variable    ${sResponseFilePath}${sResponseJson}.json
    Create File    ${dataset_path}${JSON_File}
    Append To File    ${dataset_path}${JSON_File}    ${GET_response.content}

Validate Existing JSON fields for Oustandings
    [Documentation]    This Keyword is used to validate existing JSON field.  
    ...    @author: sacuisia    06AUG2019
    [Arguments]    ${sOutstandings_0}

    ${oust_list_0}    Split String    ${sOutstandings_0}    ,
    ${oust0_count}    Get Length    ${oust_list_0}
    ${oustDictionary0}    Create Dictionary

    :FOR    ${INDEX}    IN RANGE    ${oust0_count}
    \    ${sOust_val_0}    Get From List    ${oust_list_0}    ${INDEX}
    \    
    \    ${sOust_val_list_00}    Split String    ${sOust_val_0}    |
    \    ${val_repricingFrequency}    Get From List    ${sOust_val_list_00}    0
    \    ${val_repricingDate}    Get From List    ${sOust_val_list_00}    1
    \    ${val_code}    Get From List    ${sOust_val_list_00}    2
    \    ${val_description}    Get From List    ${sOust_val_list_00}    3
    \    ${val_margin}    Get From List    ${sOust_val_list_00}    4
    \    ${val_allInRate}    Get From List    ${sOust_val_list_00}    5
    \    ${val_accruedInterest}    Get From List    ${sOust_val_list_00}    6
    \    ${val_paymentMode}    Get From List    ${sOust_val_list_00}    7
    \    ${val_intCycleFreq}    Get From List    ${sOust_val_list_00}    8
    \    
    \    Set To Dictionary    ${oustDictionary0}    repricingFrequency=${val_repricingFrequency}         
    \    Set To Dictionary    ${oustDictionary0}    repricingDate=${val_repricingDate}
    \    Set To Dictionary    ${oustDictionary0}    code=${val_code}
    \    Set To Dictionary    ${oustDictionary0}    description=${val_description}
    \    Set To Dictionary    ${oustDictionary0}    margin=${val_margin}
    \    Set To Dictionary    ${oustDictionary0}    allInRate=${val_allInRate}
    \    Set To Dictionary    ${oustDictionary0}    accruedInterest=${val_accruedInterest}
    \    Set To Dictionary    ${oustDictionary0}    paymentMode=${val_paymentMode}
    \    Set To Dictionary    ${oustDictionary0}    intCycleFreq=${val_intCycleFreq}
    \    Log    ${oustDictionary0} 

    [Return]    ${oustDictionary0}    

Validation for Fees
    [Documentation]    This keyword is used to create session and get request for fees 
    ...    @author: sacuisia    01AUG2019
    [Arguments]    ${COMID}    ${headers}    ${sResponseFilePath}    ${sResponseJson}    ${feesNo}    ${sfees}    

    Delete All Sessions
    Create Session    COMHOST    ${COM_HOST}
    ${REQUEST_DATA_VAL}    GET Request API for Comsee Outstandings and Fees    COMHOST    ${MDM_COM_API_0}${COMID}/${feesNo}${MDM_COM_API_FEES}    ${Headers} 

    ${fees_list}    Split String    ${sfees}    ,
    ${fees_count}    Get Length    ${fees_list}
    ${feesDictionary}    Create Dictionary

    :FOR    ${INDEX}    IN RANGE    ${fees_count}
    \    ${sFees_val}    Get From List    ${fees_list}    ${INDEX}
    \    
    \    ${sfees_val_list}    Split String    ${sFees_val}    |
    \    ${val_level}    Get From List    ${sfees_val_list}    0
    \    ${val_name}    Get From List    ${sfees_val_list}    1
    \    ${val_fee}    Get From List    ${sfees_val_list}    2
    \    ${val_currency}    Get From List    ${sfees_val_list}    3
    \    ${val_currentRate}    Get From List    ${sfees_val_list}    4
    \    ${val_effectiveDate}    Get From List    ${sfees_val_list}    5
    \    ${val_expiryDate}    Get From List    ${sfees_val_list}    6
    \    ${val_feeAlias}    Get From List    ${sfees_val_list}    7
    \    ${val_status}    Get From List    ${sfees_val_list}    8
    \    ${val_accruedToDate}    Get From List    ${sfees_val_list}    9
    \    ${val_dueDate}    Get From List    ${sfees_val_list}    10
    \    
    \    Set To Dictionary    ${feesDictionary}    level=${val_level}         
    \    Set To Dictionary    ${feesDictionary}    name=${val_name}
    \    Set To Dictionary    ${feesDictionary}    fee=${val_fee}
    \    Set To Dictionary    ${feesDictionary}    currency=${val_currency}
    \    Set To Dictionary    ${feesDictionary}    currentRate=${val_currentRate}
    \    Set To Dictionary    ${feesDictionary}    effectiveDate=${val_effectiveDate}
    \    Set To Dictionary    ${feesDictionary}    expiryDate=${val_expiryDate}
    \    Set To Dictionary    ${feesDictionary}    feeAlias=${val_feeAlias}
    \    Set To Dictionary    ${feesDictionary}    status=${val_status}
    \    Set To Dictionary    ${feesDictionary}    accruedToDate=${val_accruedToDate}
    \    Set To Dictionary    ${feesDictionary}    dueDate=${val_dueDate}
    \    
    \    Log    ${feesDictionary}  

    ${JSON_File}    Set Variable    ${sResponseFilePath}${sResponseJson}.json
    Create File    ${dataset_path}${JSON_File}
    Append To File    ${dataset_path}${JSON_File}    ${GET_response.content}

Validation for Fees_Fields
    [Documentation]    This keyword is used to create session and get request for fees with additional fields. 
    ...    @author: sacuisia    08AUG2019
    [Arguments]    ${COMID}    ${headers}    ${sResponseFilePath}    ${sResponseJson}    ${feesNo}    ${sfees}    

    Delete All Sessions
    Create Session    COMHOST    ${COM_HOST}
    ${REQUEST_DATA_VAL}    GET Request API for Comsee Outstandings and Fees    COMHOST    ${MDM_COM_API_0}${COMID}/${feesNo}${MDM_COM_API_FEES}    ${Headers} 

    ${fees_list}    Split String    ${sfees}    ,
    ${fees_count}    Get Length    ${fees_list}
    ${feesDictionary}    Create Dictionary

    :FOR    ${INDEX}    IN RANGE    ${fees_count}
    \    ${sFees_val}    Get From List    ${fees_list}    ${INDEX}
    \    
    \    ${sfees_val_list}    Split String    ${sFees_val}    |
    \    ${val_level}    Get From List    ${sfees_val_list}    0
    \    ${val_name}    Get From List    ${sfees_val_list}    1
    \    ${val_fee}    Get From List    ${sfees_val_list}    2
    \    ${val_currency}    Get From List    ${sfees_val_list}    3
    \    ${val_currentRate}    Get From List    ${sfees_val_list}    4
    \    ${val_effectiveDate}    Get From List    ${sfees_val_list}    5
    \    ${val_expiryDate}    Get From List    ${sfees_val_list}    6
    \    ${val_accruedToDate}    Get From List    ${sfees_val_list}    7
    \    ${val_dueDate}    Get From List    ${sfees_val_list}    8
    \    
    \    Set To Dictionary    ${feesDictionary}    level=${val_level}         
    \    Set To Dictionary    ${feesDictionary}    name=${val_name}
    \    Set To Dictionary    ${feesDictionary}    fee=${val_fee}
    \    Set To Dictionary    ${feesDictionary}    currency=${val_currency}
    \    Set To Dictionary    ${feesDictionary}    currentRate=${val_currentRate}
    \    Set To Dictionary    ${feesDictionary}    effectiveDate=${val_effectiveDate}
    \    Set To Dictionary    ${feesDictionary}    expiryDate=${val_expiryDate}
    \    Set To Dictionary    ${feesDictionary}    accruedToDate=${val_accruedToDate}
    \    Set To Dictionary    ${feesDictionary}    dueDate=${val_dueDate}
    \    
    \    Log    ${feesDictionary}  


    ${JSON_File}    Set Variable    ${sResponseFilePath}${sResponseJson}.json
    Create File    ${dataset_path}${JSON_File}
    Append To File    ${dataset_path}${JSON_File}    ${GET_response.content}

Get Risk Type and Validate Response Per Risk Type
    [Documentation]    This keyword is used to get risk type from input dataset and validate response file per  risk type.
    ...    @author: clanding    20AUG2019    - initial create
    ...    @update: clanding    23AUG2019    - adding logic handling for checking pricing option of FIXED and risk type of LOAN
    ...    @update: clanding    26AUG2019    - renamed 'Get Input Alias and Return Index' keyword to Get Input Value and Return Index
    [Arguments]    ${sOutputFilePath}    ${sOutputFile}    ${sExp_Alias}    ${sExp_RiskType}    ${sExp_Currency}    ${sExp_EffDate}    ${iExp_HostBankNet}
    ...    ${iExp_HostBankNetFac}    ${sExp_MaturityDate}    ${sExp_Favouree}    ${iExp_HostBankGross}    ${iExp_GlobalOriginal}    ${iExp_GlobalCurrent}    
    ...    ${sRepFreq}    ${sRepDate}    ${sPayMode}    ${sIntCycleFreq}    ${sPricingOption}    ${iMargin}    ${iAllInRate}    ${iAccruedInterest}    ${sDelimiter}
    ${Response_Payload}    OperatingSystem.Get File    ${datasetpath}${sOutputFilePath}${sOutputFile}.${JSON}
    ${Response_Payload}    Strip String    ${Response_Payload}    mode=left    characters=[
    ${Response_Payload}    Strip String    ${Response_Payload}    mode=right    characters=]
    ${Response_Payload_List}    Split String    ${Response_Payload}    },{
    ${JsonCount}    Get Length    ${Response_Payload_List}

    :FOR    ${Index_Output}    IN RANGE    ${JsonCount}
    \    ${LastIndex}    Evaluate    ${JsonCount}-1    
    \    ${JSON_Value}    Get From List    ${Response_Payload_List}    ${Index_Output}
    \    ${IsEvenOrOdd}    Evaluate    int('${Index_Output}')%2
    \    ${Separated_JSON_Value}    Run Keyword If    ${IsEvenOrOdd}==0 and ${Index_Output}==0 and ${LastIndex}!=0    Catenate    SEPARATOR=    ${JSON_Value}    }
         ...    ELSE IF    ${IsEvenOrOdd}==0 and ${Index_Output}==0 and ${LastIndex}==0    Set Variable    ${JSON_Value}
         ...    ELSE IF    ${IsEvenOrOdd}==0 and ${Index_Output}==${LastIndex}    Catenate    SEPARATOR=    {    ${JSON_Value}
         ...    ELSE IF    ${IsEvenOrOdd}==1 and ${Index_Output}==${LastIndex}    Catenate    SEPARATOR=    {    ${JSON_Value}
         ...    ELSE    Catenate    SEPARATOR=    {    ${JSON_Value}    }
    \    Log    ${Separated_JSON_Value}
    \    
    \    Create File    ${dataset_path}${sOutputFilePath}tempfile.json    ${Separated_JSON_Value}
    \    
    \    ### Get JSON field values ###
    \    ${Json_Object}    Load JSON From File    ${dataset_path}${sOutputFilePath}tempfile.json
    \    Log    ${Json_Object}
    \    ${Actual_RiskType_List}    Get Value From Json    ${Json_Object}    $..riskType
    \    ${Actual_Alias_List}    Get Value From Json    ${Json_Object}    $..alias
    \    ${Actual_PricingOption_List}    Get Value From Json    ${Json_Object}    $..pricingOption
    \    ${Code}    Run Keyword If    '@{Actual_RiskType_List}[0]'=='Loan' or '@{Actual_RiskType_List}[0]'=='Fixed Rate Loan'    Get From Dictionary    @{Actual_PricingOption_List}[0]    code
         ...    ELSE    Create List    ${NONE}    
    \    ${Index_Input}    Get Input Value and Return Index    ${sExp_Alias}    @{Actual_Alias_List}[0]    ${sDelimiter}
    \    
    \    Run Keyword If    '@{Actual_RiskType_List}[0]'=='Financial Guarantee' or '@{Actual_RiskType_List}[0]'=='Performance / Non-Financial Syndicated Fronted BG'    Validate SBLC or Guarantee Risk Type    ${Json_Object}    ${sExp_Alias}    
         ...    ${sExp_RiskType}    ${sExp_Currency}    ${sExp_EffDate}    ${iExp_HostBankNet}    ${iExp_HostBankNetFac}    ${sExp_MaturityDate}    ${sExp_Favouree}    
         ...    ${iExp_HostBankGross}    ${iExp_GlobalOriginal}    ${iExp_GlobalCurrent}    ${Index_Input}    ${sDelimiter}
         ...    ELSE IF    '@{Actual_RiskType_List}[0]'=='Loan' and '${Code}'!='FIXED'    Validate Loan Risk Type    ${Json_Object}    ${sExp_Alias}    ${sExp_RiskType}    ${sExp_Currency}    
         ...    ${sExp_EffDate}    ${iExp_HostBankNet}    ${iExp_HostBankNetFac}    ${sExp_MaturityDate}    ${iExp_HostBankGross}    ${iExp_GlobalOriginal}    ${iExp_GlobalCurrent}    
         ...    ${sRepFreq}    ${sRepDate}    ${sPayMode}    ${sIntCycleFreq}    ${sPricingOption}    ${iMargin}    ${iAllInRate}    ${iAccruedInterest}    ${Index_Input}    ${sDelimiter}
         ...    ELSE IF    '@{Actual_RiskType_List}[0]'=='Loan' and '${Code}'=='FIXED'    Validate Fixed Rate Loan Risk Type    ${Json_Object}    ${sExp_Alias}    ${sExp_RiskType}    ${sExp_Currency}    
         ...    ${sExp_EffDate}    ${iExp_HostBankNet}    ${iExp_HostBankNetFac}    ${sExp_MaturityDate}    ${iExp_HostBankGross}    ${iExp_GlobalOriginal}    ${iExp_GlobalCurrent}    
         ...    ${sPayMode}    ${sIntCycleFreq}    ${sPricingOption}    ${iMargin}    ${iAllInRate}    ${iAccruedInterest}    ${Index_Input}    ${sDelimiter}
         ...    ELSE IF    '@{Actual_RiskType_List}[0]'=='Fixed Rate Loan'    Validate Fixed Rate Loan Risk Type    ${Json_Object}    ${sExp_Alias}    ${sExp_RiskType}    ${sExp_Currency}    
         ...    ${sExp_EffDate}    ${iExp_HostBankNet}    ${iExp_HostBankNetFac}    ${sExp_MaturityDate}    ${iExp_HostBankGross}    ${iExp_GlobalOriginal}    ${iExp_GlobalCurrent}    
         ...    ${sPayMode}    ${sIntCycleFreq}    ${sPricingOption}    ${iMargin}    ${iAllInRate}    ${iAccruedInterest}    ${Index_Input}    ${sDelimiter}
    \    
    \    Delete File If Exist    ${dataset_path}${sOutputFilePath}tempfile.json

Validate SBLC or Guarantee Risk Type
    [Documentation]    This keyword is used to validate response generated by Get API (Commsee) and compare to input dataset for SBLC and Guarantee Risk Type.
    ...    @author: clanding    20AUG2019    - initial create
    [Arguments]    ${oJson}    ${sExp_Alias}    ${sExp_RiskType}    ${sExp_Currency}    ${sExp_EffDate}    ${iExp_HostBankNet}    ${iExp_HostBankNetFac}
    ...    ${sExp_MaturityDate}    ${sExp_Favouree}    ${iExp_HostBankGross}    ${iExp_GlobalOriginal}    ${iExp_GlobalCurrent}    ${iIndex_Input}    ${sDelimiter}

    ### Get JSON field values ###
    Log    ${oJson}
    ${Actual_RiskType_List}    Get Value From Json    ${oJson}    $..riskType
    ${Actual_Alias_List}    Get Value From Json    ${oJson}    $..alias
    ${Actual_Currency_List}    Get Value From Json    ${oJson}    $..currency
    ${Actual_EffDate_List}    Get Value From Json    ${oJson}    $..effectiveDate
    ${Actual_HostBankNet_List}    Get Value From Json    ${oJson}    $..hostBankNet
    ${Actual_HostBankNetFac_List}    Get Value From Json    ${oJson}    $..hostBankNetFacilityCCY
    ${Actual_MaturityExpDate_List}    Get Value From Json    ${oJson}    $..maturityExpiryDate
    ${Actual_Favouree_List}    Get Value From Json    ${oJson}    $..favouree
    ${Actual_HostBankGross_List}    Get Value From Json    ${oJson}    $..hostBankGross
    ${Actual_GlobalOriginal_List}    Get Value From Json    ${oJson}    $..globalOriginal
    ${Actual_GlobalCurrent_List}    Get Value From Json    ${oJson}    $..globalCurrent

    ### Get Dataset values ###
    @{Input_Alias_List}    Split String    ${sExp_Alias}    ${sDelimiter}
    @{Input_RiskType_List}    Split String    ${sExp_RiskType}    ${sDelimiter}
    @{Input_Currency_List}    Split String    ${sExp_Currency}    ${sDelimiter}
    @{Input_EffDate_List}    Split String    ${sExp_EffDate}    ${sDelimiter}
    @{Input_HostBankNet_List}    Split String    ${iExp_HostBankNet}    ${sDelimiter}
    @{Input_HostBankNetFac_List}    Split String    ${iExp_HostBankNetFac}    ${sDelimiter}
    @{Input_MaturityDate_List}    Split String    ${sExp_MaturityDate}    ${sDelimiter}
    @{Input_Favouree_List}    Split String    ${sExp_Favouree}    ${sDelimiter}
    @{Input_HostBankGross_List}    Split String    ${iExp_HostBankGross}    ${sDelimiter}
    @{Input_GlobalOriginal_List}    Split String    ${iExp_GlobalOriginal}    ${sDelimiter}
    @{Input_GlobalCurrent_List}    Split String    ${iExp_GlobalCurrent}    ${sDelimiter}

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_Alias_List}[${iIndex_Input}]    @{Actual_Alias_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_Alias_List}[${iIndex_Input}]    @{Actual_Alias_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_Alias_List}[${iIndex_Input}] = @{Actual_Alias_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_Alias_List}[${iIndex_Input}] != @{Actual_Alias_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_RiskType_List}[${iIndex_Input}]    @{Actual_RiskType_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_RiskType_List}[${iIndex_Input}]    @{Actual_RiskType_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_RiskType_List}[${iIndex_Input}] = @{Actual_RiskType_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_RiskType_List}[${iIndex_Input}] != @{Actual_RiskType_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_Currency_List}[${iIndex_Input}]    @{Actual_Currency_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_Currency_List}[${iIndex_Input}]    @{Actual_Currency_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_Currency_List}[${iIndex_Input}] = @{Actual_Currency_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_Currency_List}[${iIndex_Input}] != @{Actual_Currency_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_EffDate_List}[${iIndex_Input}]    @{Actual_EffDate_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_EffDate_List}[${iIndex_Input}]    @{Actual_EffDate_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_EffDate_List}[${iIndex_Input}] = @{Actual_EffDate_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_EffDate_List}[${iIndex_Input}] != @{Actual_EffDate_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_HostBankNet_List}[${iIndex_Input}]    @{Actual_HostBankNet_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_HostBankNet_List}[${iIndex_Input}]    @{Actual_HostBankNet_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_HostBankNet_List}[${iIndex_Input}] = @{Actual_HostBankNet_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_HostBankNet_List}[${iIndex_Input}] != @{Actual_HostBankNet_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_HostBankNetFac_List}[${iIndex_Input}]    @{Actual_HostBankNetFac_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_HostBankNetFac_List}[${iIndex_Input}]    @{Actual_HostBankNetFac_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_HostBankNetFac_List}[${iIndex_Input}] = @{Actual_HostBankNetFac_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_HostBankNetFac_List}[${iIndex_Input}] != @{Actual_HostBankNetFac_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_MaturityDate_List}[${iIndex_Input}]    @{Actual_MaturityExpDate_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_MaturityDate_List}[${iIndex_Input}]    @{Actual_MaturityExpDate_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_MaturityDate_List}[${iIndex_Input}] = @{Actual_MaturityExpDate_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_MaturityDate_List}[${iIndex_Input}] != @{Actual_MaturityExpDate_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_Favouree_List}[${iIndex_Input}]    @{Actual_Favouree_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_Favouree_List}[${iIndex_Input}]    @{Actual_Favouree_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_Favouree_List}[${iIndex_Input}] = @{Actual_Favouree_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_Favouree_List}[${iIndex_Input}] != @{Actual_Favouree_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_HostBankGross_List}[${iIndex_Input}]    @{Actual_HostBankGross_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_HostBankGross_List}[${iIndex_Input}]    @{Actual_HostBankGross_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_HostBankGross_List}[${iIndex_Input}] = @{Actual_HostBankGross_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_HostBankGross_List}[${iIndex_Input}] != @{Actual_HostBankGross_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_GlobalOriginal_List}[${iIndex_Input}]    @{Actual_GlobalOriginal_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_GlobalOriginal_List}[${iIndex_Input}]    @{Actual_GlobalOriginal_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_GlobalOriginal_List}[${iIndex_Input}] = @{Actual_GlobalOriginal_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_GlobalOriginal_List}[${iIndex_Input}] != @{Actual_GlobalOriginal_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_GlobalCurrent_List}[${iIndex_Input}]    @{Actual_GlobalCurrent_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_GlobalCurrent_List}[${iIndex_Input}]    @{Actual_GlobalCurrent_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_GlobalCurrent_List}[${iIndex_Input}] = @{Actual_GlobalCurrent_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_GlobalCurrent_List}[${iIndex_Input}] != @{Actual_GlobalCurrent_List}[0]    level=ERROR

Get Input Value and Return Index
    [Documentation]    This keyword is used to get any value from dataset and split by sDelimiter and compare with Alias from response payload and return index.
    ...    @author: clanding    20AUG2019    - initial create
    ...    @update: clanding    26AUG2019    - renamed Alias to Value, to make the keyword generic
    [Arguments]    ${sInputValue}    ${sOutputValue}    ${sDelimiter}

    ${Value_List}    Split String    ${sInputValue}    ${sDelimiter}
    ${Value_Count}    Get Length    ${Value_List}

    :FOR    ${Index}    IN RANGE    ${Value_Count}
    \    ${Value}    Get From List    ${Value_List}    ${Index}
    \    Exit For Loop If    '${Value}'=='${sOutputValue}'
    [Return]    ${Index}

Validate Loan Risk Type
    [Documentation]    This keyword is used to validate response generated by Get API (Commsee) and compare to input dataset for Loan Risk Type.
    ...    @author: clanding    21AUG2019    - initial create
    [Arguments]    ${oJson}    ${sExp_Alias}    ${sExp_RiskType}    ${sExp_Currency}    ${sExp_EffDate}    ${iExp_HostBankNet}    ${iExp_HostBankNetFac}
    ...    ${sExp_MaturityDate}    ${iExp_HostBankGross}    ${iExp_GlobalOriginal}    ${iExp_GlobalCurrent}    ${sExp_RepFreq}    ${sExp_RepDate}    ${sPayMode}    ${sIntCycleFreq}
    ...    ${sPricingOption}    ${iMargin}    ${iAllInRate}    ${iAccruedInterest}    ${iIndex_Input}    ${sDelimiter}

    ### Get JSON field values ###
    Log    ${oJson}
    ${Actual_RiskType_List}    Get Value From Json    ${oJson}    $..riskType
    ${Actual_Alias_List}    Get Value From Json    ${oJson}    $..alias
    ${Actual_Currency_List}    Get Value From Json    ${oJson}    $..currency
    ${Actual_EffDate_List}    Get Value From Json    ${oJson}    $..effectiveDate
    ${Actual_HostBankNet_List}    Get Value From Json    ${oJson}    $..hostBankNet
    ${Actual_HostBankNetFac_List}    Get Value From Json    ${oJson}    $..hostBankNetFacilityCCY
    ${Actual_MaturityExpDate_List}    Get Value From Json    ${oJson}    $..maturityExpiryDate
    ${Actual_HostBankGross_List}    Get Value From Json    ${oJson}    $..hostBankGross
    ${Actual_GlobalOriginal_List}    Get Value From Json    ${oJson}    $..globalOriginal
    ${Actual_GlobalCurrent_List}    Get Value From Json    ${oJson}    $..globalCurrent
    ${Actual_RepricingFrequency_List}    Get Value From Json    ${oJson}    $..repricingFrequency
    ${Actual_RepricingDate_List}    Get Value From Json    ${oJson}    $..repricingDate
    ${Actual_PaymentMode_List}    Get Value From Json    ${oJson}    $..paymentMode
    ${Actual_IntCycleFreq_List}    Get Value From Json    ${oJson}    $..intCycleFreq
    ${Actual_PricingOption_List}    Get Value From Json    ${oJson}    $..pricingOption
    ${Actual_Margin_List}    Get Value From Json    ${oJson}    $..margin
    ${Actual_AllInRate_List}    Get Value From Json    ${oJson}    $..allInRate
    ${Actual_AccruedInterest_List}    Get Value From Json    ${oJson}    $..accruedInterest

    ### Get Dataset values ###
    @{Input_Alias_List}    Split String    ${sExp_Alias}    ${sDelimiter}
    @{Input_RiskType_List}    Split String    ${sExp_RiskType}    ${sDelimiter}
    @{Input_Currency_List}    Split String    ${sExp_Currency}    ${sDelimiter}
    @{Input_EffDate_List}    Split String    ${sExp_EffDate}    ${sDelimiter}
    @{Input_HostBankNet_List}    Split String    ${iExp_HostBankNet}    ${sDelimiter}
    @{Input_HostBankNetFac_List}    Split String    ${iExp_HostBankNetFac}    ${sDelimiter}
    @{Input_MaturityDate_List}    Split String    ${sExp_MaturityDate}    ${sDelimiter}
    @{Input_HostBankGross_List}    Split String    ${iExp_HostBankGross}    ${sDelimiter}
    @{Input_GlobalOriginal_List}    Split String    ${iExp_GlobalOriginal}    ${sDelimiter}
    @{Input_GlobalCurrent_List}    Split String    ${iExp_GlobalCurrent}    ${sDelimiter}
    @{Input_RepFreq_List}    Split String    ${sExp_RepFreq}    ${sDelimiter}
    @{Input_RepDate_List}    Split String    ${sExp_RepDate}    ${sDelimiter}
    @{Input_PayMode_List}    Split String    ${sPayMode}    ${sDelimiter}
    @{Input_IntCycleFreq_List}    Split String    ${sIntCycleFreq}    ${sDelimiter}
    @{Input_Margin_List}    Split String    ${iMargin}    ${sDelimiter}
    @{Input_AllInRate_List}    Split String    ${iAllInRate}    ${sDelimiter}
    @{Input_AccruedInterest_List}    Split String    ${iAccruedInterest}    ${sDelimiter}
    @{Input_PricingOption_List}    Split String    ${sPricingOption}    ${sDelimiter}
    
    ${PricingOption_List}    Split String    @{Input_PricingOption_List}[${iIndex_Input}]    /
    ${PricingOption_Dict}    Create Dictionary
    ${Count}    Get Length    ${PricingOption_List}
    :FOR    ${Index}    IN RANGE    ${Count}
    \    Exit For Loop If    '${Index}'=='${Count}'
    \    ${PricingOption}    Get From List    ${PricingOption_List}    ${Index}
    \    Run Keyword If    '${Index}'=='0'    Set To Dictionary    ${PricingOption_Dict}    code=${PricingOption}
         ...    ELSE IF    '${Index}'=='1'    Set To Dictionary    ${PricingOption_Dict}    description=${PricingOption}
    \    Log    ${PricingOption_Dict}
    Log    ${PricingOption_Dict}

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_Alias_List}[${iIndex_Input}]    @{Actual_Alias_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_Alias_List}[${iIndex_Input}]    @{Actual_Alias_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_Alias_List}[${iIndex_Input}] = @{Actual_Alias_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_Alias_List}[${iIndex_Input}] != @{Actual_Alias_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_RiskType_List}[${iIndex_Input}]    @{Actual_RiskType_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_RiskType_List}[${iIndex_Input}]    @{Actual_RiskType_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_RiskType_List}[${iIndex_Input}] = @{Actual_RiskType_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_RiskType_List}[${iIndex_Input}] != @{Actual_RiskType_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_Currency_List}[${iIndex_Input}]    @{Actual_Currency_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_Currency_List}[${iIndex_Input}]    @{Actual_Currency_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_Currency_List}[${iIndex_Input}] = @{Actual_Currency_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_Currency_List}[${iIndex_Input}] != @{Actual_Currency_List}[0]    level=ERROR
    
    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_EffDate_List}[${iIndex_Input}]    @{Actual_EffDate_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_EffDate_List}[${iIndex_Input}]    @{Actual_EffDate_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_EffDate_List}[${iIndex_Input}] = @{Actual_EffDate_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_EffDate_List}[${iIndex_Input}] != @{Actual_EffDate_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_HostBankNet_List}[${iIndex_Input}]    @{Actual_HostBankNet_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_HostBankNet_List}[${iIndex_Input}]    @{Actual_HostBankNet_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_HostBankNet_List}[${iIndex_Input}] = @{Actual_HostBankNet_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_HostBankNet_List}[${iIndex_Input}] != @{Actual_HostBankNet_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_HostBankNetFac_List}[${iIndex_Input}]    @{Actual_HostBankNetFac_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_HostBankNetFac_List}[${iIndex_Input}]    @{Actual_HostBankNetFac_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_HostBankNetFac_List}[${iIndex_Input}] = @{Actual_HostBankNetFac_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_HostBankNetFac_List}[${iIndex_Input}] != @{Actual_HostBankNetFac_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_MaturityDate_List}[${iIndex_Input}]    @{Actual_MaturityExpDate_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_MaturityDate_List}[${iIndex_Input}]    @{Actual_MaturityExpDate_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_MaturityDate_List}[${iIndex_Input}] = @{Actual_MaturityExpDate_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_MaturityDate_List}[${iIndex_Input}] != @{Actual_MaturityExpDate_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_HostBankGross_List}[${iIndex_Input}]    @{Actual_HostBankGross_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_HostBankGross_List}[${iIndex_Input}]    @{Actual_HostBankGross_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_HostBankGross_List}[${iIndex_Input}] = @{Actual_HostBankGross_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_HostBankGross_List}[${iIndex_Input}] != @{Actual_HostBankGross_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_GlobalOriginal_List}[${iIndex_Input}]    @{Actual_GlobalOriginal_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_GlobalOriginal_List}[${iIndex_Input}]    @{Actual_GlobalOriginal_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_GlobalOriginal_List}[${iIndex_Input}] = @{Actual_GlobalOriginal_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_GlobalOriginal_List}[${iIndex_Input}] != @{Actual_GlobalOriginal_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_GlobalCurrent_List}[${iIndex_Input}]    @{Actual_GlobalCurrent_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_GlobalCurrent_List}[${iIndex_Input}]    @{Actual_GlobalCurrent_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_GlobalCurrent_List}[${iIndex_Input}] = @{Actual_GlobalCurrent_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_GlobalCurrent_List}[${iIndex_Input}] != @{Actual_GlobalCurrent_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_RepFreq_List}[${iIndex_Input}]    @{Actual_RepricingFrequency_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_RepFreq_List}[${iIndex_Input}]    @{Actual_RepricingFrequency_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_RepFreq_List}[${iIndex_Input}] = @{Actual_RepricingFrequency_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_RepFreq_List}[${iIndex_Input}] != @{Actual_RepricingFrequency_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_RepDate_List}[${iIndex_Input}]    @{Actual_RepricingDate_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_RepDate_List}[${iIndex_Input}]    @{Actual_RepricingDate_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_RepDate_List}[${iIndex_Input}] = @{Actual_RepricingDate_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_RepDate_List}[${iIndex_Input}] != @{Actual_RepricingDate_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_PayMode_List}[${iIndex_Input}]    @{Actual_PaymentMode_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_PayMode_List}[${iIndex_Input}]    @{Actual_PaymentMode_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_PayMode_List}[${iIndex_Input}] = @{Actual_PaymentMode_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_PayMode_List}[${iIndex_Input}] != @{Actual_PaymentMode_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_IntCycleFreq_List}[${iIndex_Input}]    @{Actual_IntCycleFreq_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_IntCycleFreq_List}[${iIndex_Input}]    @{Actual_IntCycleFreq_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_IntCycleFreq_List}[${iIndex_Input}] = @{Actual_IntCycleFreq_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_IntCycleFreq_List}[${iIndex_Input}] != @{Actual_IntCycleFreq_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_Margin_List}[${iIndex_Input}]    @{Actual_Margin_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_Margin_List}[${iIndex_Input}]    @{Actual_Margin_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_Margin_List}[${iIndex_Input}] = @{Actual_Margin_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_Margin_List}[${iIndex_Input}] != @{Actual_Margin_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_AllInRate_List}[${iIndex_Input}]    @{Actual_AllInRate_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_AllInRate_List}[${iIndex_Input}]    @{Actual_AllInRate_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_AllInRate_List}[${iIndex_Input}] = @{Actual_AllInRate_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_AllInRate_List}[${iIndex_Input}] != @{Actual_AllInRate_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_AccruedInterest_List}[${iIndex_Input}]    @{Actual_AccruedInterest_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_AccruedInterest_List}[${iIndex_Input}]    @{Actual_AccruedInterest_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_AccruedInterest_List}[${iIndex_Input}] = @{Actual_AccruedInterest_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_AccruedInterest_List}[${iIndex_Input}] != @{Actual_AccruedInterest_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${PricingOption_Dict}    @{Actual_PricingOption_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${PricingOption_Dict}    @{Actual_PricingOption_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. ${PricingOption_Dict} = @{Actual_PricingOption_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. ${PricingOption_Dict} != @{Actual_PricingOption_List}[0]    level=ERROR

Validate Fixed Rate Loan Risk Type
    [Documentation]    This keyword is used to validate response generated by Get API (Commsee) and compare to input dataset for Fized Rate Loan Risk Type.
    ...    @author: clanding    21AUG2019    - initial create
    [Arguments]    ${oJson}    ${sExp_Alias}    ${sExp_RiskType}    ${sExp_Currency}    ${sExp_EffDate}    ${iExp_HostBankNet}    ${iExp_HostBankNetFac}
    ...    ${sExp_MaturityDate}    ${iExp_HostBankGross}    ${iExp_GlobalOriginal}    ${iExp_GlobalCurrent}    ${sPayMode}    ${sIntCycleFreq}
    ...    ${sPricingOption}    ${iMargin}    ${iAllInRate}    ${iAccruedInterest}    ${iIndex_Input}    ${sDelimiter}

    ### Get JSON field values ###
    Log    ${oJson}
    ${Actual_RiskType_List}    Get Value From Json    ${oJson}    $..riskType
    ${Actual_Alias_List}    Get Value From Json    ${oJson}    $..alias
    ${Actual_Currency_List}    Get Value From Json    ${oJson}    $..currency
    ${Actual_EffDate_List}    Get Value From Json    ${oJson}    $..effectiveDate
    ${Actual_HostBankNet_List}    Get Value From Json    ${oJson}    $..hostBankNet
    ${Actual_HostBankNetFac_List}    Get Value From Json    ${oJson}    $..hostBankNetFacilityCCY
    ${Actual_MaturityExpDate_List}    Get Value From Json    ${oJson}    $..maturityExpiryDate
    ${Actual_HostBankGross_List}    Get Value From Json    ${oJson}    $..hostBankGross
    ${Actual_GlobalOriginal_List}    Get Value From Json    ${oJson}    $..globalOriginal
    ${Actual_GlobalCurrent_List}    Get Value From Json    ${oJson}    $..globalCurrent
    ${Actual_PaymentMode_List}    Get Value From Json    ${oJson}    $..paymentMode
    ${Actual_IntCycleFreq_List}    Get Value From Json    ${oJson}    $..intCycleFreq
    ${Actual_PricingOption_List}    Get Value From Json    ${oJson}    $..pricingOption
    ${Actual_Margin_List}    Get Value From Json    ${oJson}    $..margin
    ${Actual_AllInRate_List}    Get Value From Json    ${oJson}    $..allInRate
    ${Actual_AccruedInterest_List}    Get Value From Json    ${oJson}    $..accruedInterest

    ### Get Dataset values ###
    @{Input_Alias_List}    Split String    ${sExp_Alias}    ${sDelimiter}
    @{Input_RiskType_List}    Split String    ${sExp_RiskType}    ${sDelimiter}
    @{Input_Currency_List}    Split String    ${sExp_Currency}    ${sDelimiter}
    @{Input_EffDate_List}    Split String    ${sExp_EffDate}    ${sDelimiter}
    @{Input_HostBankNet_List}    Split String    ${iExp_HostBankNet}    ${sDelimiter}
    @{Input_HostBankNetFac_List}    Split String    ${iExp_HostBankNetFac}    ${sDelimiter}
    @{Input_MaturityDate_List}    Split String    ${sExp_MaturityDate}    ${sDelimiter}
    @{Input_HostBankGross_List}    Split String    ${iExp_HostBankGross}    ${sDelimiter}
    @{Input_GlobalOriginal_List}    Split String    ${iExp_GlobalOriginal}    ${sDelimiter}
    @{Input_GlobalCurrent_List}    Split String    ${iExp_GlobalCurrent}    ${sDelimiter}
    @{Input_PayMode_List}    Split String    ${sPayMode}    ${sDelimiter}
    @{Input_IntCycleFreq_List}    Split String    ${sIntCycleFreq}    ${sDelimiter}
    @{Input_Margin_List}    Split String    ${iMargin}    ${sDelimiter}
    @{Input_AllInRate_List}    Split String    ${iAllInRate}    ${sDelimiter}
    @{Input_AccruedInterest_List}    Split String    ${iAccruedInterest}    ${sDelimiter}
    @{Input_PricingOption_List}    Split String    ${sPricingOption}    ${sDelimiter}
    
    ${PricingOption_List}    Split String    @{Input_PricingOption_List}[${iIndex_Input}]    /
    ${PricingOption_Dict}    Create Dictionary
    ${Count}    Get Length    ${PricingOption_List}

    :FOR    ${Index}    IN RANGE    ${Count}
    \    Exit For Loop If    '${Index}'=='${Count}'
    \    ${PricingOption}    Get From List    ${PricingOption_List}    ${Index}
    \    Run Keyword If    '${Index}'=='0'    Set To Dictionary    ${PricingOption_Dict}    code=${PricingOption}
         ...    ELSE IF    '${Index}'=='1'    Set To Dictionary    ${PricingOption_Dict}    description=${PricingOption}
    \    Log    ${PricingOption_Dict}
    Log    ${PricingOption_Dict}

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_Alias_List}[${iIndex_Input}]    @{Actual_Alias_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_Alias_List}[${iIndex_Input}]    @{Actual_Alias_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_Alias_List}[${iIndex_Input}] = @{Actual_Alias_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_Alias_List}[${iIndex_Input}] != @{Actual_Alias_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_RiskType_List}[${iIndex_Input}]    @{Actual_RiskType_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_RiskType_List}[${iIndex_Input}]    @{Actual_RiskType_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_RiskType_List}[${iIndex_Input}] = @{Actual_RiskType_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_RiskType_List}[${iIndex_Input}] != @{Actual_RiskType_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_Currency_List}[${iIndex_Input}]    @{Actual_Currency_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_Currency_List}[${iIndex_Input}]    @{Actual_Currency_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_Currency_List}[${iIndex_Input}] = @{Actual_Currency_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_Currency_List}[${iIndex_Input}] != @{Actual_Currency_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_EffDate_List}[${iIndex_Input}]    @{Actual_EffDate_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_EffDate_List}[${iIndex_Input}]    @{Actual_EffDate_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_EffDate_List}[${iIndex_Input}] = @{Actual_EffDate_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_EffDate_List}[${iIndex_Input}] != @{Actual_EffDate_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_HostBankNet_List}[${iIndex_Input}]    @{Actual_HostBankNet_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_HostBankNet_List}[${iIndex_Input}]    @{Actual_HostBankNet_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_HostBankNet_List}[${iIndex_Input}] = @{Actual_HostBankNet_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_HostBankNet_List}[${iIndex_Input}] != @{Actual_HostBankNet_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_HostBankNetFac_List}[${iIndex_Input}]    @{Actual_HostBankNetFac_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_HostBankNetFac_List}[${iIndex_Input}]    @{Actual_HostBankNetFac_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_HostBankNetFac_List}[${iIndex_Input}] = @{Actual_HostBankNetFac_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_HostBankNetFac_List}[${iIndex_Input}] != @{Actual_HostBankNetFac_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_MaturityDate_List}[${iIndex_Input}]    @{Actual_MaturityExpDate_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_MaturityDate_List}[${iIndex_Input}]    @{Actual_MaturityExpDate_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_MaturityDate_List}[${iIndex_Input}] = @{Actual_MaturityExpDate_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_MaturityDate_List}[${iIndex_Input}] != @{Actual_MaturityExpDate_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_HostBankGross_List}[${iIndex_Input}]    @{Actual_HostBankGross_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_HostBankGross_List}[${iIndex_Input}]    @{Actual_HostBankGross_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_HostBankGross_List}[${iIndex_Input}] = @{Actual_HostBankGross_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_HostBankGross_List}[${iIndex_Input}] != @{Actual_HostBankGross_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_GlobalOriginal_List}[${iIndex_Input}]    @{Actual_GlobalOriginal_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_GlobalOriginal_List}[${iIndex_Input}]    @{Actual_GlobalOriginal_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_GlobalOriginal_List}[${iIndex_Input}] = @{Actual_GlobalOriginal_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_GlobalOriginal_List}[${iIndex_Input}] != @{Actual_GlobalOriginal_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_GlobalCurrent_List}[${iIndex_Input}]    @{Actual_GlobalCurrent_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_GlobalCurrent_List}[${iIndex_Input}]    @{Actual_GlobalCurrent_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_GlobalCurrent_List}[${iIndex_Input}] = @{Actual_GlobalCurrent_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_GlobalCurrent_List}[${iIndex_Input}] != @{Actual_GlobalCurrent_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_PayMode_List}[${iIndex_Input}]    @{Actual_PaymentMode_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_PayMode_List}[${iIndex_Input}]    @{Actual_PaymentMode_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_PayMode_List}[${iIndex_Input}] = @{Actual_PaymentMode_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_PayMode_List}[${iIndex_Input}] != @{Actual_PaymentMode_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_IntCycleFreq_List}[${iIndex_Input}]    @{Actual_IntCycleFreq_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_IntCycleFreq_List}[${iIndex_Input}]    @{Actual_IntCycleFreq_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_IntCycleFreq_List}[${iIndex_Input}] = @{Actual_IntCycleFreq_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_IntCycleFreq_List}[${iIndex_Input}] != @{Actual_IntCycleFreq_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_Margin_List}[${iIndex_Input}]    @{Actual_Margin_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_Margin_List}[${iIndex_Input}]    @{Actual_Margin_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_Margin_List}[${iIndex_Input}] = @{Actual_Margin_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_Margin_List}[${iIndex_Input}] != @{Actual_Margin_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_AllInRate_List}[${iIndex_Input}]    @{Actual_AllInRate_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_AllInRate_List}[${iIndex_Input}]    @{Actual_AllInRate_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_AllInRate_List}[${iIndex_Input}] = @{Actual_AllInRate_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_AllInRate_List}[${iIndex_Input}] != @{Actual_AllInRate_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_AccruedInterest_List}[${iIndex_Input}]    @{Actual_AccruedInterest_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_AccruedInterest_List}[${iIndex_Input}]    @{Actual_AccruedInterest_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_AccruedInterest_List}[${iIndex_Input}] = @{Actual_AccruedInterest_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_AccruedInterest_List}[${iIndex_Input}] != @{Actual_AccruedInterest_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${PricingOption_Dict}    @{Actual_PricingOption_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${PricingOption_Dict}    @{Actual_PricingOption_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. ${PricingOption_Dict} = @{Actual_PricingOption_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. ${PricingOption_Dict} != @{Actual_PricingOption_List}[0]    level=ERROR

Get Fee Type and Validate Response Per Level
    [Documentation]    This keyword is used to get fee type from input dataset and validate response file per fee type.
    ...    @author: clanding    26AUG2019    - initial create
    ...    @update: rtarayao    30AUG2019    - defined acceptable values for the validation of facility ongoing fees
    ...                                      - updated the index input value from fee_name to fee_type
    [Arguments]    ${sOutputFilePath}    ${sOutputFile}    ${sExp_Name}    ${sExp_Fee}    ${sExp_Currency}    ${iExp_CurrentRate}
    ...    ${sExp_EffectiveDate}    ${sExp_ExpiryDate}    ${sExp_FeeAlias}    ${sExp_Status}    ${iExp_AccruedToDate}    ${sExp_DueDate}    ${sDelimiter}
    
    ${Response_Payload}    OperatingSystem.Get File    ${datasetpath}${sOutputFilePath}${sOutputFile}.${JSON}
    ${Response_Payload}    Strip String    ${Response_Payload}    mode=left    characters=[
    ${Response_Payload}    Strip String    ${Response_Payload}    mode=right    characters=]
    ${Response_Payload_List}    Split String    ${Response_Payload}    },{
    ${JsonCount}    Get Length    ${Response_Payload_List}
    :FOR    ${Index_Output}    IN RANGE    ${JsonCount}
    \    ${LastIndex}    Evaluate    ${JsonCount}-1    
    \    ${JSON_Value}    Get From List    ${Response_Payload_List}    ${Index_Output}
    \    ${IsEvenOrOdd}    Evaluate    int('${Index_Output}')%2
    \    ${Separated_JSON_Value}    Run Keyword If    ${IsEvenOrOdd}==0 and ${Index_Output}==0 and ${LastIndex}!=0    Catenate    SEPARATOR=    ${JSON_Value}    }
         ...    ELSE IF    ${IsEvenOrOdd}==0 and ${Index_Output}==0 and ${LastIndex}==0    Set Variable    ${JSON_Value}
         ...    ELSE IF    ${IsEvenOrOdd}==0 and ${Index_Output}==${LastIndex}    Catenate    SEPARATOR=    {    ${JSON_Value}
         ...    ELSE IF    ${IsEvenOrOdd}==1 and ${Index_Output}==${LastIndex}    Catenate    SEPARATOR=    {    ${JSON_Value}
         ...    ELSE    Catenate    SEPARATOR=    {    ${JSON_Value}    }
    \    Log    ${Separated_JSON_Value}
    \    
    \    Create File    ${dataset_path}${sOutputFilePath}tempfile.json    ${Separated_JSON_Value}
    \    
    \    ### Get JSON field values ###
    \    ${Json_Object}    Load JSON From File    ${dataset_path}${sOutputFilePath}tempfile.json
    \    Log    ${Json_Object}
    \    ${Actual_Fee_List}    Get Value From Json    ${Json_Object}    $..fee
    \    ${Index_Input}    Get Input Value and Return Index    ${sExp_Fee}    @{Actual_Fee_List}[0]    ${sDelimiter}
    \    
    \    Run Keyword If    '@{Actual_Fee_List}[0]'=='Fronting Usage Fee (SFBG)' or '@{Actual_Fee_List}[0]'=='Issuance Fee (BG/LC)'    Validate Fee Response for Outstanding Level    ${Json_Object}    ${OUTSTANDING}    
         ...    ${sExp_Name}    ${sExp_Fee}    ${sExp_Currency}    ${iExp_CurrentRate}    ${sExp_EffectiveDate}    ${sExp_ExpiryDate}    ${iExp_AccruedToDate}    ${sExp_DueDate}    ${Index_Input}    ${sDelimiter}
         ...    ELSE IF    '@{Actual_Fee_List}[0]'=='Commitment Fee' or '@{Actual_Fee_List}[0]'=='Fronting Commitment Fee (SFBG)'    Validate Fee Response for Facility Level    ${Json_Object}    ${FACILITY}    ${sExp_Name}    ${sExp_Fee}    ${sExp_Currency}    ${iExp_CurrentRate}    ${sExp_EffectiveDate}    
         ...    ${sExp_ExpiryDate}    ${sExp_FeeAlias}    ${sExp_Status}    ${iExp_AccruedToDate}    ${sExp_DueDate}    ${Index_Input}    ${sDelimiter}
         ...    ELSE IF    '@{Actual_Fee_List}[0]'=='Fronting Line Fee (SFBG)' or '@{Actual_Fee_List}[0]'=='Indemnity Fee - Commitment (SFBG)'    Validate Fee Response for Facility Level    ${Json_Object}    ${FACILITY}    ${sExp_Name}    ${sExp_Fee}    ${sExp_Currency}    ${iExp_CurrentRate}    ${sExp_EffectiveDate}    
         ...    ${sExp_ExpiryDate}    ${sExp_FeeAlias}    ${sExp_Status}    ${iExp_AccruedToDate}    ${sExp_DueDate}    ${Index_Input}    ${sDelimiter}
         ...    ELSE IF    '@{Actual_Fee_List}[0]'=='Indemnity Fee - Line (SFBG)' or '@{Actual_Fee_List}[0]'=='Indemnity Fee - Usage (SFBG)'    Validate Fee Response for Facility Level    ${Json_Object}    ${FACILITY}    ${sExp_Name}    ${sExp_Fee}    ${sExp_Currency}    ${iExp_CurrentRate}    ${sExp_EffectiveDate}    
         ...    ${sExp_ExpiryDate}    ${sExp_FeeAlias}    ${sExp_Status}    ${iExp_AccruedToDate}    ${sExp_DueDate}    ${Index_Input}    ${sDelimiter}
         ...    ELSE IF    '@{Actual_Fee_List}[0]'=='Line Fee' or '@{Actual_Fee_List}[0]'=='Risk Cover Premium Fee' or '@{Actual_Fee_List}[0]'=='Usage Fee'     Validate Fee Response for Facility Level    ${Json_Object}    ${FACILITY}    ${sExp_Name}    ${sExp_Fee}    ${sExp_Currency}    ${iExp_CurrentRate}    ${sExp_EffectiveDate}    
         ...    ${sExp_ExpiryDate}    ${sExp_FeeAlias}    ${sExp_Status}    ${iExp_AccruedToDate}    ${sExp_DueDate}    ${Index_Input}    ${sDelimiter}
         ...    ELSE    Run Keyword And Continue On Failure    Fail    '@{Actual_Fee_List}[0]' should not be displayed in the response.
    \    Delete File If Exist    ${dataset_path}${sOutputFilePath}tempfile.json

Validate Fee Response for Outstanding Level
    [Documentation]    This keyword is used to validate Fee values from response versus input dataset for Outstanding Level.
    ...    @author: clanding    26AUG2019    - initial create
    [Arguments]    ${oJson}    ${sExp_Level}    ${sExp_Name}    ${sExp_Fee}    ${sExp_Currency}    ${iExp_CurrentRate}
    ...    ${sExp_EffectiveDate}    ${sExp_ExpiryDate}    ${iExp_AccruedToDate}    ${sExp_DueDate}    ${iIndex_Input}    ${sDelimiter}

    ### Get JSON field values ###
    Log    ${oJson}
    ${Actual_Level_List}    Get Value From Json    ${oJson}    $..level
    ${Actual_Name_List}    Get Value From Json    ${oJson}    $..name
    ${Actual_Fee_List}    Get Value From Json    ${oJson}    $..fee
    ${Actual_Currency_List}    Get Value From Json    ${oJson}    $..currency
    ${Actual_CurrentRate_List}    Get Value From Json    ${oJson}    $..currentRate
    ${Actual_EffectiveDate_List}    Get Value From Json    ${oJson}    $..effectiveDate
    ${Actual_ExpiryDate_List}    Get Value From Json    ${oJson}    $..expiryDate
    ${Actual_AccruedToDate_List}    Get Value From Json    ${oJson}    $..accruedToDate
    ${Actual_DueDate_List}    Get Value From Json    ${oJson}    $..dueDate

    ### Get Dataset values ###
    @{Input_Name_List}    Split String    ${sExp_Name}    ${sDelimiter}
    @{Input_Fee_List}    Split String    ${sExp_Fee}    ${sDelimiter}
    @{Input_Currency_List}    Split String    ${sExp_Currency}    ${sDelimiter}
    @{Input_CurrentRate_List}    Split String    ${iExp_CurrentRate}    ${sDelimiter}
    @{Input_EffectiveDate_List}    Split String    ${sExp_EffectiveDate}    ${sDelimiter}
    @{Input_ExpiryDate_List}    Split String    ${sExp_ExpiryDate}    ${sDelimiter}
    @{Input_AccruedToDate_List}    Split String    ${iExp_AccruedToDate}    ${sDelimiter}
    @{Input_DueDate_List}    Split String    ${sExp_DueDate}    ${sDelimiter}

    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${sExp_Level}    @{Actual_Level_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExp_Level}    @{Actual_Level_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. ${sExp_Level} = @{Actual_Level_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. ${sExp_Level} != @{Actual_Level_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_Name_List}[${iIndex_Input}]    @{Actual_Name_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_Name_List}[${iIndex_Input}]    @{Actual_Name_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_Name_List}[${iIndex_Input}] = @{Actual_Name_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_Name_List}[${iIndex_Input}] != @{Actual_Name_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_Fee_List}[${iIndex_Input}]    @{Actual_Fee_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_Fee_List}[${iIndex_Input}]    @{Actual_Fee_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_Fee_List}[${iIndex_Input}] = @{Actual_Fee_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_Fee_List}[${iIndex_Input}] != @{Actual_Fee_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_Currency_List}[${iIndex_Input}]    @{Actual_Currency_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_Currency_List}[${iIndex_Input}]    @{Actual_Currency_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_Currency_List}[${iIndex_Input}] = @{Actual_Currency_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_Currency_List}[${iIndex_Input}] != @{Actual_Currency_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_CurrentRate_List}[${iIndex_Input}]    @{Actual_CurrentRate_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_CurrentRate_List}[${iIndex_Input}]    @{Actual_CurrentRate_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_CurrentRate_List}[${iIndex_Input}] = @{Actual_CurrentRate_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_CurrentRate_List}[${iIndex_Input}] != @{Actual_CurrentRate_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_EffectiveDate_List}[${iIndex_Input}]    @{Actual_EffectiveDate_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_EffectiveDate_List}[${iIndex_Input}]    @{Actual_EffectiveDate_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_EffectiveDate_List}[${iIndex_Input}] = @{Actual_EffectiveDate_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_EffectiveDate_List}[${iIndex_Input}] != @{Actual_EffectiveDate_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_ExpiryDate_List}[${iIndex_Input}]    @{Actual_ExpiryDate_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_ExpiryDate_List}[${iIndex_Input}]    @{Actual_ExpiryDate_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_ExpiryDate_List}[${iIndex_Input}] = @{Actual_ExpiryDate_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_ExpiryDate_List}[${iIndex_Input}] != @{Actual_ExpiryDate_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_AccruedToDate_List}[${iIndex_Input}]    @{Actual_AccruedToDate_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_AccruedToDate_List}[${iIndex_Input}]    @{Actual_AccruedToDate_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_AccruedToDate_List}[${iIndex_Input}] = @{Actual_AccruedToDate_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_AccruedToDate_List}[${iIndex_Input}] != @{Actual_AccruedToDate_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_DueDate_List}[${iIndex_Input}]    @{Actual_DueDate_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_DueDate_List}[${iIndex_Input}]    @{Actual_DueDate_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_DueDate_List}[${iIndex_Input}] = @{Actual_DueDate_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_DueDate_List}[${iIndex_Input}] != @{Actual_DueDate_List}[0]    level=ERROR

Validate Fee Response for Facility Level
    [Documentation]    This keyword is used to validate Fee values from response versus input dataset for Facility Level.
    ...    @author: clanding    26AUG2019    - initial create
    [Arguments]    ${oJson}    ${sExp_Level}    ${sExp_Name}    ${sExp_Fee}    ${sExp_Currency}    ${iExp_CurrentRate}
    ...    ${sExp_EffectiveDate}    ${sExp_ExpiryDate}    ${sFeeAlias}    ${sStatus}    ${iExp_AccruedToDate}    ${sExp_DueDate}    ${iIndex_Input}    ${sDelimiter}

    ### Get JSON field values ###

    Log    ${oJson}
    ${Actual_Level_List}    Get Value From Json    ${oJson}    $..level
    ${Actual_Name_List}    Get Value From Json    ${oJson}    $..name
    ${Actual_Fee_List}    Get Value From Json    ${oJson}    $..fee
    ${Actual_Currency_List}    Get Value From Json    ${oJson}    $..currency
    ${Actual_CurrentRate_List}    Get Value From Json    ${oJson}    $..currentRate
    ${Actual_EffectiveDate_List}    Get Value From Json    ${oJson}    $..effectiveDate
    ${Actual_ExpiryDate_List}    Get Value From Json    ${oJson}    $..expiryDate
    ${Actual_AccruedToDate_List}    Get Value From Json    ${oJson}    $..accruedToDate
    ${Actual_FeeAlias_List}    Get Value From Json    ${oJson}    $..feeAlias
    ${Actual_Status_List}    Get Value From Json    ${oJson}    $..status
    ${Actual_DueDate_List}    Get Value From Json    ${oJson}    $..dueDate

    ### Get Dataset values ###
    @{Input_Name_List}    Split String    ${sExp_Name}    ${sDelimiter}
    @{Input_Fee_List}    Split String    ${sExp_Fee}    ${sDelimiter}
    @{Input_Currency_List}    Split String    ${sExp_Currency}    ${sDelimiter}
    @{Input_CurrentRate_List}    Split String    ${iExp_CurrentRate}    ${sDelimiter}
    @{Input_EffectiveDate_List}    Split String    ${sExp_EffectiveDate}    ${sDelimiter}
    @{Input_ExpiryDate_List}    Split String    ${sExp_ExpiryDate}    ${sDelimiter}
    @{Input_AccruedToDate_List}    Split String    ${iExp_AccruedToDate}    ${sDelimiter}
    @{Input_DueDate_List}    Split String    ${sExp_DueDate}    ${sDelimiter}
    @{Input_FeeAlias_List}    Split String    ${sFeeAlias}    ${sDelimiter}
    @{Input_Status_List}    Split String    ${sStatus}    ${sDelimiter}

    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${sExp_Level}    @{Actual_Level_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExp_Level}    @{Actual_Level_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. ${sExp_Level} = @{Actual_Level_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. ${sExp_Level} != @{Actual_Level_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_Name_List}[${iIndex_Input}]    @{Actual_Name_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_Name_List}[${iIndex_Input}]    @{Actual_Name_List}[0]
     Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_Name_List}[${iIndex_Input}] = @{Actual_Name_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_Name_List}[${iIndex_Input}] != @{Actual_Name_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_Fee_List}[${iIndex_Input}]    @{Actual_Fee_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_Fee_List}[${iIndex_Input}]    @{Actual_Fee_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_Fee_List}[${iIndex_Input}] = @{Actual_Fee_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_Fee_List}[${iIndex_Input}] != @{Actual_Fee_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_Currency_List}[${iIndex_Input}]    @{Actual_Currency_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_Currency_List}[${iIndex_Input}]    @{Actual_Currency_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_Currency_List}[${iIndex_Input}] = @{Actual_Currency_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_Currency_List}[${iIndex_Input}] != @{Actual_Currency_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_CurrentRate_List}[${iIndex_Input}]    @{Actual_CurrentRate_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_CurrentRate_List}[${iIndex_Input}]    @{Actual_CurrentRate_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_CurrentRate_List}[${iIndex_Input}] = @{Actual_CurrentRate_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_CurrentRate_List}[${iIndex_Input}] != @{Actual_CurrentRate_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_EffectiveDate_List}[${iIndex_Input}]    @{Actual_EffectiveDate_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_EffectiveDate_List}[${iIndex_Input}]    @{Actual_EffectiveDate_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_EffectiveDate_List}[${iIndex_Input}] = @{Actual_EffectiveDate_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_EffectiveDate_List}[${iIndex_Input}] != @{Actual_EffectiveDate_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_ExpiryDate_List}[${iIndex_Input}]    @{Actual_ExpiryDate_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_ExpiryDate_List}[${iIndex_Input}]    @{Actual_ExpiryDate_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_ExpiryDate_List}[${iIndex_Input}] = @{Actual_ExpiryDate_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_ExpiryDate_List}[${iIndex_Input}] != @{Actual_ExpiryDate_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    @{Input_AccruedToDate_List}[${iIndex_Input}]    @{Actual_AccruedToDate_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Numbers    @{Input_AccruedToDate_List}[${iIndex_Input}]    @{Actual_AccruedToDate_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_AccruedToDate_List}[${iIndex_Input}] = @{Actual_AccruedToDate_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_AccruedToDate_List}[${iIndex_Input}] != @{Actual_AccruedToDate_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_DueDate_List}[${iIndex_Input}]    @{Actual_DueDate_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_DueDate_List}[${iIndex_Input}]    @{Actual_DueDate_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_DueDate_List}[${iIndex_Input}] = @{Actual_DueDate_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_DueDate_List}[${iIndex_Input}] != @{Actual_DueDate_List}[0]    level=ERROR

    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_FeeAlias_List}[${iIndex_Input}]    @{Actual_FeeAlias_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_FeeAlias_List}[${iIndex_Input}]    @{Actual_FeeAlias_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_FeeAlias_List}[${iIndex_Input}] = @{Actual_FeeAlias_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_FeeAlias_List}[${iIndex_Input}] != @{Actual_FeeAlias_List}[0]    level=ERROR
    
    Run Keyword And Continue On Failure    Should Be Equal As Strings    @{Input_Status_List}[${iIndex_Input}]    @{Actual_Status_List}[0]
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    @{Input_Status_List}[${iIndex_Input}]    @{Actual_Status_List}[0]
    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual are equal. @{Input_Status_List}[${iIndex_Input}] = @{Actual_Status_List}[0]
    ...    ELSE    Log    Expected and Actual are NOT equal. @{Input_Status_List}[${iIndex_Input}] != @{Actual_Status_List}[0]    level=ERROR

Verify 404 Response Code for Get API Fee Details 
    [Documentation]    This keyword is to validate GET Fee details response of 404 code. 
    ...    @author: rtarayao    10SEP2019    - Initial create
    [Arguments]    ${sFCN}    ${Headers}    ${sResponseFilePath}    ${sResponseJson}    ${sExternalCtrlID}   
    
    Delete All Sessions
    Create Session    COMHOST    ${COM_HOST}
    ${REQUEST_DATA}    GET Request API for Comsee Deal Facility 404 Response    COMHOST    ${MDM_COMMSEE_API_FAC}${sFCN}/${sExternalCtrlID}/fees    ${Headers}
    ${JSON_File}    Set Variable    ${sResponseFilePath}${sResponseJson}.json
    Create File    ${dataset_path}${JSON_File}
    Append To File    ${dataset_path}${JSON_File}    ${GET_response.content}