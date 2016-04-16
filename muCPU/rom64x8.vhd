----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:55:39 04/07/2016 
-- Design Name: 
-- Module Name:    rom64x8 - behavioral 
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

entity rom64x8 is
	port (addr 		: in  std_logic_vector (5 downto 0);
			sel		: in	std_logic;
			data_out : out std_logic_vector (7 downto 0);
			out_ctl	: out std_logic
	);
end rom64x8;

architecture behavioral of rom64x8 is
	type arry_type is array (0 to 63) of std_logic_vector (7 downto 0);
	constant program : arry_type := ( --fill with desired program
		--current program : loads two values (count to and increment) and outputs current count value to io port
		--r3 <= 0x42
		--r2 <= 0x01
		--beq r1, r3, 0x08
		--ram(0+idx) <= r1
		--beq r0, r0, 0xfa
		--r1 <= r1 + r2
		--no-op
		--beq r0, r0, 0xfe
		0	=>	x"7c", --load from rom 
		1	=> x"a0",
		2	=>	x"78", --load from rom
		3	=> x"a1",
		4	=> x"57", --break loop if count value is reached
		5	=> x"08",
		6	=> x"84", --store data in io
		7	=> x"fc",
		8	=> x"50", --infinite loop
		9	=> x"fa",
		10	=> x"15", --increment r1 by increment value (r2)
		11 => x"80",
		12	=> x"00", --no op
		13	=> x"00",
		14	=> x"50", --infinite backwards loop (halt)
		15	=> x"fe",
		--data
		32			=> x"42", --value to count to
		33			=> x"01", --value to increment by
		others	=> "00000000"
	);
	--signal mem_contents : arry_type := program;
begin

	data_out <= program(to_integer(unsigned(addr)));
	out_ctl <= '1' when (sel = '1') else '0';

end behavioral;

