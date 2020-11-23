*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Update Regions For User And Restore User Details
        [Documentation]    This keyword is used to check if zone can be removed successfully from user.
    ...    @author: nbautist    22OCT2020    - initial create
    ...    @update: javinzon    20NOV2020    - Added condition for Logout User and Close Browser keywords
    [Arguments]    ${ExcelPath}
        
    ### Removal of zone from the user by the supervisor
    Login User to Party    ${PARTY_SUPERVISOR_USERNAME}    ${PARTY_SUPERVISOR_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 
    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
    Navigate Amend User    ${PARTY_USERNAME}
    ${Default_Zone}    Get Default Zone
    Change Default Zone    &{ExcelPath}[UserZone]
    Remove Associated Zone from User    &{ExcelPath}[AddRemove_UserZone]
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    ...    ELSE    Close Browser
    
    ### Login as user to validate removed zone
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}
    Verify Zone Visibility in Zone Dropdown List    &{ExcelPath}[AddRemove_UserZone]    ${False}
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    ...    ELSE    Close Browser
    
    ### Restore the removed zone by the supervisor
    Login User to Party    ${PARTY_SUPERVISOR_USERNAME}    ${PARTY_SUPERVISOR_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}
    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
    Navigate Amend User    ${PARTY_USERNAME}
    Add Associated Zone To User    &{ExcelPath}[AddRemove_UserZone]    &{ExcelPath}[AddRemove_UserBranch]
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    ...    ELSE    Close Browser
    
    ### Login as user to validate restored zone
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}
    Verify Zone Visibility In Zone Dropdown List    &{ExcelPath}[AddRemove_UserZone]    ${True}
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    ...    ELSE    Close Browser
    
    ### Restore the default zone of the user
    Login User to Party    ${PARTY_SUPERVISOR_USERNAME}    ${PARTY_SUPERVISOR_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}
    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
    Navigate Amend User    ${PARTY_USERNAME}
    Restore Default Zone    ${Default_Zone}
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    ...    ELSE    Close Browser
