----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Reed Foster
-- 
-- Create Date:    21:55:39 04/07/2016 
-- Design Name: 
-- Module Name:    rom64x8 - behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- 64B read only memory
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom4kB is
   port (addr     : in  std_logic_vector (11 downto 0);
         sel      : in  std_logic;
         data_out : out std_logic_vector (7 downto 0);
         out_ctl  : out std_logic
	);
end rom4kB;

architecture behavioral of rom4kB is
   type array_type is array (0 to 4095) of std_logic_vector (7 downto 0);
   type prog_type is array (0 to 1023) of std_logic_vector (15 downto 0);
   type data_type is array (0 to 2047) of std_logic_vector (7 downto 0);
   constant prog_instr : prog_type := (
--	   fill with desired program (max 1023 instructions)
----------------------------------------------------------------------------------------------------------
--		current program : loads two values (count to and increment) and outputs current count value to io port
--    
--	   ldi r4, 42
--	   lb r3, 1(r0)
--    lb r7, 2(r0)
--	   sub r2, r4, r1
--	   bez r2, 8
--	   sb r1, 252(r0)
--	   bez r0, -8
--	   add r1, r1, r3
--	   sll r0, r0, r0
--	   bez r0, -2
      0 => x"6642",
      1 => x"8301",
      2 => x"8702",
      3 => x"2142",
      4 => x"5008",
      5 => x"c1fc",
      6 => x"40f8",
      7 => x"0b21",
      8 => x"0000",
      9 => x"40fe",
      others => x"0000"

   );
   constant prog_data : data_type := (
      --fill with data to be used in program
      0			=> x"42", --value to count to
      1			=> x"01", --value to increment by
      2        => x"ff", --upper bits of address for i/o
      others	=> x"00"
   );
   signal program : array_type;
   signal const0 : std_logic := '0';
begin
   
   process(const0)
   begin
      for i in 0 to 1023 loop
         program(i*2 + 2048) <= prog_instr(i)(15 downto 8);
         program(i*2 + 1 + 2048) <= prog_instr(i)(7 downto 0);
      end loop;
      for i in 0 to 2047 loop
         program(i) <= prog_data(i);
      end loop;
   end process;
   data_out <= program(to_integer(unsigned(addr)));
   out_ctl <= '1' when (sel = '1') else '0';

end behavioral;

