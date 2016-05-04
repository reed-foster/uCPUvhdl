----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Reed Foster
-- 
-- Create Date:    15:36:52 04/05/2016 
-- Design Name: 
-- Module Name:    adder - dataflow 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- generic 2 to 1 adder with customizable bit width
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
   generic(dwidth : positive := 1);
   port (a : in  std_logic_vector (dwidth-1 downto 0);
         b : in  std_logic_vector (dwidth-1 downto 0);
         s : out std_logic_vector (dwidth-1 downto 0));
end adder;

architecture dataflow of adder is
begin
   s <= std_logic_vector(signed(a) + signed (b));
end dataflow;
