import fileinput
import sys

for line in fileinput.input(sys.argv[1], inplace=True):
    if 'config_py = ' in line:
        print("config_py = normalized_path('Configuration')")
    elif 'swig_lib = ' in line:
        print("swig_lib = normalized_path('')")
    elif 'swig_py = ' in line:
        print("swig_py = normalized_path('')")
    else:
        print(line)