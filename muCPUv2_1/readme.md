#muCPU version 2.1

In this version, several new functions are added, and the memory received an (almost complete) overhaul. See my <a href="https://hackaday.io/project/10576-mucpu-an-8-bit-mcu/log/37676-lots-of-updates">hackaday.io post</a> and <a href="https://docs.google.com/spreadsheets/d/1JhbmEXO67L9nPBK7QPC1icmQgoSIbWz5b0xLPl8THKE/">google doc</a> for more info.

Hierarchy (component names aren't exact):

    core - core.vhd
      fetch_unit - instruction_fetch.vhd
        pcmux - mux.vhd
        pcinc - adder.vhd
        pcreg - register.vhd
        ishift - instructionshifter.vhd
        reg_we - or_gate_3.vhd
        ishift_we - or_gate_2.vhd
      IF_EX_block - register.vhd
      execute_unit - execute.vhd
        decoder - instructiondecode.vhd
        registerfile - register_file.vhd
        alu - alu.vhd
        branch_unit - branch_unit.vhd
          isbranch - op_isbranch.vhd
          and_gate - and_gate_2.vhd
          pc_mux - mux.vhd
          imm_add - adder.vhd
          inc2_add - adder.vhd
        opbmux - mux.vhd
        wbmux - mux.vhd
      main_memory - memory.vhd
        ram - ram4kB.vhd
        rom - rom4kB.vhd
        io - iobank.vhd
        addrmux - mux.vhd
      control_unit - ringct.vhd
