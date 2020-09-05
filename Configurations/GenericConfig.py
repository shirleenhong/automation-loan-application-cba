### Dataset Locations ###
APIDataSet = "C:\\Git_Evergreen\\fms_scotia\DataSet\\Integration_DataSet\\API\\API_Data_Set.xlsx"
ExcelPath = "C:\\Git_Evergreen\\fms_cba\DataSet\\LoanIQ_DataSet\\EVG_PTYLIQ01_BaselineBilateralCustomer.xlsx"
dataset_path = "C:\\Git_Evergreen\\fms_cba"
CBAUAT_ExcelPath = "C:\\Git_Evergreen\\fms_cba\\DataSet\\CBAUATDeal_DataSet\\EVG_CBAUAT03.xlsx"
TL_DATASET = "C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\TL_DataSet\\TL_Data_Set.xls"
SAPWUL_DATASET = "C:\\Git_evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\Downstream_DataSet\\SAPWUL\\SAPWUL_Data_Set.xlsx"
ComSeeDataSet = 'C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\Downstream_DataSet\\ComSee\\COMSEE_Data_Set.xls'
GLExcelPath = "C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\Extract_DataSet\\GL\\EVG_GL_TestData.xls"
PTY_DATASET = "C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\PTY_DataSet\\PTY_DataSet.xlsx"
DWELIQFunc_Dataset = "C:\\Git_Evergreen\\fms_cba\\DataSet\\Integration_DataSet\\Extracts\\DWE_LIQ\\DWELIQ_Functional_TestData.xlsx"

SERVER = "http://mancsleverg0007"
PORT = "9090"
MDM_FFC_URL="/mch-ui"

SFTP_HOST = "mancsleverg0005"
SFTP_PORT = "22"
SFTP_USER = "micloud"
SFTP_PASSWORD = "misys123"

OPEAPI_INSTANCE_TL = "openAPI_1.3.0"
OPEAPI_INSTANCE = "openAPI_1.3.0"
TEXTJMS_INSTANCE = "distributor_1.3.0"
CBAINTERFACE_INSTANCE = "CustomInterface_v1.3.2"
CBAPUSH_INSTANCE = "CustomCBAPush_v1.3.2"
CUSTOM_INTERFACE_INSTANCE = "CustomInterface_v1.3.2"
RESPONSE_MECHANISM_INSTANCE = "responsemechanism_1.3.0"

DBServiceName = "MLFFC1.misys.global.ad"
DBUsername = "MCH"
DBPassword = "oracle"
DBHost = "mancsleverg0023"
DBPort = "1539"
DB_URL = "jdbc:oracle:thin:MCH@//mancsleverg0023:1539/MLFFC1.misys.global.ad"

MDM_HOST_TOKEN = "http://mancsleverg0028:8080"
MDM_HOST = "http://mancsleverg0007:8081"
MDM_HOST_PARTY = 'http://mancsleverg0007:8081'
MDM_User_API = "/corporate/v1/users"

### FFC Credentials ###
MDM_FFC_Username ='admin'
MDM_FFC_Password = 'admin'

### TL Credentials ###
TL_USERNAME = "JCUSR01"
TL_PASSWORD = "password"
INPUTTER_USERNAME = "WBAYERS"
INPUTTER_PASSWORD = "password01"
SUPERVISOR_USERNAME = "MWHEELER"
SUPERVISOR_PASSWORD = "password01"
MANAGER_USERNAME = "DHENDERS"
MANAGER_PASSWORD = "password01"

SSO_USERLINK = "mancsleverg0028"
SSO_PORT = "8080"
USER_LINK = "mancsleverg0031"
USER_PORT = "8080"
PARTY_SSO_URL_SUFFIX = "/uxp/rt/html/login.html"
DOMAIN = "http://misysroot"
SSO_URL_LINK = "/bfweb/servlet/GetServiceTicketForUser?redirectTo=http://"
SSO_ENABLED = "NO"

SSO_SERVER = 'mancsleverg0031'
SSO_PORT_NUMBER = '7080'
PARTY_SSO_URL = 'http://${PARTY_HTML_CREDENTIALS}@${SSO_SERVER}:${SSO_PORT_NUMBER}/bfweb/servlet/GetServiceTicketForUser?redirectTo=http://${PARTY_SERVER}/uxp/rt/html/login.html                   '
PARTY_HTML_USER_CREDENTIALS = 'misysroot%5Cbrad:welcome%4099'
PARTY_HTML_APPROVER_CREDENTIALS = 'misysroot%5Csuperit:welcome%4099'
PARTY_SUPERVISOR_USERNAME  = 'superit'
PARTY_SUPERVISOR_PASSWORD = 'superit'
PARTY_SERVER = 'mancsleverg0031:7080'
PARTY_URL = 'mancsleverg0031:7080/uxp/rt/html/login.html'

