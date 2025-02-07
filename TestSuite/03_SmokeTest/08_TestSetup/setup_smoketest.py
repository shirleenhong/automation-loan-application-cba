###Dataset###
dataset_path = "C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen"
ExcelPath = "C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\TestSuite\\05_SmokeTest\\02_Resources\\data_smoketest.xlsx"
CBAUAT_ExcelPath = "C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\CBA_UAT_DataSet\\EVG_CBAUAT05.xlsx"
APIDataSet = "C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\API_DataSet\\API_Data_Set.xlsx"
ExcelPath_API_temp = '..\\CBA_Evergreen\\DataSet\\API_DataSet\\temp.xlsx'
AuditLogPath = '..\\CBA_Evergreen\\DataSet\\API_DataSet\\Audit\\Audit_Log_Data_Set.xlsx'
AuditLogPathTemp = '..\\CBA_Evergreen\\DataSet\\API_DataSet\\Audit\\temp.xlsx'
Countries_Codes = '..\\CBA_Evergreen\\DataSet\\API_DataSet\\Countries_Codes.xlsx'
TL_DATASET = "C:\\Git_Evergreen\\DataSet\\TL_DataSet\\BaseRates_GSFile\\TL_Transformed_Data_BaseRate.xls"
GLExcelPath = "C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\Extract_DataSet\\GL\\EVG_GL_TestData.xlsx"
ComSeeDataSet = 'C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\Downstream_DataSet\\ComSee\\COMSEE_Data_Set.xlsx'
Downstream_DataSet = '..\\CBA_Evergreen\\DataSet\\Downstream_DataSet\\ComSee\\ComSee_API_DataSet.xls'
COMMSEEDataSet= '..\\CBA_Evergreen\\DataSet\\COM_DataSet\\Com_Data_Set.xls'
SAPWUL_DATASET = "C:\\Git_evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\Downstream_DataSet\\SAPWUL\\SAPWUL_Data_Set.xlsx"
DWHExcelPath = 'C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\Extract_DataSet\\DWH\\EVG_DWH_TestData.xlsx'

###PARTY###
PARTY_URL = 'mancsleverg0022:8080/uxp/rt/html/login.html'
PARTY_SSO_URL = 'http://${PARTY_HTML_CREDENTIALS}@${SSO_SERVER}:${SSO_PORT_NUMBER}/bfweb/servlet/GetServiceTicketForUser?redirectTo=http://${PARTY_SERVER}/uxp/rt/html/login.html'
PARTY_SERVER = 'mancsleverg0022:8080'
PARTY_HTML_CREDENTIALS = 'misysroot%5Cbrad:welcome%4099'
USER_LINK = "mancsleverg0022"
USER_PORT = "8080"
PARTY_URL_SUFFIX = "/uxp/rt/html/login.html"
DOMAIN = "http://misysroot"

###ESSENCE###
ESSENCE_URL = '${ESSENCE_SERVER}:${ESSENCE_PORT_NUMBER}${ESSENCE_LINK}'
ESSENCE_SSO_URL = 'http://${ESSENCE_HTML_CREDENTIALS}@${SSO_SERVER}:${SSO_PORT_NUMBER}/bfweb/servlet/GetServiceTicketForUser?redirectTo=http://${ESSENCE_SERVER}:${ESSENCE_LINK}'
ESSENCE_HTML_CREDENTIALS = 'misysroot%5Cbrad:welcome%4099'
ESSENCE_SERVER = 'mancsleverg0022'
ESSENCE_PORT_NUMBER = '8080'
ESSENCE_LINK = '/uxp/rt/html/login.html'

###Transformation Layer###
TL_SERVICE_HOST = "mancsleverg0022"
TL_SERVICE_PORT = "22"
TL_SERVER_USER = "micloud"
TL_SERVER_PASSWORD = "misys123"
TL_SERVICE_DIR = "/evgdata/FFC/mch-2.1.3.3.0-6162/config/Transformation1.3.0/"
TL_SERVICE_LOGS_DIR = "/evgdata/FFC/mch-2.1.3.3.0-6162/config/Transformation1.3.0/logs/"

###FFC###
SERVER = "http://mancsleverg0022"
PORT = "8480"
MDM_FFC_URL = "/mch-ui"

