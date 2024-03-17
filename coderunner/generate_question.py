import os
import sys
import yaml
import tempfile
import subprocess
from yaml.loader import SafeLoader


def generate(source, test, text, template, destfile):

    # template file with code pieces
    codesolution = open(source).readlines()
    idxglobal = codesolution.index("###GLOBALEXTRA###\n")
    idxanswer = codesolution.index("###ANSWER###\n")
    idxtest  = codesolution.index("###TESTCASE###\n")

    # dst file
    xmlfinal = open(template, "r").read()
    xmlfinal = xmlfinal.replace("###TEXT###", open(text).read())
    xmlfinal = xmlfinal.replace("###GLOBALEXTRA###", "".join(codesolution[idxglobal+1:idxanswer]))
    xmlfinal = xmlfinal.replace("###ANSWER###", "".join(codesolution[idxanswer+1:idxtest]))

    xmltests = ""

    with open(test) as f:
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
</testcase>""".format(testcase["testcode"], 
                      testcase["expected"], 
                      testcase["testcode"], 
                      testcase["display"] if "display" in testcase else "HIDE"
                      )

    xmlfinal = xmlfinal.replace("###TESTCASES###", xmltests)
    xmlfinal = xmlfinal.replace("###NAME###", yamlsetup["name"])
    xmlfinal = xmlfinal.replace("###PRELOAD###", yamlsetup["preload"])

    #print (xmlfinal)
    dstfile = open(destfile, "w+")
    dstfile.writelines(xmlfinal)

###########
# Main
###########

if len(sys.argv) != 3:
    print("Usage: ", os.path.basename(__file__), "exercize_folder", "output.xml")
    exit(1)

#TODO: Manage multilanguage in a proper way
TEMPLATE="moodle_template.xml"
SOURCE=sys.argv[1]+"/source.S"
TEST=sys.argv[1]+"/tests.yaml"
TEXT_IT=sys.argv[1]+"/text_it.html"
TEXT_EN=sys.argv[1]+"/text_en.html"

if (not os.path.exists(SOURCE) or
        not os.path.exists(TEST) or  
        not os.path.exists(TEXT_EN) or 
        not os.path.exists(TEXT_IT) or 
        not os.path.exists(TEMPLATE)):
    print(sys.argv[1], " does not contain all files needed for generating a question")
    exit(1)

generate(SOURCE, TEST, TEXT_IT, TEMPLATE, sys.argv[1] + "/" + sys.argv[2] + "_it.xml")
generate(SOURCE, TEST, TEXT_EN, TEMPLATE, sys.argv[1] + "/" + sys.argv[2] + "_en.xml")