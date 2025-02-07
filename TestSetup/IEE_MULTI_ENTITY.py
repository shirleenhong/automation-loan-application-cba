dataset_path = "C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen"
# ExcelPath = "C:\\Git_Evergreen\\evergreen_projects\\CBA_Evergreen\\DataSet\\LIQ_DataSet\\EVG_PTYLIQ08_ComprehensiveDeal.xls"
GLExcelPath = "C:\\Git_Evergreen\\fms_cba\\DataSet\\Integration_DataSet\Extracts\\GL\\EVG_GL_TestData_MultiEntity.xlsx"


SERVER = "http://mancsleverg0007"
PORT = "9090"
MDM_FFC_URL="/mch-ui"

SFTP_HOST = "mancsleverg0006"
SFTP_PORT = "22"
SFTP_USER = "sftpuser"

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

INPUTTER_USERNAME = "RPTINP01"
INPUTTER_PASSWORD = "password01"
SUPERVISOR_USERNAME = "RPTSUP01"
SUPERVISOR_PASSWORD = "password01"
MANAGER_USERNAME = "RPTMGR01"
MANAGER_PASSWORD = "password01"

SSO_USERLINK = "mancsleverg0028"
SSO_PORT = "8080"
USER_LINK = "mancsleverg0031"
USER_PORT = "8080"
PARTY_URL_SUFFIX = "/uxp/rt/html/login.html"
DOMAIN = "http://misysroot"
SSO_URL_LINK = "/bfweb/servlet/GetServiceTicketForUser?redirectTo=http://"
SSO_ENABLED = "NO"

SSO_SERVER = 'mancsleverg0031'
SSO_PORT_NUMBER = '8080'

###ESSENCE###
ESSENCE_URL = '${ESSENCE_SERVER}:${ESSENCE_PORT_NUMBER}${ESSENCE_LINK}'
ESSENCE_SSO_URL = 'http://${ESSENCE_HTML_CREDENTIALS}@${SSO_SERVER}:${SSO_PORT_NUMBER}/bfweb/servlet/GetServiceTicketForUser?redirectTo=http://${ESSENCE_SERVER}:${ESSENCE_LINK}'
ESSENCE_HTML_CREDENTIALS = 'misysroot%5Cbrad:welcome%4099'
ESSENCE_SERVER = 'mancsleverg0033'
ESSENCE_PORT_NUMBER = '8080'
ESSENCE_LINK = '/uxp/rt/html/login.html'
SSO_SERVER = 'mancsleverg0031'

###Essence Credential###
ESS_USERNAME = "superit"
ESS_PASSWORD = "superit"

### IEE LIQ SERVER ###
DBSERVICENAME_LIQ = 'MLLIQ.misys.global.ad'
DBUSERNAME_LIQ = 'LIQ7512UPG'
DBPASSWORD_LIQ = 'password'
DBHOST_LIQ = 'MANCSLEVERG0023'
DBPORT_LIQ = '1539'
DBUR_LIQ = 'jdbc:oracle:thin:@//mancsleverg0023:1539/MLLIQ.misys.global.ad'
LIQDB_SCHEMA = 'LIQ7512UPG'

###EU User###
BFBANKFUSION_USER = 'EUBANKFUSION'
BFTB_BRANCH_TABLE = 'BFTB_BRANCH'
BFBRANCHNAME = 'BFBRANCHNAME'
BFBRANCHSORTCODEPK = 'BFBRANCHSORTCODEPK'
AUBANKFUSION_USER = 'AUBANKFUSION'

### IEE ESSENCE EU SERVER ###
DBSERVICENAME_ESS_AU = 'FBE203R'
DBUSERNAME_ESS_AU = 'audbusr'
DBPASSWORD_ESS_AU = 'password'
DBHOST_ESS_AU = 'MANCSLEVERG0023'
DBPORT_ESS_AU = '1521'
DBUR_ESS_AU = 'jdbc:oracle:thin:@//mancsleverg0023:1521/AUGLBPDB'

### ESSENCE SERVER ###
DBSERVICENAME_ESS = 'FBE203R'
DBUSERNAME_ESS = 'audbusr'
DBPASSWORD_ESS = 'password'
DBHOST_ESS = 'MANCSLEVERG0023'
DBPORT_ESS = '1521'
DBUR_ESS = 'jdbc:oracle:thin:@//mancsleverg0023:1521/FBE203R'

