----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:54:46 05/01/2016 
-- Design Name: 
-- Module Name:    counter - behavioral 
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

entity counter is
	port (count	: in	std_logic;
			clk	: in	std_logic;
			reset	: in	std_logic;
			value	: out	std_logic_vector (7 downto 0);
			ovr	: out	std_logic);
end counter;

architecture behavioral of counter is
	signal cntval : integer range 0 to 255 := 0;
	signal toggle_val, ovr_tmp : std_logic := '0';
	signal temp_value : std_logic_vector (7 downto 0) := "00000000";
begin

	cnt_proc : process(reset, clk, count)
	begin
		if (reset = '1') then
			cntval <= 0;
		elsif (rising_edge(clk) and count = '1') then
			if (cntval >= 255) then
				cntval <= 0;
			else
				cntval <= cntval + 1;
			end if;
		end if;
	end process;
	
	toggle_ovr : process(toggle_val)
	begin
		if rising_edge(toggle_val) then
			ovr_tmp <= not ovr_tmp;
		end if;
	end process;
	
	ovr <= ovr_tmp;
	temp_value <= std_logic_vector(to_unsigned(cntval, 8));
	toggle_val <= '1' when (temp_value = "11111111") else '0';
	value <= temp_value;
end behavioral;

