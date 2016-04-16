----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Reed Foster
-- 
-- Create Date:    21:55:39 04/07/2016 
-- Design Name: 
-- Module Name:    rom64x8 - behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- 64B read only memory
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom64x8 is
	port (addr 		: in  std_logic_vector (5 downto 0);
			sel		: in	std_logic;
			data_out : out std_logic_vector (7 downto 0);
			out_ctl	: out std_logic
	);
end rom64x8;

architecture behavioral of rom64x8 is
	type array_type is array (0 to 63) of std_logic_vector (7 downto 0);
	type prog_type is array (0 to 23) of std_logic_vector (15 downto 0);
	type data_type is array (0 to 15) of std_logic_vector (7 downto 0);
	constant prog_instr : prog_type := (
--		fill with desired program (max 24 instructions)
----------------------------------------------------------------------------------------------------------
--		current program : loads two values (count to and increment) and outputs current count value to io port
--		lw r4, 176(r0)
--		lw r3, 177(r0)
--		sub r2, r4, r1
--		bez r2, 8
--		sw r1, 252(r0)
--		bez r0, -8
--		add r1, r1, r3
--		sll r0, r0, r0
--		bez r0, -2
		0 => x"84b0",
		1 => x"83b1",
		2 => x"2142",
		3 => x"5008",
		4 => x"c1fc",
		5 => x"40f8",
		6 => x"0b21",
		7 => x"0000",
		8 => x"40fe",
		others => x"0000"
	);
	constant prog_data : data_type := (
		--fill with data to be used in program (addresses start at 0xB0 (176d))
		0			=> x"42", --value to count to
		1			=> x"01", --value to increment by
		others	=> x"00"
	);
	signal program : array_type;
	signal const0 : std_logic := '0';
begin
	
	process(const0)
	begin
		for i in 0 to 23 loop
			program(i*2) <= prog_instr(i)(15 downto 8);
			program(i*2 + 1) <= prog_instr(i)(7 downto 0);
		end loop;
		for i in 0 to 15 loop
			program(i + 48) <= prog_data(i);
		end loop;
	end process;
	data_out <= program(to_integer(unsigned(addr)));
	out_ctl <= '1' when (sel = '1') else '0';

end behavioral;

