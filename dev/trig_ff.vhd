----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:14:11 05/02/2016 
-- Design Name: 
-- Module Name:    trig_ff - behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- D flip-flop that resets every rising edge of the clock (generates a pulse)
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity trig_ff is
	port (trig_in	: in	std_logic;
			trig_out	: out	std_logic;
			clk		: in	std_logic);
end trig_ff;

architecture behavioral of trig_ff is
   signal trig_out_tmp : std_logic := '0';
begin
	
	process (trig_in, clk)
	begin
		if (clk = '1') then
			trig_out_tmp <= '0';
		elsif rising_edge(trig_in) then
			trig_out_tmp <= '1';
		end if;
	end process;
   
   trig_out <= trig_out_tmp;

end behavioral;

