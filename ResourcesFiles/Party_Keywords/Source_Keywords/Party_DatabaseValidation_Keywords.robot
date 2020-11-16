*** Settings ***
Resource       ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Validate GL Application Column in GLTB_CROSSREFERENCE Table if Correct
    [Documentation]    This test case is used to validate values of GL Application Column in GLTB_CROSSREFERENCE table if correct. 
    ...    @author: javinzon    11NOV2020    - initial create
    [Arguments]    ${sParty_ID}    ${sValid_GLApplication}
    
    ${Actual_GLHOSTREFID}    Get and Return Actual Value of GLHOSTREFID in GLTB_CROSSREFERENCE Table    ${sParty_ID}
         
    ${QUERY_GLAPPLICATION}    Catenate    ${SELECT_Q}    ${GLAPPLICATION}    ${FROM_Q}    ${GLOBALCBS_SCHEMA}.${GLTB_CROSSREFERENCE_TABLE} ${WHERE_Q} ${GLHOSTREFID} = '${Actual_GLHOSTREFID}'
    ${DBQuery_GLAPPLICATION_List}    Connect to Party Database and Execute Query and Return List    ${QUERY_GLAPPLICATION}
    
    ${DB_GLApplication_List}    Create List
    :FOR    ${Actual_Application}    IN    @{DBQuery_GLAPPLICATION_List}
    \    ${Application}    Get From List    ${Actual_Application}    0
    \    Log    ${Application}
    \    Append To List    ${DB_GLApplication_List}    ${Application}
    \    Log    GLApplication list contains: ${DB_GLApplication_List}
    Sort List    ${DBQuery_GLAPPLICATION_List}
        
    ${Valid_GLAPPLICATION_List}    Split String    ${sValid_GLApplication}    |
    Sort List    ${Valid_GLAPPLICATION_List}
    
    ${isMatched}    Run Keyword and Return Status    Lists Should Be Equal    ${DB_GLApplication_List}    ${Valid_GLAPPLICATION_List}
    Run Keyword If    ${isMatched}==${True}    Log    Database contains correct number of applications and values.   
    ...    ELSE    Run Keyword And Continue on Failure    Fail    Only '${Valid_GLAPPLICATION_List}' are expected in GL Application column.

Get and Return Actual Value of GLHOSTREFID in GLTB_CROSSREFERENCE Table
    [Arguments]    ${sParty_ID}
    ${QUERY_GLREFERENCEID}    Catenate    ${SELECT_Q}    ${GLREFERENCEID}    ${FROM_Q}    ${GLOBALCBS_SCHEMA}.${GLTB_CROSSREFERENCE_TABLE} ${WHERE_Q} ${GLREFERENCEID} = '5049500'
    ${DBQuery_GLREFREENCEID_List}    Connect to Party Database and Execute Query and Return List    ${QUERY_GLREFERENCEID}
    ${DBQuery_GLREFREENCEID_List_0}    Get From List    ${DBQuery_GLREFREENCEID_List}    0
    ${Actual_GLREFERENCEID}    Get From List    ${DBQuery_GLREFREENCEID_List_0}    0
    
    ${QUERY_GLHOSTREFID}    Catenate    ${SELECT_Q}    ${GLHOSTREFID}    ${FROM_Q}    ${GLOBALCBS_SCHEMA}.${GLTB_CROSSREFERENCE_TABLE} ${WHERE_Q} ${GLREFERENCEID} = '${Actual_GLREFERENCEID}'
    ${DBQuery_GLHOSTREFID_List}    Connect to Party Database and Execute Query and Return List    ${QUERY_GLHOSTREFID}
    ${Query_Results_GLHOSTREFID_0}    Get From List    ${DBQuery_GLHOSTREFID_List}    0
    ${Actual_GLHOSTREFID}    Get From List    ${Query_Results_GLHOSTREFID_0}    0
    
    [Return]    ${Actual_GLHOSTREFID}

Validate Columns in GLTB_CROSSREFERENCE Table if Correct
    [Documentation]    This test case is used to validate values of the following columns in GLTB_CROSSREFERENCE table if correct. 
    ...    @author: javinzon    13NOV2020    - initial create
    [Arguments]    ${sParty_ID}    ${sDefault_GLActivated}    ${sDefault_GLStatus}    ${sEntity}    
    
    ${Actual_GLHOSTREFID}    Get and Return Actual Value of GLHOSTREFID in GLTB_CROSSREFERENCE Table    ${sParty_ID}
    
    ${QUERY_COLUMNS}    Catenate    ${SELECT_Q}    ${GLREFERENCEID}    ,    ${GLACTIVATED}    ,    ${GLSTATUS}    ,    ${GLENTITYID}    ${FROM_Q}    ${GLOBALCBS_SCHEMA}.${GLTB_CROSSREFERENCE_TABLE} ${WHERE_Q} ${GLHOSTREFID} = '${Actual_GLHOSTREFID}' 
    ${DBQuery_COLUMNS_List}    Connect to Party Database and Execute Query and Return List    ${QUERY_COLUMNS}
    ${Length_Columns_List}    Get Length    ${DBQuery_COLUMNS_List}
    
    ${Record_Values_List}    Create List
    ${Expected_Values_List}    Create List
    Append To List    ${Expected_Values_List}    ${sParty_ID}    ${sDefault_GLActivated}    ${sDefault_GLStatus}    ${sEntity}
    Log    ${Expected_Values_List}
    
    :FOR    ${index}    IN RANGE    ${Length_Columns_List}
    \    ${Record}    Get From List    ${DBQuery_COLUMNS_List}    ${index}
    \    Get Each Value From Record and Compare Lists    ${Record}    ${sParty_ID}    ${sDefault_GLActivated}    ${sDefault_GLStatus}    ${sEntity}  
    
Get Each Value From Record and Compare Lists
    [Documentation]    This test case is used to get each value, add to a list and compare to expected list.
    ...    @author: javinzon    13NOV2020    - intial create 
    [Arguments]    ${sRecord}      ${sParty_ID}    ${sDefault_GLActivated}    ${sDefault_GLStatus}    ${sEntity} 
    
    ${Record_Values_List}    Create List
    ${Expected_Values_List}    Create List
    Append To List    ${Expected_Values_List}    ${sParty_ID}    ${sDefault_GLActivated}    ${sDefault_GLStatus}    ${sEntity}
    Log    ${Expected_Values_List}
    
    ${Record_Length}    Get Length    ${sRecord}
    :FOR    ${index}    IN RANGE    ${Record_Length}
    \    ${Record_List}    Get From List    ${sRecord}    ${index}
    \    Append To List    ${Record_Values_List}    ${Record_List} 
    \    Log       ${Record_Values_List}
        
    Log    ${Record_Values_List}
    ${isMatched}    Run Keyword and Return Status    Lists Should Be Equal    ${Record_Values_List}    ${Expected_Values_List}   
    Run Keyword If    ${isMatched}==${True}    Log    Actual results are matched with expected values.   
    ...    ELSE    Run Keyword And Continue on Failure    Fail    Actual result: '${Record_Values_List}' should be equal with '${Expected_Values_List}'. 
    

    
   
    
    
    

 