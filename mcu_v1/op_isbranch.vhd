----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Reed Foster
-- 
-- Create Date:    21:03:56 04/06/2016 
-- Design Name: 
-- Module Name:    op_isbranch - dataflow 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- if opcode is branch then outputs a 1, else a 0
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity op_isbranch is
   port (op3 : in  std_logic;
         r   : out std_logic);
end op_isbranch;

architecture dataflow of op_isbranch is
begin
	r <= '1' when (op3 = '1') else '0'; --r <= 1 when (opcode >= 8)
end dataflow;