### IEE PARTY SERVER ###
DBSERVICENAME_PTY = 'AUPTYPDB'
DBUSERNAME_PTY = 'bfdbusr'
DBPASSWORD_PTY = 'password'
DBHOST_PTY = 'MANCSLEVERG0023'
DBPORT_PTY = '1521'
DBUR_PTY = 'jdbc:oracle:thin:@//MANCSLEVERG0023:1521/AUPTYPDB'


###SFTP HOST/CREDENTIALS###
SFTP_HOST_GL = "mancsleverg0007"
SFTP_PASSWORD = "t3stOnly?"

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
TL_CAL_ACK_MESSAGE_SOURCENAME = 'ccb_source_cal'
TL_BASE_ACK_MESSAGE_SOURCENAME = 'ccb_source_base'
CBACorrespUpdateMQ_Instance = 'CustomCBAPush_v1.4.0'
FFC1CMUpdateSourceMQ_Instance = 'CustomInterface_v1.4.0'

### GL Postings/Extracts###
GL_LIQ_USER = 'RPTINP01'
GL_LIQ_PASSWORD = 'password02'
GL_EXTRACT_PATH = '/evgdata/FBE_GL_Extract/extract'
GL_DECRYPTOR_TOOL_PATH = 'C:\\Git_Evergreen\\fms_cba\\DataSet\\Integration_DataSet\Extracts\\GL\\Decryptor_Tool'
GL_DECRYPTOR_JAR = 'Decryptor-1.0.0-jar-with-dependencies.jar'
GL_DECRYPTION_PART1 = 'C:/Git_Evergreen/fms_cba/DataSet/Integration_DataSet/Extracts/GL/Decryptor_Tool/GL_DECRYPTION_PART1.vbs'
GL_DECRYPTION_PART2 = 'C:/Git_Evergreen/fms_cba/DataSet/Integration_DataSet/Extracts/GL/Decryptor_Tool/GL_DECRYPTION_PART2.vbs'
GL_DECRYPTION_PART3 = 'C:/Git_Evergreen/fms_cba/DataSet/Integration_DataSet/Extracts/GL/Decryptor_Tool/GL_DECRYPTION_PART3.vbs'
GL_PGP_SECRET_KEY = 'secret.skr'
GL_PASSPHRASE = 'oracle'
GL_CSV_GPG_FILEEXTENSION = '.csv.gpg'
ESS_AUWASADMIN_SCHEMA = "AUWASADMIN"
ESS_EUWASADMIN_SCHEMA = "EUWASADMIN"
GL_VALIDATION_TOOL_PATH = 'C:\\Git_Evergreen\\fms_cba\\DataSet\\Integration_DataSet\Extracts\\GL\\Validation_Tool'
GL_VALIDATION_TOOL_JAR_AU = 'gpgCheck-1.0.3-jar-with-dependencies.jar'
GL_VALIDATION_TOOL_JAR_EU = 'gpgCheck-1.0.3-jar-with-dependencies-EU.jar'

### Batch EOD ###
PUTTY_PATH = "C:\\Program Files\\PuTTY\\putty.exe"
PUTTY_HOSTNAME = "mancsleverg0005"
PUTTY_PORT = "22"
PUTTY_USERNAME = "micloud"
PUTTY_PASSWORD = "misys123"

### DNA ###
DNA_SERVER = 'mancsleverg0021'
DNA_SERVER_LIQ = 'mancsleverg0022'
DNA_PORT = '22'
DNA_SERVER_USER = 'sftpuser2'
DNA_SERVER_PASSWORD = 'luckyroll76'
DNA_EXTRACTION_AREA_PATH = '/evgdata/STREAMSETS/workspace/extraction_area/COMRLENDING/'
DNA_CCB_LIQ_FILENAME = 'CCB_LIQ_'
DNA_DATAASSURANCE_FILENAME = 'DATAASSURANCE_'
DNA_DAT_EXT = '.DAT'

###Screenshots###
screenshot_path = "C:\\Git_Evergreen\\fms_cba\\Results"


