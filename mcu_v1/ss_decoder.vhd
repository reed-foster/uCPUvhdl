----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:54:44 05/06/2016 
-- Design Name: 
-- Module Name:    ss_decoder - dataflow 
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

entity ss_decoder is
   port (cs_in : in  std_logic;
         addr  : in  std_logic_vector (1 downto 0);
         ss    : out std_logic_vector (3 downto 0));
end ss_decoder;

architecture dataflow of ss_decoder is
--   type ss_array is array (0 to 3) of std_logic;
--   signal ss_int : ss_array := ('0','0','0','0'); 
begin
   
--   process(cs_in, addr)
--   begin
--      if rising_edge(cs_in) then
--         ss_int(to_integer(unsigned(addr))) <= '1';
--      end if;
--   end process;
   
   ss <= "1110" when (addr = "00" and cs_in = '1') else
         "1101" when (addr = "01" and cs_in = '1') else
         "1011" when (addr = "10" and cs_in = '1') else
         "0111" when (addr = "11" and cs_in = '1') else
         "1111";
--   ss <= not (ss_int(3)) & not (ss_int(2)) & not (ss_int(1)) & not (ss_int(0));

end dataflow;

