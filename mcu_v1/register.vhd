----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Reed Foster
-- 
-- Create Date:    15:14:05 04/05/2016 
-- Design Name: 
-- Module Name:    register - dataflow 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- generic register (clocked d flip-flop, active high reset) with customizable bitwidth
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
	generic(dwidth : positive := 1;
			  q_init : natural := 0);
	port (D		: in	std_logic_vector (dwidth-1 downto 0);
			en		: in	std_logic;
			clk	: in	std_logic;
			clr	: in	std_logic;
			Q		: out	std_logic_vector (dwidth-1 downto 0)
	);
end reg;

architecture behavioral of reg is
signal q_tmp : std_logic_vector(dwidth-1 downto 0) := std_logic_vector(to_unsigned(q_init, dwidth));
begin
	reg: process(clk, clr)
	begin
		if (clr = '1') then
			q_tmp <= (others => '0');
		elsif (rising_edge(clk)) then
			if (en = '1') then
				q_tmp <= D;
			end if;
		end if;
	end process;
	
	Q <= q_tmp;
end behavioral;

