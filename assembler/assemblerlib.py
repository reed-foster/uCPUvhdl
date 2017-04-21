import re

def asmtoint(asm):
    if ("//" in asm):
        asm = asm[:asm.find("//")]
    asm_split = re.split(" |, |\(|\)", asm)
    args = []
    for i in range (len(asm_split)):
        if (asm_split[i] != ""):
            args.append(asm_split[i])
    opcode = 0
    func = 0
    rd = 0
    rs = 0
    rt = 0
    imm = 0
    if (args[0] == "nop"):
        opcode = 0
        func = 0
        rd = 0
        rs = 0
        rt = 0
    elif (args[0] == "sll"):
        if (len(args) != 4):
            return 0,0,0,0,0,0
        opcode = 0
        func = 0
        rd = int(args[1][1:])
        rs = int(args[2][1:])
        rt = int(args[3][1:])
    elif (args[0] == "srl"):
        if (len(args) != 4):
            return 0,0,0,0,0,0
        opcode = 0
        func = 1
        rd = int(args[1][1:])
        rs = int(args[2][1:])
        rt = int(args[3][1:])
    elif (args[0] == "add"):
        if (len(args) != 4):
            return 0,0,0,0,0,0
        opcode = 0
        func = 2
        rd = int(args[1][1:])
        rs = int(args[2][1:])
        rt = int(args[3][1:])
    elif (args[0] == "sub"):
        if (len(args) != 4):
            return 0,0,0,0,0,0
        opcode = 0
        func = 3
        rd = int(args[1][1:])
        rs = int(args[2][1:])
        rt = int(args[3][1:])
    elif (args[0] == "nand"):
        if (len(args) != 4):
            return 0,0,0,0,0,0
        opcode = 0
        func = 4
        rd = int(args[1][1:])
        rs = int(args[2][1:])
        rt = int(args[3][1:])
    elif (args[0] == "nor"):
        if (len(args) != 4):
            return 0,0,0,0,0,0
        opcode = 0
        func = 5
        rd = int(args[1][1:])
        rs = int(args[2][1:])
        rt = int(args[3][1:])
    elif (args[0] == "and"):
        if (len(args) != 4):
            return 0,0,0,0,0,0
        opcode = 0
        func = 6
        rd = int(args[1][1:])
        rs = int(args[2][1:])
        rt = int(args[3][1:])
    elif (args[0] == "or"):
        if (len(args) != 4):
            return 0,0,0,0,0,0
        opcode = 0
        func = 7
        rd = int(args[1][1:])
        rs = int(args[2][1:])
        rt = int(args[3][1:])
    elif (args[0] == "bez"):
        if (len(args) != 3):
            return 0,0,0,0,0,0
        opcode = 1
        rt = 0
        rs = int(args[1][1:])
        imm = int(args[2])
    elif (args[0] == "bnez"):
        if (len(args) != 3):
            return 0,0,0,0,0,0
        opcode = 1
        rt = 1
        rs = int(args[1][1:])
        imm = int(args[2])
    elif (args[0] == "bgez"):
        if (len(args) != 3):
            return 0,0,0,0,0,0
        opcode = 1
        rt = 2
        rs = int(args[1][1:])
        imm = int(args[2])
    elif (args[0] == "blez"):
        if (len(args) != 3):
            return 0,0,0,0,0,0
        opcode = 1
        rt = 3
        rs = int(args[1][1:])
        imm = int(args[2])
    elif (args[0] == "bgz"):
        if (len(args) != 3):
            return 0,0,0,0,0,0
        opcode = 1
        rt = 4
        rs = int(args[1][1:])
        imm = int(args[2])
    elif (args[0] == "blz"):
        if (len(args) != 3):
            return 0
        opcode = 1
        rt = 5
        rs = int(args[1][1:])
        imm = int(args[2])
    elif (args[0] == "li"):
        if (len(args) != 3):
            return 0
        opcode = 1
        rt = 6
        rs = int(args[1][1:])
        imm = int(args[2])
    elif (args[0] == "lb"):
        if (args[-1] == ''):
            args = args[0:-1]
        if (len(args) != 3 and len(args) != 4):
            return 0,0,0,0,0,0
        opcode = 2
        rt = int(args[1][1:])
        if (len(args) == 3):
            imm = 0
            rs = int(args[2][1:])
        else:
            imm = int(args[2])
            rs = int(args[3][1:])
    elif (args[0] == "sb"):
        if (args[-1] == ''):
            args = args[0:-1]
        if (len(args) != 3 and len(args) != 4):
            return 0,0,0,0,0,0
        opcode = 3
        rt = int(args[1][1:])
        if (len(args) == 3):
            imm = 0
            rs = int(args[2][1:])
        else:
            imm = int(args[2])
            rs = int(args[3][1:])
    else:
        return 0,0,0,0,0,0
    return opcode, rs, rt, rd, func, imm

def inttohex(opcode, rs, rt, rd, func, imm):
    if (opcode == 0):
        opstr = format(opcode, '02b')
        rsstr = format(rs, '03b')
        rtstr = format(rt, '03b')
        rdstr = format(rd, '03b')
        fnstr = format(func, '05b')
        #print opstr, rsstr, rtstr, rdstr, fnstr
        instruction = opstr + rsstr + rtstr + rdstr + fnstr
    else :
        opstr = format(opcode, '02b')
        rtstr = format(rt, '03b')
        rsstr = format(rs, '03b')
        if (imm < 0):
            imm2s = ((-imm) ^ 255) + 1
            immstr = format(imm2s, '08b')
        else :
            immstr = format(imm, '08b')
        #print opstr, rtstr, rsstr, immstr
        instruction = opstr + rsstr + rtstr + immstr
    return format(int(instruction, 2), '04x')

def decode(asm):
    opcode, rs, rt, rd, func, imm = asmtoint(asm)
    instruction = inttohex(opcode, rs, rt, rd, func, imm)
    return instruction
