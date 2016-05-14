----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:58:05 05/06/2016 
-- Design Name: 
-- Module Name:    clk_div - behavioral 
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

entity clk_div is
   generic (prescalar : natural := 8);
   port (clk_in  : in  std_logic;
         clk_out : out std_logic);
end clk_div;

architecture behavioral of clk_div is
   signal clk_tmp : std_logic := '0';
   signal counter : integer range 0 to (prescalar / 2) := 0;
begin
   process(clk_in)
   begin
      if rising_edge(clk_in) then
         if (counter > ((prescalar / 2) - 1)) then
            counter <= 0;
            clk_tmp <= not clk_tmp;
         else
            counter <= counter + 1;
         end if;
      end if;
   end process;
   
   clk_out <= clk_tmp;
end behavioral;

