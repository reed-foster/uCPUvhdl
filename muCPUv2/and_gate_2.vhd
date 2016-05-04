----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Reed Foster
-- 
-- Create Date:    19:04:33 04/06/2016 
-- Design Name: 
-- Module Name:    and_gate_2 - dataflow 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- simple 2 input and gate
--
--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity and_gate_2 is
   port (a : in  std_logic;
         b : in  std_logic;
         p : out std_logic);
end and_gate_2;

architecture dataflow of and_gate_2 is
begin
   p <= a and b;
end dataflow;
