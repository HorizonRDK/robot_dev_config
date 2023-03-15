import sys
import os
from xml.dom.minidom import parse
import xml.dom.minidom

def search_files_with_suffix(folder_path, suffix, numlist):
    # count = 0
    # 获取文件夹中所有文件或子文件夹
    dirs = os.listdir(folder_path)
    for currentFile in dirs:
        fullPath = folder_path + '/' + currentFile
        if os.path.isdir(fullPath):
            # count = count + 
            search_files_with_suffix(fullPath, suffix, numlist)
        elif currentFile.find(suffix) != -1:
            # 解析xml文件
            DomTree = xml.dom.minidom.parse(fullPath)
            Testsuites = DomTree.documentElement
            tests = 0
            failures = 0
            errors = 0
            skipped = 0
            if Testsuites.hasAttribute("tests"):
              tests = int(Testsuites.getAttribute("tests"))
            if Testsuites.hasAttribute("failures"):
              failures = int(Testsuites.getAttribute("failures"))
            if Testsuites.hasAttribute("errors"):
              errors = int(Testsuites.getAttribute("errors"))
            if Testsuites.hasAttribute("skipped"):
              skipped = int(Testsuites.getAttribute("skipped"))
            numlist[0] = numlist[0] + tests
            numlist[1] = numlist[1] + errors
            numlist[2] = numlist[2] + failures
            numlist[3] = numlist[3] + skipped
            if failures !=0 or errors !=0:
              package_start_index = fullPath.index('build/') + 6
              package_end_index = fullPath.index('test_results/') - 1
              package_name=fullPath[package_start_index:package_end_index]
              # print("package %s: %d tests, %d errors, %d failures, %d skipped"%(package_name, tests, errors, failures, skipped))
              testsuites_nodename = Testsuites.nodeName
              if testsuites_nodename == "testsuites":
                testsuites_name = Testsuites.getAttribute("name")
                testsuite_list = Testsuites.getElementsByTagName("testsuite")
                for testsuite in testsuite_list:
                  testsuite_failures = 0
                  testsuite_errors = 0
                  testsuite_name = testsuite.getAttribute("name")
                  if testsuite.hasAttribute("failures"):
                    testsuite_failures = int(testsuite.getAttribute("failures"))
                  if testsuite.hasAttribute("errors"):
                    testsuite_errors = int(testsuite.getAttribute("errors"))
                  if testsuite_failures != 0:
                    testcase_list = testsuite.getElementsByTagName("testcase")
                    for testcase in testcase_list:
                      testcase_name = testcase.getAttribute("name")
                      failure_list = testcase.getElementsByTagName("failure")
                      if len(failure_list) != 0:
                        print("package: %s testsuites: %s testsuite: %s testcase: %s"%(package_name,testsuites_name,testsuite_name,testcase_name))
                      for failure in failure_list:
                        message = failure.getAttribute("message")
                        print("failure message: {%s}"%(message))
                  if testsuite_errors != 0:
                    testcase_list = testsuite.getElementsByTagName("testcase")
                    for testcase in testcase_list:
                      testcase_name = testcase.getAttribute("name")
                      error_list = testcase.getElementsByTagName("error")
                      if len(error_list) != 0:
                        print("package: %s testsuites: %s testsuite: %s testcase: %s"%(package_name,testsuites_name,testsuite_name,testcase_name))
                      for error in error_list:
                        message = error.getAttribute("message")
                        print("error message: {%s}"%(message))
              elif testsuites_nodename == "testsuite":
                  testsuite_name = Testsuites.getAttribute("name")
                  if failures != 0:
                    testcase_list = Testsuites.getElementsByTagName("testcase")
                    for testcase in testcase_list:
                      testcase_name = testcase.getAttribute("name")
                      failure_list = testcase.getElementsByTagName("failure")
                      if len(failure_list) != 0:
                        print("package: %s testsuite: %s testcase: %s"%(package_name,testsuite_name,testcase_name))
                      for failure in failure_list:
                        message = failure.getAttribute("message")
                        print("failure message: {%s}"%(message))
                  if errors != 0:
                    testcase_list = Testsuites.getElementsByTagName("testcase")
                    for testcase in testcase_list:
                      testcase_name = testcase.getAttribute("name")
                      error_list = testcase.getElementsByTagName("error")
                      if len(error_list) != 0:
                        print("package: %s testsuite: %s testcase: %s"%(package_name,testsuite_name,testcase_name))
                      for error in error_list:
                        message = error.getAttribute("message")
                        print("error message: {%s}"%(message))
              print("----------------------------------\n") 




if __name__ == "__main__":
    folder_path = sys.argv[1]
    suffix = ".gtest.xml"
    numlist = [0,0,0,0] #[tests, errors, failures, skipped]
    search_files_with_suffix(folder_path, suffix, numlist)
    print("=============================")
    print("Summary: %d tests, %d errors, %d failures, %d skipped"%(numlist[0], numlist[1], numlist[2], numlist[3]))
