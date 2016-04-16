----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:48:10 03/28/2016 
-- Design Name: 
-- Module Name:    alu - Behavioral 
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
use ieee.numeric_std.all;

entity alu is
	port (A  : in std_logic_vector (7 downto 0);
			B  : in std_logic_vector (7 downto 0);
			op : in std_logic_vector (2 downto 0);
			R  : out std_logic_vector(7 downto 0));
end alu;

architecture dataflow of alu is
	signal bshort : std_logic_vector(2 downto 0) := "000";
	
	signal shifted, addval, subval, beq_res, bne_res : std_logic_vector(7 downto 0);

begin

	bshort <= B(2 downto 0);
	
	--sll function
	with bshort select
		shifted <= A (6 downto 0) & "0" when		"001",
					  A (5 downto 0) & "00" when		"010",
					  A (4 downto 0) & "000" when		"011",
					  A (3 downto 0) & "0000" when	"100",
					  A (2 downto 0) & "00000" when	"101",
					  A (1 downto 0) & "000000" when "110",
					  A (0) & "0000000" when			"111",
					  A when									others;
					  
	--Arithmetic
	addval <= std_logic_vector(signed(A) + signed(B));
	subval <= std_logic_vector(signed(A) - signed(B));
	
	--Testing function
	with subval select
		beq_res <= "11111111" when "00000000",
					  "00000000" when others;
	with subval select
		bne_res <= "00000000" when "00000000",
					  "11111111" when others;
	
	--Output generation
	with op select
		R <= shifted when			"000",
			  addval when			"001",
			  subval when			"010",
			  not (A and B) when "011",
			  not (A or B) when 	"100",
			  beq_res when			"101",
			  bne_res when			"110",
			  "00000000" when		others; --also useful for debugging
end dataflow;



