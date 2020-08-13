### Dataset Locations ###
APIDataSet = "C:\\Git_Evergreen\\fms_scotia\DataSet\\Integration_DataSet\\API\\API_Data_Set.xlsx"
ExcelPath = "C:\\Git_Evergreen\\fms_scotia\\DataSet\\LoanIQ_DataSet\\EVG_PTYLIQ01_BaselineBilateralCustomer.xlsx"
dataset_path = "C:\\Git_Evergreen\\fms_scotia"
CBAUAT_ExcelPath = "C:\\Git_Evergreen\\fms_cba\\DataSet\\CBAUATDeal_DataSet\\EVG_CBAUAT03.xlsx"
TL_DATASET = "C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\TL_DataSet\\TL_Data_Set.xls"
SAPWUL_DATASET = "C:\\Git_evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\Downstream_DataSet\\SAPWUL\\SAPWUL_Data_Set.xlsx"
ComSeeDataSet = 'C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\Downstream_DataSet\\ComSee\\COMSEE_Data_Set.xls'
GLExcelPath = "C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\Extract_DataSet\\GL\\EVG_GL_TestData.xls"

SERVER = "http://mancsleverg0007"
PORT = "9090"
MDM_FFC_URL="/mch-ui"

SFTP_HOST = "mancsleverg0006"
SFTP_PORT = "22"
SFTP_USER = "micloud"
SFTP_PASSWORD = "misys123"

OPEAPI_INSTANCE_TL = "API"
OPEAPI_INSTANCE = "API"
TEXTJMS_INSTANCE = "Distributor_1.2.0.1"
CBAINTERFACE_INSTANCE = "CustomInterface_v1.2.9"
CBAPUSH_INSTANCE = "CustomCBAPush_v1.2.9"
CUSTOM_INTERFACE_INSTANCE = "CustomInterface_v1.2.9"
RESPONSE_MECHANISM_INSTANCE = "responsemechanism_1.2.0.0"

DBServiceName = "MLFFC1.misys.global.ad"
DBUsername = "MCH"
DBPassword = "oracle"
DBHost = "mancsleverg0023"
DBPort = "1539"
DB_URL = "jdbc:oracle:thin:MCH@//mancsleverg0023:1539/MLFFC1.misys.global.ad"

MDM_HOST_TOKEN = "http://mancsleverg0028:8080"
MDM_HOST = "http://mancsleverg0007:8081"
MDM_HOST_PARTY = 'http://mancsleverg0031:8080'
MDM_User_API = "/corporate/v1/users"

### FFC Credentials ###
MDM_FFC_Username ='admin'
MDM_FFC_Password = 'admin'

### TL Credentials ###
TL_USERNAME = "DONATELO"
TL_PASSWORD = "password"

### LIQ Credentials ###
INPUTTER_USERNAME = "JOBINP"
INPUTTER_PASSWORD = "password"
SUPERVISOR_USERNAME = "JOBSUPER"
SUPERVISOR_PASSWORD = "password"
MANAGER_USERNAME = "JOBMANGR"
MANAGER_PASSWORD = "password"

SSO_USERLINK = "mancsleverg0028"
SSO_PORT = "8080"
USER_LINK = "mancsleverg0031"
PORT = "7080"
PARTY_URL_SUFFIX = "/uxp/rt/html/login.html"
DOMAIN = "http://misysroot"
SSO_URL_LINK = "/bfweb/servlet/GetServiceTicketForUser?redirectTo=http://"
SSO_ENABLED = "NO"

SSO_SERVER = 'mancsleverg0028'
SSO_PORT_NUMBER = '8080'
PARTY_SSO_URL = 'http://${PARTY_HTML_CREDENTIALS}@${SSO_SERVER}:${SSO_PORT_NUMBER}/bfweb/servlet/GetServiceTicketForUser?redirectTo=http://${PARTY_SERVER}/uxp/rt/html/login.html                   '
PARTY_HTML_USER_CREDENTIALS = 'misysroot%5Cbrad:welcome%4099'
PARTY_HTML_APPROVER_CREDENTIALS = 'misysroot%5Csuperit:welcome%4099'
PARTY_SUPERVISOR_USERNAME  = 'superit'
PARTY_SUPERVISOR_PASSWORD = 'superit'
PARTY_SERVER = 'mancsleverg0031:8080'
PARTY_URL = 'mancsleverg0031:7080/uxp/rt/html/login.html'
PARTY_USERNAME = "brad"
PARTY_PASSWORD = "brad"


