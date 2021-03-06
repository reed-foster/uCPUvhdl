----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Reed Foster
-- 
-- Create Date:    19:48:10 03/28/2016 
-- Design Name: 
-- Module Name:    alu - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- Arithmetic logic unit, does the number crunching
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
   port (A  : in  std_logic_vector (7 downto 0);
         B  : in  std_logic_vector (7 downto 0);
         op : in  std_logic_vector (3 downto 0);
         R  : out  std_logic_vector(7 downto 0));
end alu;

architecture dataflow of alu is
   signal bshort : std_logic_vector(2 downto 0) := "000";
	
   signal shifted, addval, subval, bez_res, bnez_res, bgez_res, blez_res, bgz_res, blz_res : std_logic_vector(7 downto 0);

begin

   bshort <= B(2 downto 0);
	
   --sll function
   with bshort select
      shifted <= A (6 downto 0) & "0" when      "001",
                 A (5 downto 0) & "00" when     "010",
                 A (4 downto 0) & "000" when    "011",
                 A (3 downto 0) & "0000" when   "100",
                 A (2 downto 0) & "00000" when  "101",
                 A (1 downto 0) & "000000" when "110",
                 A (0) & "0000000" when         "111",
                 A when                         others;

   --Arithmetic
   addval <= std_logic_vector(signed(A) + signed(B));
   subval <= std_logic_vector(signed(A) - signed(B));
   
   --Testing function
   bez_res    <= "11111111" when (A = "00000000") else "00000000";                  --if A == 0 then branch
   bnez_res   <= "00000000" when (A = "00000000") else "11111111";                  --if A != 0 then branch
   bgez_res   <= "11111111" when (A(7) /= '1') else "00000000";                     --if A is not negative (A >= 0) then branch
   blez_res   <= "11111111" when (A = "00000000" or A(7) = '1') else "00000000";    --if A is zero or negative (A <= 0) then branch
   bgz_res    <= "11111111" when (A /= "00000000" and A(7) /= '1') else "00000000"; --if A is not zero and not negative (A > 0) then branch
   blz_res    <= "11111111" when (A(7) = '1') else "00000000";                      --if A is negative (A < 0) then branch
	
   --Output generation
   with op select
      R <= shifted when        "0000",
           addval when         "0001",
           subval when         "0010",
           not (A and B) when  "0011",
           not (A or B) when   "0100",
           bez_res when        "0101",
           bnez_res when       "0110",
           bgez_res when       "0111",
           blez_res when       "1000",
           bgz_res when        "1001",
           blz_res when        "1010",
           "00000000" when     others; --also useful for debugging
end dataflow;



