----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:03:19 05/07/2016 
-- Design Name: 
-- Module Name:    write_latch - behavioral 
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

entity write_latch is
   port (trig    : in  std_logic;
         clk     : in  std_logic;
         dequeue : in  std_logic;
         enqueue : out std_logic);
end write_latch;

architecture behavioral of write_latch is
   signal main_ff, clear_ff : std_logic := '0';
begin
   
   process(trig, clk, dequeue, main_ff, clear_ff)
   begin
--      if (rising_edge(clk) and dequeue /= '1') then
--         enqueue <= '0';
--      elsif rising_edge(trig) then
--         enqueue <= '1';
--      end if;
      
      if (clear_ff = '1' and main_ff = '1') then
         clear_ff <= '0';
      elsif (rising_edge(clk) and (dequeue /= '1' and main_ff = '1')) then
         clear_ff <= '1';
      end if;
      if (clear_ff = '1') then
         main_ff <= '0';
      elsif rising_edge(trig) then
         main_ff <= '1';
      end if;
      
      enqueue <= main_ff;
   end process;


end behavioral;

