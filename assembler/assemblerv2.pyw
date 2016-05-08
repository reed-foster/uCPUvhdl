from Tkinter import *
from tkFileDialog import *
from tkFont import *
import os.path
import sys
import re

from assemblerlib import *

basefilename = "Untitled"
filename = ""
fileexists = False

saved = True

canvaswidthdefault = 20
canvaswidth = canvaswidthdefault
currentlength = 1

mnemonicstring = "sll|srl|add|sub|nand|nor|and|or|bez|bnez|bgez|blez|bgz|blz|li|lb|sb"
registerstring = "r0|r1|r2|r3|r4|r5|r6|r7"

def openFile():
    global filename
    global basefilename
    global saved
    openfilename = askopenfilename()
    if openfilename is not None:
        filename = openfilename
        basefilename = os.path.basename(filename)
        asmfile = open(filename, "r")
        asmfile.seek(0)
        asmdata = asmfile.read()
        textArea.delete("1.0", "end - 1c")
        textArea.insert("1.0", asmdata)
        asmfile.close()
        filemenu.entryconfig(filemenu.index("Save"), state = NORMAL)
        frame.title("muCPU Assembler [" + basefilename + "]")
        frame.focus()
        initonOpen()
        print "File Opened"
        saved = True
    
def saveFile():
    global filename
    global saved
    asmdata = textArea.get("1.0", "end - 1c")
    asmfile = open(filename, "w")
    asmfile.seek(0)
    asmfile.truncate()
    asmfile.write(asmdata)
    asmfile.close()
    print "Save Complete"
    saved = True
    frame.title("muCPU Assembler [" + basefilename + "]")

def saveFileAs():
    global filename
    global fileexists
    global basefilename
    global saved
    saveasfilename = asksaveasfilename()
    if saveasfilename is not None:
        filename = saveasfilename
        basefilename = os.path.basename(filename)
        fileexists = True
        asmdata = textArea.get("1.0", "end - 1c")
        asmfile = open(filename, "w")
        asmfile.seek(0)
        asmfile.truncate()
        asmfile.write(asmdata)
        asmfile.close()
        filemenu.entryconfig(filemenu.index("Save"), state = NORMAL)
        frame.title("muCPU Assembler [" + basefilename + "]")
        frame.focus()
        print "Save Complete"
        saved = True
    
        
def exitApp():
    frame.destroy()
    sys.exit()
    
def compileASM():
    global filename
    cpu_out = ""
    asm_in = textArea.get("1.0", END)
    asmlines = re.split("\n", asm_in)
    for i in range (len(asmlines)):
        if (asmlines[i] != ""):
            cpu_out += str(i) + " => x\"" + decode(asmlines[i]) + "\",\n"
    name, ext = os.path.splitext(filename)
    hexfilename = name + ".hex"
    hexfile = open(hexfilename, "w")
    hexfile.seek(0)
    hexfile.truncate()
    hexfile.write(cpu_out)
    hexfile.close()
    print ("Compiled hex code to " + hexfilename)

def updateLinesEvent(event):
    drawLinenums()

def updateHighlightEvent(event):
    highlightSyntax((re.split("\.", textArea.index(INSERT))[0] + ".0"), INSERT)

def initonOpen():
    highlightSyntax("1.0", END)
    drawLinenums()


def drawLinenums():
    global canvaswidth
    global canvaswidthdefault
    linenumbers.delete("all")
    i = textArea.index("@0,0")
    while True:
        dline = textArea.dlineinfo(i)
        if dline is None: break
        y = dline[1]
        linenum = str(i).split(".")[0]
        linenumbers.create_text(canvaswidth, y, anchor=NE,text=linenum)
        i = textArea.index("%s+1line" % i)
        linenumbers.config(width = canvaswidth)
        

