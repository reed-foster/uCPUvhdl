----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:05:27 04/05/2016 
-- Design Name: 
-- Module Name:    or_gate_2 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- simple 2 input or gate
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity or_gate_2 is
    port (a : in  std_logic;
          b : in  std_logic;
          s : out  std_logic);
end or_gate_2;

architecture dataflow of or_gate_2 is
begin
	s <= a or b;
end dataflow;