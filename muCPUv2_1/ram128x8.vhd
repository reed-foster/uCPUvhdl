----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Reed Foster
-- 
-- Create Date:    22:17:03 03/31/2016 
-- Design Name: 
-- Module Name:    ram32kB - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- 128B random-access memory
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram4kB is
   port (addr     : in  std_logic_vector (11 downto 0);
         clk      : in  std_logic;
         store    : in  std_logic;
         sel      : in  std_logic;
         data_in  : in  std_logic_vector (7 downto 0);
         data_out : out std_logic_vector (7 downto 0);
         out_ctl  : out std_logic);
end ram4kB;

architecture behavioral of ram4kB is
   type arry_type is array (0 to 4095) of std_logic_vector (7 downto 0);
   signal mem_contents : arry_type := (others => "00000000");
begin

   write_data: process(clk)
   begin
      if (rising_edge(clk)) then
         if (store = '1' and sel = '1') then
            mem_contents(to_integer(unsigned(addr))) <= data_in;
         end if;
      end if;
   end process;
   
   data_out <= mem_contents(to_integer(unsigned(addr)));
   out_ctl <= '1' when (store /= '1' and sel = '1') else '0';

end behavioral;

