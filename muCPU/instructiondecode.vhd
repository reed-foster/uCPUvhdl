----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:52:42 04/05/2016 
-- Design Name: 
-- Module Name:    instructiondecode - dataflow 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity instructiondecode is
	port (instruction : in  std_logic_vector (15 downto 0);
			imm 			: out  std_logic_vector (7 downto 0);
			rs 			: out  std_logic_vector (1 downto 0);
			rt 			: out  std_logic_vector (1 downto 0);
			rd 			: out  std_logic_vector (1 downto 0);
			alu_opcode 	: out  std_logic_vector (2 downto 0);
			ctl 			: out  std_logic_vector (2 downto 0));
end instructiondecode;

architecture dataflow of instructiondecode is
	signal is_itype, is_mem, is_load, is_store, is_branch, wb_en : std_logic;
	signal opcode_tmp : std_logic_vector (3 downto 0);
	signal alu_tmp		: std_logic_vector (2 downto 0);
	signal rt_tmp		: std_logic_vector (1 downto 0);
begin
	--decode
	with opcode_tmp select
		is_load   <= '1' when "0111",
						 '0' when others;
	
	with opcode_tmp select
		is_store  <= '1' when "1000",
						 '0' when others;					 
	
	with opcode_tmp select
		is_branch <= '1' when "0101",
						 '1' when "0110",
						 '0' when others;
	
	with is_itype select
		rt_tmp <= instruction (7 downto 6)   when '0',
					 instruction (11 downto 10) when '1',
					 (others => '0') 				 when others;
	
	with is_mem select
		alu_tmp <= "001"     				  when '1',
					  opcode_tmp (2 downto 0) when others;
	
	--signal logic
	opcode_tmp	<= instruction (15 downto 12);
	is_mem		<= is_load or is_store;
	is_itype 	<= is_mem or is_branch;
	wb_en			<= not (is_branch or is_store);
	
	--outputs assignment
	imm			<= instruction (7 downto 0);
	rs				<= instruction (9 downto 8);
	rt 			<= rt_tmp;
	rd				<= instruction (11 downto 10);
	alu_opcode	<= alu_tmp;
	ctl			<= is_store & is_load & wb_en;

end dataflow;

