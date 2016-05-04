----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:22:14 05/01/2016 
-- Design Name: 
-- Module Name:    sreg - dataflow 
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

entity sreg is
   generic(len : positive := 8);
   port (pdata_in  : in  std_logic_vector (len-1 downto 0);
         pdata_out : out std_logic_vector (len-1 downto 0);
         data_in   : in  std_logic;
         data_out  : out std_logic;
         shift     : in  std_logic;
         load      : in  std_logic;
         clock     : in  std_logic;
         clear     : in  std_logic);
end sreg;

architecture behavioral of sreg is
   signal q : std_logic_vector (len-1 downto 0) := (len-1 downto 0 => '0');
begin
   process(pdata_in, data_in, shift, load, clock)
   begin
      if (clear = '1') then
         if rising_edge(clock) then
            if (load = '1') then
               q <= pdata_in;
            elsif (shift = '1') then
               q <= q(len-2 downto 0) & data_in;
            end if;
         end if;
      end if;
   end process;

   pdata_out <= q;
   data_out <= q(len-1);

end behavioral;