###FFC Instance###
OPEAPI_INSTANCE_TL = "openAPI_1.3.0"
OPEAPI_INSTANCE = "openAPI_1.3.0"
TEXTJMS_INSTANCE = "distributor_1.3.0"
GETTEXTJMS_INSTANCE = "distributor_1.3.0"
CBAINTERFACE_INSTANCE = "CustomInterface_1.3.0"
CBAPUSH_INSTANCE = "CustomCBAPush_1.3.0"
CUSTOM_INTERFACE_INSTANCE = "CustomInterface_1.3.0"
RESPONSE_MECHANISM_INSTANCE = "responsemechanism_1.3.0"
DWE_NOTIFICATION_INSTANCE = "dwe_notification_1.3.0"
SAPWUL_INSTANCE = 'CustomCBAPush_1.3.0'

###SFTP###
SFTP_HOST = "mancsleverg0021"
SFTP_HOST_GL = "mancsleverg0018"
SFTP_PORT = "22"
SFTP_USER = "micloud"
SFTP_PASSWORD = "misys123"

###LIQ Credential###
INPUTTER_USERNAME = ""
INPUTTER_PASSWORD = "password01"
SUPERVISOR_USERNAME = "RPTSUP01"
SUPERVISOR_PASSWORD = "password01"
MANAGER_USERNAME = "RPTMGR01"
MANAGER_PASSWORD = "password01"
LIQ_ADMIN_USERNAME = "ADMIN1"
LIQ_ADMIN_PASSWORD = "password"

###Essence Credential###
ESS_USERNAME = "brad"
ESS_PASSWORD = "welcome@99"

###Party Credential###
PARTY_USERNAME = 'brad'
PARTY_PASSWORD = 'welcome@99'
PARTY_SUPERVISOR_USERNAME  = 'superit'
PARTY_SUPERVISOR_PASSWORD = 'welcome@99'
PARTY_HTML_USER_CREDENTIALS = 'misysroot%5Cbrad:welcome%4099'
PARTY_HTML_APPROVER_CREDENTIALS = 'misysroot%5Csuperit:welcome%4099'

###FFC Credential###
MDM_FFC_Username ='admin'
MDM_FFC_Password = 'admin'

###TL Credential###
TL_USERNAME = "mgaling"
TL_PASSWORD = "password"

###SSO###
SSO_USERLINK = "mancsleverg0021"
SSO_PORT = "8080"
SSO_USERNAME = "brad"
SSO_PASSWORD = "welcome@99"
SSO_ENABLED = "NO"
SSO_SERVER = 'mancsleverg0021'
SSO_PORT_NUMBER = '8080'
SSO_URL_LINK = ""
PARTY_SSO_URL_SUFFIX = ""

###COMSEE###
COM_HOST = 'http://mancsleverg0022:9150'

##CORRESPONDENCE##
CORRES_SERVER = 'http://mancsleverg0022'
CORRES_PORT = '8480'
API_CORRES_HOST = 'http://mancsleverg0022:9150'

###Screenshots###
Screenshot_Path = "C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\Results"
SCREENSHOT_FILENAME = ""

###MDM###
MDM_HOST_TOKEN = "http://mancsleverg0021:8080"
MDM_HOST = 'http://mancsleverg0022:8081'
MDM_HOST_PARTY = 'http://mancsleverg0022:8081'
MDM_Cal_API = "/corporate/v1/calendars"
MDM_BASE_API = "/corporate/v1/baseinterestrates"
MDM_FX_API = "/corporate/v1/fxrates"
MDM_User_API = "/corporate/v1/users"
MDM_Party_API = "/bfweb/retail/v1/party/"
MDM_HOST_NONSSO = 'http://mancsleverg0022:9090'
MDM_HOST_CUSTOM_COM = 'http://mancsleverg0022:9150/custom/v1/comrlending/dealFacility/00000204'

###ActiveMQ###
ACTIVEMQ_HTML_CREDENTIALS = 'admin:admin'
ACTIVEMQ_SERVER_CREDENTIAL = 'mancsleverg0022'
ACTIVEMQ_PORT_NUMBER = '8161'
ACTIVEMQ_URL = 'http://${ACTIVEMQ_HTML_CREDENTIALS}@${ACTIVEMQ_SERVER_CREDENTIAL}:${ACTIVEMQ_PORT_NUMBER}/bfweb/servlet/GetServiceTicketForUser?redirectTo=http://${ACTIVEMQ_SERVER_CREDENTIAL}:${ACTIVEMQ_PORT_NUMBER}/admin/queues.jsp'

###MD5 site###
MD5_URL = 'http://onlinemd5.com/' 