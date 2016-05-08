import re

def formatArray(arraystrin):
    array = re.split(", |,\n", arraystrin)
    str_out = ""
    for i in range(len(array)):
        str_out += ("x\"" + str.lower(array[i][2:]) + "\", ")
    print str_out
