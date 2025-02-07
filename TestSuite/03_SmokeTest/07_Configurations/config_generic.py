###General###
retry = "30x"
retry_interval = "3s" 
BROWSER = "chrome"
SCENARIO = ""
rowid = ""
TestCase_Name = ""
ExcelPath_API = ""
Test_Case = ""

###Dataset###
dataset_path = ""
ExcelPath = ""
CBAUAT_ExcelPath = ""
APIDataSet = ""
ExcelPath_API_temp = ""
AuditLogPath = ""
AuditLogPathTemp = ""
Countries_Codes = ""
TL_DATASET = ""
GLExcelPath = ""
ComSeeDataSet = ""
Downstream_DataSet = ""
COMMSEEDataSet= ""
SAPWUL_DATASET = ""
DWHExcelPath = ""

FBTIDataset = ""
FBTIDataset_ILC = ""
FBTIDataset_ELC = ""
FBTIDataset_ESB = ""
FBTIDataset_FSA = ""
FBTIDataset_EGT = ""
FBTIDataset_ISB = ""
FBTIDataset_ODC = ""
FBTIDataset_IDC = ""
FBTIDataset_FELC = ""
FBTIDataset_IGT = ""

###PARTY###
PARTY_URL = ""
PARTY_SSO_URL = ""
PARTY_SERVER = ""
PARTY_HTML_CREDENTIALS = ""
USER_LINK = ""
USER_PORT = ""
PARTY_URL_SUFFIX = ""
DOMAIN = ""

###ESSENCE###
ESSENCE_URL = ""
ESSENCE_SSO_URL = ""
ESSENCE_HTML_CREDENTIALS = ""
ESSENCE_SERVER = ""
ESSENCE_PORT_NUMBER = ""
ESSENCE_LINK = ""

###Transformation Layer###
TL_SERVICE_HOST = ""
TL_SERVICE_PORT = ""
TL_SERVER_USER = ""
TL_SERVER_PASSWORD = ""
TL_SERVICE_DIR = ""
TL_SERVICE_LOGS_DIR = ""

###FFC###
SERVER = ""
PORT = ""
MDM_FFC_URL = ""

###FFC Instance###
OPEAPI_INSTANCE_TL = ""
OPEAPI_INSTANCE = ""
TEXTJMS_INSTANCE = ""
GETTEXTJMS_INSTANCE = ""
CBAINTERFACE_INSTANCE = ""
CBAPUSH_INSTANCE = ""
CUSTOM_INTERFACE_INSTANCE = ""
RESPONSE_MECHANISM_INSTANCE = ""
DWE_NOTIFICATION_INSTANCE = ""
SAPWUL_INSTANCE = ""

###SFTP###
SFTP_HOST = ""
SFTP_HOST_GL = ""
SFTP_PORT = ""
SFTP_USER = ""
SFTP_PASSWORD = ""

###LIQ Credential###
INPUTTER_USERNAME = ""
INPUTTER_PASSWORD = ""
SUPERVISOR_USERNAME = ""
SUPERVISOR_PASSWORD = ""
MANAGER_USERNAME = ""
MANAGER_PASSWORD = ""
LIQ_ADMIN_USERNAME = ""
LIQ_ADMIN_PASSWORD = ""

###Essence Credential###
ESS_USERNAME = ""
ESS_PASSWORD = ""

###Party Credential###
PARTY_USERNAME = ""
PARTY_PASSWORD = ""
PARTY_SUPERVISOR_USERNAME  = ""
PARTY_SUPERVISOR_PASSWORD = ""
PARTY_HTML_USER_CREDENTIALS = ""
PARTY_HTML_APPROVER_CREDENTIALS = ""

###FFC Credential###
MDM_FFC_Username =""
MDM_FFC_Password = ""

###TL Credential###
TL_USERNAME = ""
TL_PASSWORD = ""

###SSO###
SSO_USERLINK = ""
SSO_PORT = ""
SSO_USERNAME = ""
SSO_PASSWORD = ""
SSO_ENABLED = ""
SSO_SERVER = ""
SSO_PORT_NUMBER = ""
SSO_URL_LINK = ""
PARTY_SSO_URL_SUFFIX = ""

###COMSEE###
COM_HOST = ""

##CORRESPONDENCE##
CORRES_SERVER = ""
CORRES_PORT = ""
API_CORRES_HOST = ""

###Screenshots###
Screenshot_Path = ""
SCREENSHOT_FILENAME = ""

###MDM###
MDM_HOST_TOKEN = ""
MDM_HOST = ""
MDM_HOST_PARTY = ""
MDM_Cal_API = ""
MDM_BASE_API = ""
MDM_FX_API = ""
MDM_User_API = ""
MDM_Party_API = ""
MDM_HOST_NONSSO = ""
MDM_HOST_CUSTOM_COM = ""

###ActiveMQ###
ACTIVEMQ_HTML_CREDENTIALS = ""
ACTIVEMQ_SERVER_CREDENTIAL = ""
ACTIVEMQ_PORT_NUMBER = ""
ACTIVEMQ_URL = ""

###MD5 site###
MD5_URL = ""

import os
project_path = os.path.dirname(os.path.realpath(__file__)).replace("MDM_ConfigFile","")
dataset_path = os.path.dirname(os.path.abspath('.//Data_Set'))
screenshot_path = os.path.dirname(os.path.abspath('.//Results'))
apidataset_path = os.path.dirname(os.path.abspath('.//API_DataSet'))

