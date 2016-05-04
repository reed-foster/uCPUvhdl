----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:44:37 05/01/2016 
-- Design Name: 
-- Module Name:    ram - behavioral 
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
use ieee.numeric_std.all;

entity ram is
   port (addr  : in  std_logic_vector (7 downto 0);
         d_in  : in  std_logic_vector (7 downto 0);
         d_out : out std_logic_vector (7 downto 0);
         store : in  std_logic;
         clock : in  std_logic);
end ram;

architecture behavioral of ram is
   type ram_type is array (0 to 255) of std_logic_vector (7 downto 0);
   signal contents : ram_type := (others => "00000000");
begin

   process(clock, store, d_in, addr)
   begin
      if (rising_edge(clock) and store = '1') then
         contents(to_integer(unsigned(addr))) <= d_in;
      end if;
   end process;

   d_out <= contents(to_integer(unsigned(addr)));

end behavioral;

