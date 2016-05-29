from Tkinter import *
from tkFileDialog import *
from tkFont import *
import os.path
import sys
import re
import math
from xbmarray_remapper import *

oledwidth = 128
oledheight = 64
canvaswidth = 640
canvasheight = 320
pixwidth = canvaswidth/oledwidth

canvasarray = [
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]

basefilename = "Untitled"
filename = ""
fileexists = False

eraser = "square"
brush = "star"
brushsize = "small"
erasersize = "small"

def openFile():
    global filename
    global basefilename
    global saved
    global fileexists
    openfilename = askopenfilename(filetypes = [("OLED Bitmap Files", "*.obm"),("XBM Bitmap Files", "*.xbm")])
    if openfilename is not None and openfilename != '':
        filename = openfilename
        name, ext = os.path.splitext(filename)
        basefilename = os.path.basename(filename)
        bmpfile = open(filename, "r")
        if ext == ".obm":
            bmpfile.seek(0)
            bmpdata = bmpfile.read()
            bmparray = re.split(", ", bmpdata)
            for i in range(len(canvasarray)):
                canvasarray[i] = int(bmparray[i],16)
        if ext == ".xbm":
            bmpfile.seek(0)
            xbmdata = bmpfile.read()
            xbmdatasp = re.split("\n", xbmdata)
            xbmdata = ""
            del xbmdatasp[:3]
            for i in range(len(xbmdatasp)):
                xbmdatasp[i] = xbmdatasp[i].lstrip()
            for i in range(len(xbmdatasp)):
                xbmdata += xbmdatasp[i].rstrip() + " "
            xbmdata = xbmdata.rstrip()[:-3]
            xbmarray = re.split(", ", xbmdata)
            for i in range(len(canvasarray)):
                canvasarray[i] = int(xbmarray[i],16)
        bmpfile.close()
        filemenu.entryconfig(filemenu.index("Overwrite"), state = NORMAL)
        frame.title("OLED Drawing Tool [" + basefilename + "]")
        frame.focus()
        updatebmpdat()
        print "File Opened"
        saved = True
        fileexists = True
    
def saveFile():
    global filename
    global saved
    bmpfile = open(filename, "w")
    bmpfile.seek(0)
    bmpfile.truncate()
    for i in range(len(canvasarray)):
        if i==1023:
            bmpfile.write(hex(canvasarray[i]))
        else:
            bmpfile.write(hex(canvasarray[i]) + ", ")
    bmpfile.close()
    frame.title("OLED Drawing Tool [" + basefilename + "]")
    frame.focus()
    print "Save Complete"
    saved = True

def saveFileAs():
    global filename
    global fileexists
    global basefilename
    global saved
    saveasfilename = asksaveasfilename(defaultextension = ".obm", filetypes = [("OLED Bitmap Files", "*.obm")])
    if saveasfilename is not None and saveasfilename != '':
        filename = saveasfilename
        basefilename = os.path.basename(filename)
        bmpfile = open(filename, "w")
        bmpfile.seek(0)
        bmpfile.truncate()
        for i in range(len(canvasarray)):
            if i==1023:
                bmpfile.write(hex(canvasarray[i]))
            else:
                bmpfile.write(hex(canvasarray[i]) + ", ")
        bmpfile.close()
        filemenu.entryconfig(filemenu.index("Overwrite"), state = NORMAL)
        frame.title("OLED Drawing Tool [" + basefilename + "]")
        frame.focus()
        print "Save Complete"
        fileexists = True
        saved = True
    
        
def exitApp():
    frame.destroy()
    sys.exit()

def linmap(val, inlow, inhigh, outlow, outhigh):
    mapped = (val-inlow)*(outhigh-outlow)/(inhigh-inlow)
    if mapped > outhigh:
        mapped = outhigh
    if mapped < outlow:
        mapped = outlow
    return mapped
    

def updatebmpdat():
    draw_area.delete("pixel")
    for i in range(len(canvasarray)):
        for j in range(8):
            if ((canvasarray[i] >> (7-j)) & 0b00000001):
                #pixel is set
                x = linmap((i % 16)*8 + (7-j), 0, 127, 0, canvaswidth-pixwidth) 
                y = linmap((i >> 4), 0, 63, 0, canvasheight-pixwidth)
                draw_area.create_rectangle(x+pixwidth/2, y+pixwidth/2, x+pixwidth/2 + pixwidth, y+pixwidth/2 + pixwidth, fill="black", width = 0, outline="grey", tags="pixel")

def setpixel(x, y):
    if x >= oledwidth:
        x = oledwidth-1
    elif x < 0:
        x = 0
    if y >= oledheight:
        y = oledheight-1
    elif y < 0:
        y = 0
    address = (y << 4) | (x >> 3)
    canvasarray[address] |= 1 << (x % 8)

