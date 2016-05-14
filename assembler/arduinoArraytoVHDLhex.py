import re

def formatArray(arraystrin):
    array = re.split("  |, |,\n", arraystrin)
    str_out = ""
    for i in range(len(array)):
        #print(array[i])
        if ((i%16) == 15):
            if (i > 999):
                str_out += (str(i) + " => x\"" + str.lower(array[i][2:]) + "\",\n")
            elif (i > 99):
                str_out += (str(i) + "  => x\"" + str.lower(array[i][2:]) + "\",\n")
            elif (i > 9):
                str_out += (str(i) + "   => x\"" + str.lower(array[i][2:]) + "\",\n")
            else:
                str_out += (str(i) + "    => x\"" + str.lower(array[i][2:]) + "\",\n")
        else:
            if (i > 999):
                str_out += (str(i) + " => x\"" + str.lower(array[i][2:]) + "\", ")
            elif (i > 99):
                str_out += (str(i) + "  => x\"" + str.lower(array[i][2:]) + "\", ")
            elif (i > 9):
                str_out += (str(i) + "   => x\"" + str.lower(array[i][2:]) + "\", ")
            else:
                str_out += (str(i) + "    => x\"" + str.lower(array[i][2:]) + "\", ")
    print str_out
