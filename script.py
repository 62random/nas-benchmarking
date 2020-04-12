import os
import re
import sys
OUTPUT_FILE = "output.txt"
CONTAINS_ARGS = "_"

if len(sys.argv) == 3:
    CONTAINS_ARGS = sys.argv[1]
    OUTPUT_FILE = sys.argv[2]
else:
    print("python3 script.py ______(String para verificar) ______(output)")
    print("A Executar com string verificar '_' e output 'output.txt'")


with open(os.path.join(os.getcwd(), OUTPUT_FILE), 'w+') as output: # open in readonly mode
    output.write("exec;mopsTotal;mopsThread;time;\n")
    for filename in os.listdir(os.getcwd()):
        if filename != "script.py" and filename!=OUTPUT_FILE and (not filename.endswith(".txt")):
            if CONTAINS_ARGS in filename:
                with open(os.path.join(os.getcwd(), filename), 'r') as f: # open in readonly mode
                    file = f.read()
                    mopsTotal =  re.search(" Mop/s total .* ([0-9\.]+)", file)
                    mopsThread =  re.search(" Mop/s/thread .* ([0-9\.]+)", file)
                    timeSeconds =  re.search(" Time in seconds .* ([0-9\.]+)", file)
                    print(filename)
                    print(mopsTotal.group(1))
                    print(mopsThread.group(1))
                    print(timeSeconds.group(1))
                    output.write(filename + ";" + mopsTotal.group(1) + ";" + mopsThread.group(1) + ";" + timeSeconds.group(1) + ";\n" )
