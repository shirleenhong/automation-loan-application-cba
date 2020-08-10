from Config import robot_project_path,test_case_folder_name,environment,stream
import os
from lxml import etree as ET
import time
import datetime

def run_test():
    if not os.path.exists(robot_project_path):
        raise AssertionError("Invalid Input Error ! \nPath: {} doesnot exist".format(robot_project_path))
    filepath = "{}/{}.xml".format(robot_project_path,stream)
    if not os.path.exists(filepath):
        raise AssertionError("Invalid Input Error ! \nPath: {} doesnot exist".format(filepath))
    st = datetime.datetime.fromtimestamp(time.time()).strftime('%d-%m-%Y_%I-%M-%S %p')
    results_path = "{}/{}".format(robot_project_path,"Results")
    if not os.path.exists(results_path):
        os.makedirs(results_path)
    timestamp_path = "{}/{}".format(results_path, st)
    if not os.path.exists(timestamp_path):
        os.makedirs(timestamp_path)
    doc = ET.parse(filepath)
    root = doc.getroot()
    output_xml_count = 1
    global pythonpath
    pythonpath = get_pythonpath_from_red_xml()
    for test_suite in root:
        path = test_suite.get("path")
        tags = test_suite.get("tag")
        if path:
            if test_suite.get("toRun").upper() == "YES":
                if test_suite.get("runAllTestcases").upper() == "YES":
                    output_xml_count = run_test_suite(path,tags,output_xml_count,timestamp_path)
                else:
                    testcase_names = []
                    for test_case in test_suite:
                        testcase_name = test_case.get("testcaseName")
                        if testcase_name:
                            if test_case.get("toRun").upper() == "YES":
                                testcase_names.append(testcase_name)
                    output_xml_count = run_testcase(["|".join(testcase_names),path],output_xml_count,timestamp_path)
    os.chdir(robot_project_path)
    project_name = os.path.basename(robot_project_path)
    os.system('rebot --outputdir "{}" --name "{}" --flattenkeywords foritem --splitlog --output file --output output.xml  "{}/output*.xml" '.format(timestamp_path,project_name,timestamp_path))

    
def run_test_suite(test_suites_to_run,tags,output_xml_count,timestamp_path):
    if tags:
        if "|" in tags:
            tag = ""
            for t in tags.split("|"):
                tag = tag + " -i {}".format(t)
        else:
            tag = "-i {}".format(tags)
        run_cmd = 'pybot --variablefile "{}" -P "{}" --variablefile "{}"--outputdir "{}" --output output_{}.xml --log NONE --report NONE {} "{}"'.format(environment,pythonpath,timestamp_path,output_xml_count,tag,test_suites_to_run)
    else:
        run_cmd = 'pybot --variablefile "{}" -P "{}" --variablefile "{}" --outputdir "{}" --output NONE --log NONE --report NONE "{}"'.format(environment,pythonpath,timestamp_path,output_xml_count,test_suites_to_run)
    os.system(run_cmd)
    output_xml_count = output_xml_count + 1
    return output_xml_count
    
def run_testcase(test_case_details,output_xml_count,reports):
    if "|" in test_case_details[0]:
        test_case_arg = ""
        for t in test_case_details[0].split("|"):
            test_case_arg = test_case_arg + ' --test "{}"'.format(t)
        run_cmd = 'pybot --variablefile "{}" -P "{}" --outputdir "{}" --output output_{}.xml --log NONE --report NONE {} "{}"'.format(environment,pythonpath,reports,output_xml_count,test_case_arg,test_case_details[1])
    else:
        run_cmd = 'pybot --variablefile "{}" -P "{}" --outputdir "{}" --output output_{}.xml --log NONE --report NONE --test "{}" "{}"'.format(environment,pythonpath,reports,output_xml_count,test_case_details[0],test_case_details[1])
    os.system(run_cmd)
    output_xml_count = output_xml_count + 1
    return output_xml_count
    
def get_pythonpath_from_red_xml():
    root = None
    xml_parse = ET.parse("{}/red.xml".format(robot_project_path))
    doc = xml_parse.getroot().findall('variable')
    pythonpath = []
    for d in doc:
        if d.get('name') == '${Root}':
            root = d.get('value')
            break
    if not root:
        raise AssertionError("UnifiedTestFramework path is not set in red.xml file !! \n Add ${Root} variable and set it to the path of UnifiedTestFramework")
    pythonpath.append(root)
    pythonpath.append("{}/Libraries/Common".format(root).replace("\\",os.sep).replace("/",os.sep))
    doc = xml_parse.getroot().findall('referencedLibrary')
    for d in doc:
        if d.get('type') == "PYTHON":
            if d.get("path").split("/")[0] == root.split(os.sep)[-1]:
                lib_path = "{}{}{}".format(root, os.sep, os.sep.join(d.get("path").split("/")[1:]))
            else:
                lib_path = d.get("path")
            if lib_path and lib_path not in pythonpath:
                pythonpath.append(lib_path)
    pythonpath = ":".join(pythonpath)
    return pythonpath

run_test()

