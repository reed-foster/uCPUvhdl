import re

def remapXBM_128x64(xbm_array):
    array = re.split(", |,\n", xbm_array)
    remap = []
    #print array
    if (len(array) != 1024):
        return "invalid array size"
    for j in range(8):
        for i in range(16):
            byte0 = hextobin_byte(array[128 * j + i])
            byte1 = hextobin_byte(array[128 * j + i + 16])
            byte2 = hextobin_byte(array[128 * j + i + 32])
            byte3 = hextobin_byte(array[128 * j + i + 48])
            byte4 = hextobin_byte(array[128 * j + i + 64])
            byte5 = hextobin_byte(array[128 * j + i + 80])
            byte6 = hextobin_byte(array[128 * j + i + 96])
            byte7 = hextobin_byte(array[128 * j + i + 112])
            for i in range(8):
                retstr = byte7[7-i] + byte6[7-i] + byte5[7-i] + byte4[7-i] + byte3[7-i] + byte2[7-i] + byte1[7-i] + byte0[7-i]
                retstr = bintohex_byte(retstr)
                remap.append(retstr)
    return remap
        

def hextobin_byte(hexstr):
    return bin(int(hexstr, 16))[2:].zfill(8)

def bintohex_byte(binstr):
    return ("0x" + hex(int(binstr,2))[2:].zfill(2))

def xbmtovhdl(xbm_array):
    return formatArray(remapXBM_128x64(xbm_array))

def formatArray(array):
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
    return str_out
