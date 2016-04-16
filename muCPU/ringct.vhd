----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:34:02 04/05/2016 
-- Design Name: 
-- Module Name:    ringct - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- ring counter; counts from 0 to 3 and loops back to 0; value increments on rising edge of clock
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ringct is
	port (clk 			: in  std_logic;
			ringct0 		: out  std_logic;
			ringct1 		: out  std_logic;
			ringct2	 	: out  std_logic;
			ringct3 		: out  std_logic);
end ringct;

architecture behavioral of ringct is
signal outvec : std_logic_vector (3 downto 0) := "0001";

begin

	count: process(clk)
	begin
		if (rising_edge(clk)) then
			outvec(1) <= outvec(0);
			outvec(2) <= outvec(1);
			outvec(3) <= outvec(2);
			outvec(0) <= outvec(3);
		end if;
	end process;
					 
	ringct0 	<= outvec(0);
	ringct1 	<= outvec(1);
	ringct2 	<= outvec(2);
	ringct3 	<= outvec(3);
	
end behavioral;

