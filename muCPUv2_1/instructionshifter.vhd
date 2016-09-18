----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Reed Foster
-- 
-- Create Date:    21:15:38 04/05/2016 
-- Design Name: 
-- Module Name:    instructionshifter - dataflow 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- specialized shift register; loads one byte per clock cycle and outputs last
-- two bytes concatenated into 2byte word.
--
-- example behavior:
--
-- clk  input contents
-- --------------------
-- t0 |	0a  |	 0000  |
-- t1 |	26  |	 000a  |
-- t2 |	f3  |	 0a26  |
-- t3 |	60  |	 26f3  |
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity instructionshifter is
   port (shift_in  : in  std_logic_vector (7 downto 0);
         clk       : in  std_logic;
         en        : in  std_logic;
         shift_out : out  std_logic_vector (15 downto 0));
end instructionshifter;

architecture behavioral of instructionshifter is
   signal shift_tmp : std_logic_vector (15 downto 0) := (others => '0');
begin
   shift: process(shift_in, clk, en)
   begin
      if (rising_edge(clk)) then
         if (en = '1') then
            shift_tmp <= shift_tmp (7 downto 0) & shift_in;
         end if;
      end if;
   end process;
   shift_out <= shift_tmp;
end behavioral;

