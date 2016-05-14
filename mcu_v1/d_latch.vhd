----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:53:17 05/06/2016 
-- Design Name: 
-- Module Name:    d_latch - behavioral 
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

entity d_latch is
   port (trig  : in  std_logic;
         clear : in  std_logic;
         q     : out std_logic);
end d_latch;

architecture behavioral of d_latch is
   signal ff1 : std_logic := '0';
   signal ff2 : std_logic := '0';
   signal data : std_logic := '0';
begin

   process (trig, clear, ff1, ff2)
   begin
      if (clear = '1') then
         data <= '0';
      elsif rising_edge(trig) then
         data <= '1';
      end if;
   end process;

   q <= data;
end behavioral;

