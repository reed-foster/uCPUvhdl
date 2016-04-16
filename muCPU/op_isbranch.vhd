----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
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
    port ( op : in  std_logic_vector (2 downto 0);
           r : out  std_logic);
end op_isbranch;

architecture dataflow of op_isbranch is
begin
	r <= (op(0) and (not op (1)) and op(2)) or ((not op(0)) and op (1) and op(2));
end dataflow;

