*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Create Party ID and Validate GLAPPLICATION column in Party Database
    [Documentation]    This test case is used to create Party ID via Quick Party Onboarding then validate in Party  
    ...    database if only COMRLENDING and PARTY are available. 
    ...    @author: javinzon    08OCT2020    - initial create
    [Arguments]    ${ExcelPath}
      
    ${QUERY_GLREFERENCEID}    Catenate    ${SELECT_Q}    ${GLREFERENCEID}    ${FROM_Q}    ${GLOBALCBS_SCHEMA}.${GLTB_CROSSREFERENCE_TABLE} ${WHERE_Q} ${GLREFERENCEID} = '&{ExcelPath}[Party_ID]'
    ${Query_Results_List}    Connect to Party Database and Execute Query and Return List    ${QUERY_GLREFERENCEID}
    ${Query_Results_List_0}    Get From List    ${Query_Results_List}    0
    
    ${QUERY_GLREFERENCEID}    Catenate    ${SELECT_Q}    ${GLHOSTREFID}    ${FROM_Q}    ${GLOBALCBS_SCHEMA}.${GLTB_CROSSREFERENCE_TABLE} ${WHERE_Q} ${GLHOSTREFID} = '&{ExcelPath}[Party_ID]'
    ${Query_Results_List}    Connect to Party Database and Execute Query and Return List    ${QUERY_GLREFERENCEID}
    ${Query_Results_List_0}    Get From List    ${Query_Results_List}    0
    
    