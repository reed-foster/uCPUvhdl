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
--		current program : draw a buffer to ssd1306 oled controller (commented code sends commands to processor)
      0 => x"7eff",
      1 => x"5601",
      2 => x"81ff",
      3 => x"0a27",
      4 => x"c1ff",
      5 => x"56fe",
      6 => x"81ff",
      7 => x"0a26",
      8 => x"c1ff",
      9 => x"660a",
      10 => x"5e01",
      11 => x"4e00",
      12 => x"2143",
      13 => x"5006",
      14 => x"0b22",
      15 => x"40f8",
      16 => x"0000",
      17 => x"5601",
      18 => x"81ff",
      19 => x"0a27",
      20 => x"c1ff",
      21 => x"56e7",
      22 => x"81ff",
      23 => x"0a26",
      24 => x"c1ff",
      25 => x"567f",
      26 => x"81ff",
      27 => x"0a26",
      28 => x"c1ff",
      29 => x"661f",
      30 => x"5e01",
      31 => x"4e00",
      32 => x"2143",
      33 => x"502a",
      34 => x"7e0c",
      35 => x"8d00",
      36 => x"7eff",
      37 => x"c5fe",
      38 => x"7604",
      39 => x"85ff",
      40 => x"2ea7",
      41 => x"c5ff",
      42 => x"7640",
      43 => x"85ff",
      44 => x"2ea6",
      45 => x"6906",
      46 => x"0000",
      47 => x"40f6",
      48 => x"0000",
      49 => x"76fb",
      50 => x"85ff",
      51 => x"2ea6",
      52 => x"c5ff",
      53 => x"40d4",
      54 => x"0b22",
      55 => x"7eff",
      56 => x"7620",
      57 => x"85ff",
      58 => x"2ea6",
      59 => x"6906",
      60 => x"0000",
      61 => x"40f6",
      62 => x"0000",
      63 => x"5680",
      64 => x"81ff",
      65 => x"0a27",
      66 => x"c1ff",
      67 => x"7e08",
      68 => x"5e01",
      69 => x"4e08",
      70 => x"660c",
      71 => x"21a3",
      72 => x"683a",
      73 => x"0000",
      74 => x"66ff",
      75 => x"5600",
      76 => x"22a3",
      77 => x"682c",
      78 => x"0000",
      79 => x"9500",
      80 => x"7eff",
      81 => x"c5fe",
      82 => x"7604",
      83 => x"85ff",
      84 => x"2ea7",
      85 => x"c5ff",
      86 => x"7640",
      87 => x"85ff",
      88 => x"2ea6",
      89 => x"6906",
      90 => x"0000",
      91 => x"40f6",
      92 => x"0000",
      93 => x"76fb",
      94 => x"85ff",
      95 => x"2ea6",
      96 => x"c5ff",
      97 => x"08e2",
      98 => x"40d2",
      99 => x"1342",
      100 => x"40c2",
      101 => x"0b22",
      102 => x"0000",
      103 => x"40fe",
      others => x"0000"

   );
   constant prog_data : data_type := (
      --fill with data to be used in program
      --init code
      1024 => x"ae",
      1025 => x"d5",
      1026 => x"80",
      1027 => x"a8",
      1028 => x"3f",
      1029 => x"d3",
      1030 => x"00",
      1031 => x"40",
      1032 => x"8d",
      1033 => x"14",
      1034 => x"20",
      1035 => x"00",
      1036 => x"a1",
      1037 => x"c8",
      1038 => x"da",
      1039 => x"12",
      1040 => x"81",
      1041 => x"cf",
      1042 => x"d9",
      1043 => x"f1",
      1044 => x"db",
      1045 => x"40",
      1046 => x"a4",
      1047 => x"a6",
      1048 => x"af",
      1049 => x"21",
      1050 => x"00",
      1051 => x"7f",
      1052 => x"22",
      1053 => x"00",
      1054 => x"07",
      others	=> x"00"
   );
   signal program : array_type;
   signal const0 : std_logic := '0';
begin
   
   process(const0)
   begin
      for i in 0 to 1023 loop
         program(i*2) <= prog_instr(i)(15 downto 8);
         program(i*2 + 1) <= prog_instr(i)(7 downto 0);
      end loop;
      for i in 0 to 2047 loop
         program(i + 2048) <= prog_data(i);
      end loop;
   end process;
   data_out <= program(to_integer(unsigned(addr)));
   out_ctl <= '1' when (sel = '1') else '0';

end behavioral;

