----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Reed Foster
-- 
-- Create Date:    13:12:35 04/06/2016 
-- Design Name: 
-- Module Name:    or_gate_3 - dataflow 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- simple 3 input or gate
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;


entity or_gate_3 is
    port (a : in  std_logic;
          b : in  std_logic;
			 c : in	std_logic;
          s : out std_logic);
end or_gate_3;

architecture dataflow of or_gate_3 is
begin
	s <= a or b or c;
end dataflow;