def clearpixel(x, y):
    if x >= oledwidth:
        x = oledwidth-1
    elif x < 0:
        x = 0
    if y >= oledheight:
        y = oledheight-1
    elif y < 0:
        y = 0
    address = (y << 4) | (x >> 3)
    canvasarray[address] &= ~(1 << (x % 8))

def shape(x, y, brush, radius, clear):
    if not clear:
        if radius == "small":
            setpixel(x, y)
        elif radius == "medium":
            if brush == "pixel":
                setpixel(x, y)
            elif brush == "square":
                setpixel(x, y)
                setpixel(x, y + 1)
                setpixel(x + 1, y)
                setpixel(x + 1, y + 1)
            elif brush == "star":
                setpixel(x, y)
                setpixel(x, y + 1)
                setpixel(x + 1, y)
                setpixel(x - 1, y)
                setpixel(x, y - 1)
        elif radius == "large":
            if brush == "pixel":
                setpixel(x, y)
            elif brush == "square":
                setpixel(x, y)
                setpixel(x, y + 1)
                setpixel(x + 1, y)
                setpixel(x + 1, y + 1)
                setpixel(x - 1 ,y)
                setpixel(x, y - 1)
                setpixel(x - 1, y - 1)
                setpixel(x - 1, y + 1)
                setpixel(x + 1, y - 1)
            elif brush == "star":
                setpixel(x, y)
                setpixel(x, y + 1)
                setpixel(x + 1, y)
                setpixel(x + 1, y + 1)
                setpixel(x - 1 ,y)
                setpixel(x, y - 1)
                setpixel(x - 1, y - 1)
                setpixel(x - 1, y + 1)
                setpixel(x + 1, y - 1)
                setpixel(x - 2, y - 1)
                setpixel(x - 2, y)
                setpixel(x - 2, y + 1)
                setpixel(x + 2, y - 1)
                setpixel(x + 2, y)
                setpixel(x + 2, y + 1)
                setpixel(x - 1, y - 2)
                setpixel(x, y - 2)
                setpixel(x + 1, y - 2)
                setpixel(x - 1, y + 2)
                setpixel(x, y + 2)
                setpixel(x + 1, y + 2)
    else:
        if radius == "small":
            clearpixel(x, y)
        elif radius == "medium":
            if brush == "pixel":
                clearpixel(x, y)
            elif brush == "square":
                clearpixel(x, y)
                clearpixel(x, y + 1)
                clearpixel(x + 1, y)
                clearpixel(x + 1, y + 1)
            elif brush == "star":
                clearpixel(x, y)
                clearpixel(x, y + 1)
                clearpixel(x + 1, y)
                clearpixel(x - 1, y)
                clearpixel(x, y - 1)
        elif radius == "large":
            if brush == "pixel":
                clearpixel(x, y)
            elif brush == "square":
                clearpixel(x, y)
                clearpixel(x, y + 1)
                clearpixel(x + 1, y)
                clearpixel(x + 1, y + 1)
                clearpixel(x - 1 ,y)
                clearpixel(x, y - 1)
                clearpixel(x - 1, y - 1)
                clearpixel(x - 1, y + 1)
                clearpixel(x + 1, y - 1)
            elif brush == "star":
                clearpixel(x, y)
                clearpixel(x, y + 1)
                clearpixel(x + 1, y)
                clearpixel(x + 1, y + 1)
                clearpixel(x - 1 ,y)
                clearpixel(x, y - 1)
                clearpixel(x - 1, y - 1)
                clearpixel(x - 1, y + 1)
                clearpixel(x + 1, y - 1)
                clearpixel(x - 2, y - 1)
                clearpixel(x - 2, y)
                clearpixel(x - 2, y + 1)
                clearpixel(x + 2, y - 1)
                clearpixel(x + 2, y)
                clearpixel(x + 2, y + 1)
                clearpixel(x - 1, y - 2)
                clearpixel(x, y - 2)
                clearpixel(x + 1, y - 2)
                clearpixel(x - 1, y + 2)
                clearpixel(x, y + 2)
                clearpixel(x + 1, y + 2)

def updatearray(event, color):
    x,y = click(event)
    if x == None:
        return
    if y == None:
        return
    xm = int(math.floor(linmap(x, 0, canvaswidth-pixwidth, 0, 127)))
    ym = int(math.floor(linmap(y, 0, canvasheight-pixwidth, 0, 63)))
    if color == "black":
        shape(xm, ym, brush, brushsize, False)
    if color == "white":
        shape(xm, ym, eraser, erasersize, True)
    updatebmpdat()
        
def drawblack(event):
    updatearray(event, "black")

def drawwhite(event):
    updatearray(event, "white")

