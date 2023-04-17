import os
import sys
import yaml
import tempfile
import subprocess
from yaml.loader import SafeLoader

if len(sys.argv) != 3:
    print("Usage: ", os.path.basename(__file__), "exercize_folder", "output_xml")
    exit(1)

TEMPLATE="moodle_template.xml"
SOURCE=sys.argv[1]+"/source.S" 
TEST=sys.argv[1]+"/tests.yaml" 
TEXT=sys.argv[1]+"/text.html" 

if not os.path.exists(SOURCE) or not os.path.exists(TEST) or not os.path.exists(TEXT) or not os.path.exists(TEMPLATE): 
    print(sys.argv[1], " does not contain all files needed for generating a question")
    exit(1)

# template file with code pieces
codesolution = open(SOURCE).readlines()
idxglobal = codesolution.index("###GLOBALEXTRA###\n")
idxanswer = codesolution.index("###ANSWER###\n")
idxtest  = codesolution.index("###TESTCASE###\n")

# dst file
xmlfinal = open(TEMPLATE, "r").read()
xmlfinal = xmlfinal.replace("###TEXT###", open(TEXT).read())
xmlfinal = xmlfinal.replace("###GLOBALEXTRA###", "".join(codesolution[idxglobal+1:idxanswer]))
xmlfinal = xmlfinal.replace("###ANSWER###", "".join(codesolution[idxanswer+1:idxtest]))

xmltests = ""

with open(sys.argv[1] + "/tests.yaml") as f:
    # for each test creates the code, compile and test it

    yamlsetup = yaml.load(f, Loader=SafeLoader)
    testcases = yamlsetup["testcases"]
    for testcase in testcases:
        xmltests += """
<testcase testtype="0" useasexample="0" hiderestiffail="0" mark="1.00">
    <testcode>
        <text><![CDATA[
{}
        ]]>
        </text>
    </testcode>
    <stdin>
        <text></text>
    </stdin>
    <expected>
        <text>{}</text>
    </expected>
    <extra>
        <text><![CDATA[
{}
        ]]></text>
    </extra>
    <display>
        <text>{}</text>
    </display>
</testcase>""".format(testcase["testcode"], testcase["expected"], testcase["testcode"], testcase["display"])

xmlfinal = xmlfinal.replace("###TESTCASES###", xmltests)
xmlfinal = xmlfinal.replace("###NAME###", yamlsetup["name"])
xmlfinal = xmlfinal.replace("###PRELOAD###", yamlsetup["preload"])

#print (xmlfinal)
dstfile = open(sys.argv[2], "w+")
dstfile.writelines(xmlfinal)
