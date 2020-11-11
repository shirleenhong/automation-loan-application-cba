*** Settings ***
Resource       ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Validate GL Application Column in GLTB_CROSSREFERENCE table if Correct
    [Documentation]    This test case is used to validate values of GL Application Column in GLTB_CROSSREFERENCE table if correct. 
    ...    @author: javinzon    11NOV2020    - initial create
    [Arguments]    ${sParty_ID}    ${sValid_GLApplication}
    
    ${QUERY_GLREFERENCEID}    Catenate    ${SELECT_Q}    ${GLREFERENCEID}    ${FROM_Q}    ${GLOBALCBS_SCHEMA}.${GLTB_CROSSREFERENCE_TABLE} ${WHERE_Q} ${GLREFERENCEID} = '${sParty_ID}'
    ${DBQuery_GLREFREENCEID_List}    Connect to Party Database and Execute Query and Return List    ${QUERY_GLREFERENCEID}
    ${DBQuery_GLREFREENCEID_List_0}    Get From List    ${DBQuery_GLREFREENCEID_List}    0
    ${Actual_GLREFERENCEID}    Get From List    ${DBQuery_GLREFREENCEID_List_0}    0
    
    ${QUERY_GLHOSTREFID}    Catenate    ${SELECT_Q}    ${GLHOSTREFID}    ${FROM_Q}    ${GLOBALCBS_SCHEMA}.${GLTB_CROSSREFERENCE_TABLE} ${WHERE_Q} ${GLREFERENCEID} = '${Actual_GLREFERENCEID}'
    ${DBQuery_GLHOSTREFID_List}    Connect to Party Database and Execute Query and Return List    ${QUERY_GLHOSTREFID}
    ${Query_Results_GLHOSTREFID_0}    Get From List    ${DBQuery_GLHOSTREFID_List}    0
    ${Actual_GLHOSTREFID}    Get From List    ${Query_Results_GLHOSTREFID_0}    0
         
    ${QUERY_GLAPPLICATION}    Catenate    ${SELECT_Q}    ${GLAPPLICATION}    ${FROM_Q}    ${GLOBALCBS_SCHEMA}.${GLTB_CROSSREFERENCE_TABLE} ${WHERE_Q} ${GLHOSTREFID} = '${Actual_GLHOSTREFID}'
    ${DBQuery_GLAPPLICATION_List}    Connect to Party Database and Execute Query and Return List    ${QUERY_GLAPPLICATION}
    
    ${DB_GLApplication_List}    Create List
    :FOR    ${Actual_Application}    IN    @{DBQuery_GLAPPLICATION_List}
    \    ${Application}    Get From List    ${Actual_Application}    0
    \    Log    ${Application}
    \    Append To List    ${DB_GLApplication_List}    ${Application}
    \    Log    GLApplication list contains: ${DB_GLApplication_List}
    Sort List    ${DBQuery_GLAPPLICATION_List}
    
    ${Valid_GLAPPLICATION_List}    Create List    
    ${Valid_GLAPPLICATION_List}    Split String    ${sValid_GLApplication}    |
    Sort List    ${Valid_GLAPPLICATION_List}
    
    ${isMatched}    Run Keyword and Return Status    Lists Should Be Equal    ${DB_GLApplication_List}    ${Valid_GLAPPLICATION_List}
    Run Keyword If    ${isMatched}==${True}    Log    Database contains correct number of applications and values.   
    ...    ELSE    Run Keyword And Continue on Failure    Fail    Only '${Valid_GLAPPLICATION_List}' are expected in GL Application column.