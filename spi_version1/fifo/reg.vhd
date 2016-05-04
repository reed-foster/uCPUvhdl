----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:24:22 05/01/2016 
-- Design Name: 
-- Module Name:    reg - behavioral 
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

entity reg is
	port (d	: in	std_logic_vector (7 downto 0);
			q	: out	std_logic_vector (7 downto 0);
			en	: in 	std_logic;
			clk: in	std_logic;
			clr: in	std_logic);
end reg;

architecture behavioral of reg is
	signal q_temp : std_logic_vector (7 downto 0) := "00000000";
begin
	
	process(clr, clk, en)
	begin
		if (clr = '1') then
			q_temp <= "00000000";
		elsif (rising_edge(clk) and en = '1') then
			q_temp <= d;
		end if;
	end process;
	
	q <= q_temp;
	
end behavioral;

