----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:48:41 05/06/2016 
-- Design Name: 
-- Module Name:    d_ff - behavioral 
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

-- uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
--use ieee.numeric_std.all;

-- uncomment the following library declaration if instantiating
-- any xilinx primitives in this code.
--library unisim;
--use unisim.vcomponents.all;

entity d_ff is
   port (clk    : in  std_logic;
         d      : in  std_logic;
         en     : in  std_logic;
         clear  : in  std_logic;
         q      : out std_logic);
end d_ff;

architecture behavioral of d_ff is
   signal data : std_logic := '0';
begin
   
   process(d, clk, en, clear)
   begin
      if (clear = '1') then
         data <= '0';
      elsif (rising_edge(clk) and en = '1') then
         data <= d;
      end if;
   end process;
   
   q <= data;
   
end behavioral;