def highlightSyntax(start, end):
    global mnemonicstring
    global registerstring
    mnemoniclen = StringVar()
    registerlen = StringVar()
    numberlen = StringVar()
    commentlen = StringVar()
    pos = start
    while True:
        pos = textArea.search(mnemonicstring, pos, end, regexp = True, count = mnemoniclen)
        #print pos
        if not pos: break
        textArea.tag_add("mnemonic", pos, pos + " + " + str(mnemoniclen.get()) + "c")
        posarry = re.split("\.", pos)
        posarry[1] = str(int(posarry[1]) + 1)
        pos = posarry[0] + "." + posarry[1] + ("0" * (len(posarry[1]) - 2))
    pos = start
    while True:
        pos = textArea.search("-?\\d", pos, end, regexp = True, count = numberlen)
        #print pos
        if not pos: break
        textArea.tag_add("number", pos, pos + " + " + str(numberlen.get()) + "c")
        posarry = re.split("\.", pos)
        posarry[1] = str(int(posarry[1]) + 1)
        pos = posarry[0] + "." + posarry[1] + ("0" * (len(posarry[1]) - 2))
    pos = start
    while True:
        pos = textArea.search(registerstring, pos, end, regexp = True, count = registerlen)
        #print pos
        if not pos: break
        textArea.tag_add("register", pos, pos + " + " + str(registerlen.get()) + "c")
        posarry = re.split("\.", pos)
        posarry[1] = str(int(posarry[1]) + 1)
        pos = posarry[0] + "." + posarry[1] + ("0" * (len(posarry[1]) - 2))
    pos = start
    while True:
        pos = textArea.search("//", pos, end, regexp = False, count = commentlen)
        #print pos
        if not pos: break
        textArea.tag_add("comment", pos, re.split("\.", pos)[0] + ".end")
        posarry = re.split("\.", pos)
        posarry[1] = str(int(posarry[1]) + 1)
        pos = posarry[0] + "." + posarry[1] + ("0" * (len(posarry[1]) - 2))
    

def keypressed(event):
    global saved
    saved = False
    frame.title("muCPU Assembler *[" + basefilename + "]*")
    updateHighlightEvent(event)
    updateLinesEvent(event)
    scrollbar.set

def updateall(event):
    highlightSyntax("1.0", END)
    updateLinesEvent(event)
    scrollbar.set

def saveevent(event):
    saveFile()

Tk().withdraw()
frame = Toplevel(bg="#D8D8D8")

frame.bind("<Button-1>", updateall)
frame.bind("<MouseWheel>", updateall)
frame.bind("<B1-Motion>", updateall)
frame.bind("<ButtonRelease-1>", updateall)
frame.bind("<Key>", keypressed)
frame.bind("<Control-s>", saveevent)

scrollbar = Scrollbar(frame)
scrollbar.pack(side = RIGHT, fill = Y)
frame.title("muCPU Assembler [" + basefilename + "]")
textArea = Text(frame, height = 30, width = 100, padx = 3, pady = 3, yscrollcommand = scrollbar.set, selectbackground="#C5C5C5")
textArea.pack(side=RIGHT)
scrollbar.config(command=textArea.yview)

mnemonicfont = Font(frame, family = "Courier", size = 10, weight = "bold")
textArea.tag_config("mnemonic", foreground = "blue", font = mnemonicfont)
numberfont = Font(frame, family = "Courier", size = 10)
textArea.tag_config("number", foreground = "#df9200", font = numberfont)
registerfont = Font(frame, family = "Courier", size = 10)#, slant = "italic")
textArea.tag_config("register", foreground = "red", font = registerfont)
commentfont = Font(frame, family = "Courier", size = 10)#, slant = "italic")
textArea.tag_config("comment", foreground = "#3FA023", font = commentfont)

linenumbers = Canvas(frame, width = canvaswidthdefault, height = 487, bg = "#D8D8D8", highlightbackground = "#D8D8D8")
linenumbers.pack()

menubar = Menu(frame)
filemenu = Menu(menubar, tearoff=0)
filemenu.add_command(label="Open", command=openFile)
filemenu.add_command(label="Save", command=saveFile, state = DISABLED)
filemenu.add_command(label="Save as...", command=saveFileAs)
filemenu.add_command(label="Exit", command=exitApp)
menubar.add_cascade(label="File", menu=filemenu)
runmenu = Menu(menubar, tearoff=0)
runmenu.add_command(label="Compile", command=compileASM)
menubar.add_cascade(label="Run", menu=runmenu)
frame.config(menu=menubar)

initonOpen()

frame.resizable(0,0)
frame.mainloop()

#Current code
"""
lw r4, 176(r0)
lw r3, 177(r0)
sub r2, r4, r1
bez r2, 8
sw r1, 252(r0)
bez r0, -8
add r1, r1, r3
sll r0, r0, r0
bez r0, -2
"""