TL_SERVICE_HOST = "mancsleverg0007"
TL_SERVICE_PORT = "22"
TL_SERVER_USER = "micloud"
TL_SERVER_PASSWORD = "misys123"
TL_SERVICE_DIR = "/evgdata/FFC/mch-2.1.3.3.0-6162/config/Transformation/"

###Screenshots###
screenshot_Path = "C:\\Git_Evergreen\\fms_scotia\\Results"
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
ESSENCE_SSO_URL = 'http://${ESSENCE_HTML_CREDENTIALS}@${SSO_SERVER}:${SSO_PORT_NUMBER}/bfweb/servlet/GetServiceTicketForUser?redirectTo=http://${ESSENCE_SERVER}:${ESSENCE_LINK}'
ESSENCE_HTML_CREDENTIALS = 'misysroot%5Cbrad:welcome%4099'
ESSENCE_SERVER = 'mancsleverg0030'
ESSENCE_PORT_NUMBER = '8080'
ESSENCE_LINK = '/uxp/rt/html/login.html'
SSO_SERVER = 'mancsleverg0028'
SSO_PORT_NUMBER = '8080'

### IEE LIQ SERVER ###
DBSERVICENAME_LIQ = 'MLLIQ.misys.global.ad'
DBUSERNAME_LIQ = 'LIQ747E3'
DBPASSWORD_LIQ = 'password'
DBHOST_LIQ = 'MANCSLEVERG0023'
DBPORT_LIQ = '1539'
DBUR_LIQ = 'jdbc:oracle:thin:@//mancsleverg0023:1539/MLLIQ.misys.global.ad'
LIQ7474_USER = 'LIQ747E3'

### IEE ESSENCE AU SERVER ###
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

### TI ###
FBTIDataset = 'C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\FBTI_DataSet\\FBTI_User_Data_Set.xlsx'
FBTIDataset_ILC = 'C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\FBTI_DataSet\\FBTI_ILC_Data_Set.xlsx'
FBTIDataset_ELC = 'C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\FBTI_DataSet\\FBTI_ELC_Data_Set.xlsx'
FBTIDataset_ESB = 'C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\FBTI_DataSet\\FBTI_ESB_Data_Set.xlsx'
FBTIDataset_FSA = 'C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\FBTI_DataSet\\FBTI_FSA_Data_Set.xlsx'
FBTIDataset_EGT = 'C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\FBTI_DataSet\\FBTI_EGT_Data_Set.xlsx'
FBTIDataset_ISB = 'C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\FBTI_DataSet\\FBTI_ISB_Data_Set.xlsx'
FBTIDataset_ODC = 'C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\FBTI_DataSet\\FBTI_ODC_Data_Set.xlsx'
FBTIDataset_IDC = 'C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\FBTI_DataSet\\FBTI_IDC_Data_Set.xlsx'
FBTIDataset_FELC = 'C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\FBTI_DataSet\\FBTI_FELC_Data_Set.xlsx'
FBTIDataset_IGT = 'C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\FBTI_DataSet\\FBTI_IGT_Data_Set.xlsx'
FBTIDataset_FILC = 'C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\FBTI_DataSet\\FBTI_FILC_Data_Set.xlsx'
FBTIDataset_FIC = 'C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\FBTI_DataSet\\FBTI_FIC_Data_Set.xlsx'
FBTIDataset_FOC = 'C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\FBTI_DataSet\\FBTI_FOC_Data_Set.xlsx'

### FBTI Supervisor ###
FBTI_SERVER = 'mancsleverg0035'
FBTI_PORT = '8443'
FBTI_URL = 'https://${FBTI_SERVER}:${FBTI_PORT}/tiplus2-global'
FBTI_USERNAME_SUPERVISOR = 'SUPERVISOR'
FBTI_PASSWORD_SUPERVISOR = '2'

### FBTI Inputter ###
FBTI_USERNAME_INPUTTER = 'INPUTTER'
FBTI_PASSWORD_INPUTTER = 'Password6'

### FBTI Reviewer ###
FBTI_USERNAME_REVIEWER = 'REVIEWER'
FBTI_PASSWORD_REVIEWER = 'Password6'

### FBTI Authoriser ###
FBTI_USERNAME_AUTHORISER = 'AUTHORISOR'
FBTI_PASSWORD_AUTHORISER = 'Password6'