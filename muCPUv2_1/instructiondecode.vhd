----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Reed Foster
-- 
-- Create Date:    21:52:42 04/05/2016 
-- Design Name: 
-- Module Name:    instructiondecode - dataflow 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- Takes 16-bit instruction in and decodes based on the upper 2 bits (opcode)
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity instructiondecode is
   port (instruction : in  std_logic_vector (15 downto 0);
         imm         : out std_logic_vector (7 downto 0);
         rs          : out std_logic_vector (2 downto 0);
         rt          : out std_logic_vector (2 downto 0);
         rd          : out std_logic_vector (2 downto 0);
         alu_opcode  : out std_logic_vector (5 downto 0);
         ctl         : out std_logic_vector (3 downto 0);
         is_branch   : out std_logic);
end instructiondecode;

architecture dataflow of instructiondecode is
   signal is_rtype, is_mem, is_load, is_store, is_branch_tmp, is_ldi, wb_en : std_logic;
   signal opcode_tmp : std_logic_vector (1 downto 0);
   signal alu_tmp    : std_logic_vector (5 downto 0);
   signal rt_tmp     : std_logic_vector (2 downto 0);
   signal func       : std_logic_vector (4 downto 0);
begin
   --decode
   with opcode_tmp select
      is_rtype <= '1' when "00",
                  '0' when others;
   
   with opcode_tmp select
      is_load   <= '1' when "10",
                   '0' when others;
   
   with opcode_tmp select
      is_store  <= '1' when "11",
                   '0' when others;                
   
   is_ldi <= '1' when (opcode_tmp = "01" and rt_tmp = "110") else '0';
   is_branch_tmp <= '1' when (opcode_tmp = "01" and rt_tmp /= "110" and rt_tmp /= "111") else '0';
   
   is_branch <= is_branch_tmp;
   
   rt_tmp <= instruction (10 downto 8);

   alu_tmp <= "000010" when (is_mem = '1') else
              "100000" when (is_branch_tmp = '1' and rt_tmp = "000") else
              "100001" when (is_branch_tmp = '1' and rt_tmp = "001") else
              "100010" when (is_branch_tmp = '1' and rt_tmp = "010") else
              "100011" when (is_branch_tmp = '1' and rt_tmp = "011") else
              "100100" when (is_branch_tmp = '1' and rt_tmp = "100") else
              "100101" when (is_branch_tmp = '1' and rt_tmp = "101") else
              "000010" when (is_ldi = '1') else
              '0' & func;
   
   --signal logic
   func       <= instruction (4 downto 0);
   opcode_tmp <= instruction (15 downto 14);
   is_mem     <= is_load or is_store;
   wb_en      <= not (is_branch_tmp or is_store);
   
   --outputs assignment
   imm <= instruction (7 downto 0);
   rs  <= "000" when (is_ldi = '1') else instruction (13 downto 11);
   rt  <= rt_tmp;
   rd  <= instruction (7 downto 5) when (is_rtype = '1') else
          instruction (10 downto 8) when (is_load = '1') else
          instruction (13 downto 11) when (is_ldi = '1') else
          (others => '0');
   alu_opcode <= alu_tmp;
   ctl        <= is_ldi & is_store & is_load & wb_en;

end dataflow;
