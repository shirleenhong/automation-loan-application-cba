from Config import robot_project_path,test_case_folder_name,stream
import os
from lxml import etree as ET
from robot.parsing.model import TestData

def create_controller_xml_file():
    testcase_folder = "{}/{}".format(robot_project_path,test_case_folder_name)
    filepath = "{}/{}.xml".format(robot_project_path,stream)
    robot_suite_path = get_all_robot_suite_files(testcase_folder)
    root = ET.Element("robotTest")
    for suite in robot_suite_path:
        p = ET.SubElement(root, "testSuite", name=suite[1], path=suite[0],tag="",runAllTestcases="",toRun="yes")
        suite_testcase = TestData(parent=None, source=suite[0])
        for testcase in suite_testcase.testcase_table:
            ET.SubElement(p,"testCase",testcaseName=testcase.name,toRun="yes")
    tree = ET.ElementTree(root)
    tree.write(filepath, pretty_print=True,xml_declaration=True,encoding="utf-8")
    
def get_all_robot_suite_files(dir):
    robot_suite_path = []
    for root, dirs, files in os.walk(dir):  # root = curdir, dir = subfolder name
        for name in files:
            if ".robot" in name and "__init__.robot" not in name:
                robot_suite_path.append([os.path.join(root, name),name])
    return robot_suite_path
    
create_controller_xml_file()
