import subprocess, sys, yaml
from yaml.loader import SafeLoader

TMPSRC = "/tmp/prog.s"
TMPBIN = "/tmp/prog"

SPIKE = "/opt/riscv/bin/spike"
PK = "/opt/riscv/riscv-pk/build/pk"

# read the source code file from the first argument, if not present exit
if len(sys.argv) < 2:
    print("Usage: python3 check_tests.py <source_file>", file=sys.stderr)
    sys.exit(1)
filename = sys.argv[1]
tests = filename.replace("source.S", "tests.yaml")

supporting_code = ""
with open("support.S", "r") as src:
    supporting_code = src.read()

# template file with code pieces
codesolution = open(filename,).readlines()
idxtest  = codesolution.index("###TESTCASE###\n")

# read the yaml file with unit testing (tests)
with open(tests, "r")  as f:
    # for each test creates the code, compile and test it
    yamlsetup = yaml.load(f, Loader=SafeLoader)
    testcases = yamlsetup["testcases"]
    for testcase in testcases:            
        
        with open(TMPSRC, "w") as dst:
            print(supporting_code, file=dst)
            print("".join(codesolution[:idxtest]), file=dst)
            print(testcase["testcode"], file=dst)

        # compile it
        cflags = "-static -nostartfiles -nostdlib"
        return_code = subprocess.call("riscv64-linux-gnu-gcc {} -o {} {}".format(cflags, TMPBIN, TMPSRC).split())
        if return_code != 0:
            print("** Compilation failed. Testing aborted **", file=sys.stderr)
            sys.exit(1)

        # return 
        if return_code == 0:
            try:
                output = subprocess.check_output([SPIKE, PK, TMPBIN], universal_newlines=True)
                output = output.replace("bbl loader\n", "").strip()
                if testcase["expected"] != output:
                    print("TEST FAILED: expected \"{}\", got \"{}\"".format(
                        testcase["expected"].replace('\n', '; '), output.replace('\n', '; ')))
                    print(testcase["testcode"])
                    exit(1)
                else:   
                    print("Test passed: expected \"{}\", got \"{}\"".format(
                        testcase["expected"].replace('\n', '; '), 
                        output.replace('\n', '; ')))
                    
            except subprocess.CalledProcessError as e:
                if e.returncode > 0:
                    # Ignore non-zero positive return codes
                    if e.output:
                        print(e.output.replace("bbl loader\n", ""))
                else:
                    # But negative return codes are signals - abort
                    if e.output:
                        print(e.output.replace("bbl loader\n", ""), file=sys.stderr)
                    if e.returncode < 0:
                        print("Task failed with signal", -e.returncode, file=sys.stderr)
                    print("** Further testing aborted **", file=sys.stderr)
                    sys.exit(1)