def click(event):
    c = event.widget
    try:
        x = c.canvasx(event.x)
        y = c.canvasy(event.y)
        if x >= canvaswidth:
            return None, None
        elif x < 0:
            return None, None
        if y >= canvasheight:
            return None, None
        elif y < 0:
            return None, None
        return x,y
    except:
        return None, None

def starbrush():
    global brush
    brush = "star"
    mbrush.menu.entryconfig(mbrush.menu.index("Star"), state = DISABLED)
    mbrush.menu.entryconfig(mbrush.menu.index("Square"), state = NORMAL)
    mbrush.menu.entryconfig(mbrush.menu.index("Pixel"), state = NORMAL)

def squarebrush():
    global brush
    brush = "square"
    mbrush.menu.entryconfig(mbrush.menu.index("Star"), state = NORMAL)
    mbrush.menu.entryconfig(mbrush.menu.index("Square"), state = DISABLED)
    mbrush.menu.entryconfig(mbrush.menu.index("Pixel"), state = NORMAL)

def pixelbrush():
    global brush
    brush = "pixel"
    mbrush.menu.entryconfig(mbrush.menu.index("Star"), state = NORMAL)
    mbrush.menu.entryconfig(mbrush.menu.index("Square"), state = NORMAL)
    mbrush.menu.entryconfig(mbrush.menu.index("Pixel"), state = DISABLED)

def stareraser():
    global eraser
    eraser = "star"
    meraser.menu.entryconfig(meraser.menu.index("Star"), state = DISABLED)
    meraser.menu.entryconfig(meraser.menu.index("Square"), state = NORMAL)
    meraser.menu.entryconfig(meraser.menu.index("Pixel"), state = NORMAL)

def squareeraser():
    global eraser
    eraser = "square"
    meraser.menu.entryconfig(meraser.menu.index("Star"), state = NORMAL)
    meraser.menu.entryconfig(meraser.menu.index("Square"), state = DISABLED)
    meraser.menu.entryconfig(meraser.menu.index("Pixel"), state = NORMAL)

def pixeleraser():
    global eraser
    eraser = "pixel"
    meraser.menu.entryconfig(meraser.menu.index("Star"), state = NORMAL)
    meraser.menu.entryconfig(meraser.menu.index("Square"), state = NORMAL)
    meraser.menu.entryconfig(meraser.menu.index("Pixel"), state = DISABLED)

def brushsmall():
    global brushsize
    brushsize = "small"
    mbrushsize.menu.entryconfig(mbrushsize.menu.index("Small"), state = DISABLED)
    mbrushsize.menu.entryconfig(mbrushsize.menu.index("Medium"), state = NORMAL)
    mbrushsize.menu.entryconfig(mbrushsize.menu.index("Large"), state = NORMAL)

def brushmed():
    global brushsize
    brushsize = "medium"
    mbrushsize.menu.entryconfig(mbrushsize.menu.index("Small"), state = NORMAL)
    mbrushsize.menu.entryconfig(mbrushsize.menu.index("Medium"), state = DISABLED)
    mbrushsize.menu.entryconfig(mbrushsize.menu.index("Large"), state = NORMAL)

def brushlrg():
    global brushsize
    brushsize = "large"
    mbrushsize.menu.entryconfig(mbrushsize.menu.index("Small"), state = NORMAL)
    mbrushsize.menu.entryconfig(mbrushsize.menu.index("Medium"), state = NORMAL)
    mbrushsize.menu.entryconfig(mbrushsize.menu.index("Large"), state = DISABLED)

def erasersmall():
    global erasersize
    erasersize = "small"
    merasersize.menu.entryconfig(merasersize.menu.index("Small"), state = DISABLED)
    merasersize.menu.entryconfig(merasersize.menu.index("Medium"), state = NORMAL)
    merasersize.menu.entryconfig(merasersize.menu.index("Large"), state = NORMAL)

def erasermed():
    global erasersize
    erasersize = "medium"
    merasersize.menu.entryconfig(merasersize.menu.index("Small"), state = NORMAL)
    merasersize.menu.entryconfig(merasersize.menu.index("Medium"), state = DISABLED)
    merasersize.menu.entryconfig(merasersize.menu.index("Large"), state = NORMAL)

def eraserlrg():
    global erasersize
    erasersize = "large"
    merasersize.menu.entryconfig(merasersize.menu.index("Small"), state = NORMAL)
    merasersize.menu.entryconfig(merasersize.menu.index("Medium"), state = NORMAL)
    merasersize.menu.entryconfig(merasersize.menu.index("Large"), state = DISABLED)

def updatetext(event):
    arraystr = ""
    for i in range(len(canvasarray)):
        arraystr += "0x" + hex(canvasarray[i])[2:].zfill(2) + ", "
    vhdlarray = xbmtovhdl(arraystr[:-2])
    text_area.delete("1.0", "end-1c")
    text_area.insert("1.0", vhdlarray)