###Party Credential###
PARTY_USERNAME = 'amipac'
PARTY_PASSWORD = 'password'

TL_SERVICE_HOST = "mancsleverg0007"
TL_SERVICE_PORT = "22"
TL_SERVER_USER = "micloud"
TL_SERVER_PASSWORD = "misys123"
TL_SERVICE_DIR = "/evgdata/FFC/mch-2.1.3.3.0-6162/config/Transformation_129/"

###Screenshots###
screenshot_Path = "C:\\Git_Evergreen\\fms_cba\\Results"
SCREENSHOT_FILENAME = ""

###LIQ ADMIN CREDENTIALS###
LIQ_ADMIN_USERNAME = "ADMIN1"
LIQ_ADMIN_PASSWORD = "password"

###CORRESPONDENCE###
CORRES_SERVER = 'http://mancsleverg0007'
CORRES_PORT = '8480'
API_CORRES_HOST = 'http://mancsleverg0007:9150'

###COMSEE###
COM_HOST = 'http://mancsleverg0007:9150'

###SAPWUL###
SAPWUL_INSTANCE = 'CustomCBAPush_v1.2.9'

###ESSENCE###
ESSENCE_URL = '${ESSENCE_SERVER}:${ESSENCE_PORT_NUMBER}${ESSENCE_LINK}'
ESSENCE_SSO_URL = 'http://${ESSENCE_HTML_CREDENTIALS}@${SSO_SERVER}:${SSO_PORT_NUMBER}/bfweb/servlet/GetServiceTicketForUser?redirectTo=http://${ESSENCE_SERVER}:${ESSENCE_LINK}'
ESSENCE_HTML_CREDENTIALS = 'misysroot%5Cbrad:welcome%4099'
ESSENCE_SERVER = 'mancsleverg0033'
ESSENCE_PORT_NUMBER = '8080'
ESSENCE_LINK = '/uxp/rt/html/login.html'
SSO_SERVER = 'mancsleverg0028'

###Essence Credential###
ESS_USERNAME = "brad"
ESS_PASSWORD = "brad"

### IEE LIQ SERVER ###
DBSERVICENAME_LIQ = 'MLLIQ.misys.global.ad'
DBUSERNAME_LIQ = 'LIQ747E3'
DBPASSWORD_LIQ = 'password'
DBHOST_LIQ = 'MANCSLEVERG0023'
DBPORT_LIQ = '1539'
DBUR_LIQ = 'jdbc:oracle:thin:@//mancsleverg0023:1539/MLLIQ.misys.global.ad'
LIQ7474_USER = 'LIQ747E3'

###AU User###
BFBANKFUSION_USER = 'AUBANKFUSION'
BFTB_BRANCH_TABLE = 'BFTB_BRANCH'
BFBRANCHNAME = 'BFBRANCHNAME'
BFBRANCHSORTCODEPK = 'BFBRANCHSORTCODEPK'
AUBANKFUSION_USER = 'AUBANKFUSION'

# ### IEE ESSENCE AU SERVER ###
DBSERVICENAME_ESS_AU = 'AUGLBPDB'
DBUSERNAME_ESS_AU = 'bfdbusr'
DBPASSWORD_ESS_AU = 'password'
DBHOST_ESS_AU = 'MANCSLEVERG0023'
DBPORT_ESS_AU = '1521'
DBUR_ESS_AU = 'jdbc:oracle:thin:@//mancsleverg0023:1521/AUGLBPDB'




### IEE PARTY SERVER ###
DBSERVICENAME_PTY = 'AUPTYPDB'
DBUSERNAME_PTY = 'bfdbusr'
DBPASSWORD_PTY = 'password'
DBHOST_PTY = 'MANCSLEVERG0023'
DBPORT_PTY = '1521'
DBUR_PTY = 'jdbc:oracle:thin:@//MANCSLEVERG0023:1521/AUPTYPDB'


###SFTP HOST/CREDENTIALS###
SFTP_HOST_GL = "mancsleverg0005"
SFTP_PORT = "22"
SFTP_USER = "micloud"
SFTP_PASSWORD = "misys123"

###FFC MCH DB DETAILS###
DBHost = 'mancsleverg0023'
DBPort = '1539'
DBServiceName = 'MLFFC1.misys.global.ad'
DWE_NOTIFICATION_INSTANCE = 'notification'

###FFC Credential###
MDM_FFC_Username ='admin'
MDM_FFC_Password = 'admin'

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