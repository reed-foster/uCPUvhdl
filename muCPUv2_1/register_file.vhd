----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Reed Foster
-- 
-- Create Date:    19:50:35 03/28/2016 
-- Design Name: 
-- Module Name:    register_file - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- 8-register GPR file (7 true GPRs; r0 is hardwired 0)
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
   port (opA_addr   : in  std_logic_vector (2 downto 0);
         opB_addr   : in  std_logic_vector (2 downto 0);
         write_data : in  std_logic_vector (7 downto 0);
         write_addr : in  std_logic_vector (2 downto 0);
         write_en   : in  std_logic;
         clk        : in  std_logic;
         opA        : out std_logic_vector (7 downto 0);
         opB        : out std_logic_vector (7 downto 0);
         r7         : out std_logic_vector (7 downto 0));
end register_file;

architecture behavioral of register_file is
type arry_type is array (7 downto 0) of std_logic_vector (7 downto 0);
signal reg_dat: arry_type := (others => "00000000");
begin
   store: process(clk, reg_dat, write_en, write_addr, write_data)
   begin
      if (rising_edge(clk)) then
         if (write_en = '1') then
            reg_dat(to_integer(unsigned(write_addr))) <= write_data;
         end if;
      end if;
      reg_dat(0) <= "00000000";
   end process;

   opA <= reg_dat(to_integer(unsigned(opA_addr)));
   opB <= reg_dat(to_integer(unsigned(opB_addr)));
   r7  <= reg_dat(7);
   
end behavioral;