def copy():
    frame.clipboard_clear()
    frame.clipboard_append(text_area.get("1.0", "end-1c"))

Tk().withdraw()
frame = Toplevel(bg="#FFFFFF")
headerfont = Font(frame, family = "Calibri", size = 12, weight = "bold")
imgheader = Canvas(frame, width = 100, height = 20, bg = "#FFFFFF")
imgheader.grid(row=0,column=0,sticky=W+E)
imgheader.create_text(10, 3, text = "Image", anchor = NW, font = headerfont)
txtheader = Canvas(frame, width = 100, height = 20, bg = "#FFFFFF")
txtheader.grid(row=0,column=5,columnspan=2,sticky=W+E)
txtheader.create_text(10, 3, text = "Bitmap Data", anchor = NW, font = headerfont)

draw_area = Canvas(frame, width = canvaswidth + pixwidth, height = canvasheight + pixwidth)#, bd = 0, relief = SUNKEN)
draw_area.grid(row=1,column=0,columnspan=5,rowspan=2)
draw_area.bind("<ButtonPress-1>", drawblack)
draw_area.bind("<B1-Motion>", drawblack)
draw_area.bind("<ButtonPress-3>", drawwhite)
draw_area.bind("<B3-Motion>", drawwhite)
draw_area.bind("<ButtonRelease-1>", updatetext)
draw_area.bind("<ButtonRelease-3>", updatetext)

yscrollbar = Scrollbar(frame)
yscrollbar.grid(row=1,column=7,rowspan=2,sticky=N+S)
xscrollbar = Scrollbar(frame, orient = HORIZONTAL)
xscrollbar.grid(row=2,column=5,columnspan=2,sticky=W+E)
text_area = Text(frame, height = 19, width = 48, padx = 3, pady = 1, yscrollcommand = yscrollbar.set, xscrollcommand = xscrollbar.set, wrap = NONE, bd = 1, relief = SUNKEN)
text_area.grid(row=1,column=5,columnspan=2)
xscrollbar.config(command=text_area.xview)
yscrollbar.config(command=text_area.yview)

frame.title("OLED Drawing Tool [" + basefilename + "]")
menubar = Menu(frame)
filemenu = Menu(menubar, tearoff=0)
filemenu.add_command(label="Import", command=openFile)
filemenu.add_command(label="Overwrite", command=saveFile, state = DISABLED)
filemenu.add_command(label="Export to...", command=saveFileAs)
filemenu.add_command(label="Exit", command=exitApp)
menubar.add_cascade(label="File", menu=filemenu)
frame.config(menu=menubar)

mbrush = Menubutton(frame, text="Brush", relief=RAISED)
mbrush.menu = Menu(mbrush, tearoff = 0)
mbrush["menu"] = mbrush.menu
mbrush.menu.add_command(label="Star", command=starbrush, state = DISABLED)
mbrush.menu.add_command(label="Square", command=squarebrush)
mbrush.menu.add_command(label="Pixel", command=pixelbrush)
mbrush.grid(row=0,column=1,sticky=W+E)

meraser = Menubutton(frame, text="Eraser", relief=RAISED)
meraser.menu = Menu(meraser, tearoff = 0)
meraser["menu"] = meraser.menu
meraser.menu.add_command(label="Star", command=stareraser)
meraser.menu.add_command(label="Square", command=squareeraser, state = DISABLED)
meraser.menu.add_command(label="Pixel", command=pixeleraser)
meraser.grid(row=0,column=2,sticky=W+E)

mbrushsize = Menubutton(frame, text="Brush Size", relief=RAISED)
mbrushsize.menu = Menu(mbrushsize, tearoff = 0)
mbrushsize["menu"] = mbrushsize.menu
mbrushsize.menu.add_command(label="Small", command=brushsmall, state = DISABLED)
mbrushsize.menu.add_command(label="Medium", command=brushmed)
mbrushsize.menu.add_command(label="Large", command=brushlrg)
mbrushsize.grid(row=0,column=3,sticky=W+E)

merasersize = Menubutton(frame, text="Eraser Size", relief=RAISED)
merasersize.menu = Menu(merasersize, tearoff = 0)
merasersize["menu"] = merasersize.menu
merasersize.menu.add_command(label="Small", command=erasersmall, state = DISABLED)
merasersize.menu.add_command(label="Medium", command=erasermed)
merasersize.menu.add_command(label="Large", command=eraserlrg)
merasersize.grid(row=0,column=4,sticky=W+E)

copytoclipboard = Button(frame, text="Copy Bitmap Data", relief=RAISED, command=copy)
copytoclipboard.grid(row=0,column=6)

#frame.resizable(0,0)
frame.mainloop()
