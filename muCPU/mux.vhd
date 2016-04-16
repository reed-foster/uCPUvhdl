----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:11:10 04/05/2016 
-- Design Name: 
-- Module Name:    mux - dataflow 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- generic 2 input selector with customizable bit width
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity mux is
	generic (dwidth : positive := 1);
	port (data_in_0	: in std_logic_vector(dwidth-1 downto 0);
			data_in_1	: in std_logic_vector(dwidth-1 downto 0);
			sel			: in std_logic;
			data_out		: out std_logic_vector(dwidth-1 downto 0));
end mux;

architecture dataflow of mux is
begin
	with sel select
		data_out <= data_in_0 when '0',
						data_in_1 when '1',
						(others => '0') when others;
end dataflow;

