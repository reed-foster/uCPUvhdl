----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:17:03 03/31/2016 
-- Design Name: 
-- Module Name:    ram8x256 - Behavioral 
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

entity ram128x8 is
	port (addr		: in  std_logic_vector (6 downto 0);
			clk		: in  std_logic;
			store		: in  std_logic;
			sel		: in	std_logic;
			data_in	: in  std_logic_vector (7 downto 0);
			data_out	: out std_logic_vector (7 downto 0);
			out_ctl	: out std_logic);
end ram128x8;

architecture behavioral of ram128x8 is
	type arry_type is array (0 to 127) of std_logic_vector (7 downto 0);
	signal mem_contents : arry_type := (others => "00000000");
begin

	write_data: process(clk)
	begin
		if (rising_edge(clk)) then
			if (store = '1' and sel = '1') then
				mem_contents(to_integer(unsigned(addr))) <= data_in;
			end if;
		end if;
	end process;
	
	data_out <= mem_contents(to_integer(unsigned(addr)));
	out_ctl <= '1' when (store /= '1' and sel = '1') else '0';

end behavioral;

