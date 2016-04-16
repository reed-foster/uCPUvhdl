----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:39:56 04/06/2016 
-- Design Name: 
-- Module Name:    branch_unit - structural 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- calculates branch and determines next pc value based on alu result
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity branch_unit is
	port (res		: in  std_logic;
			op			: in  std_logic_vector (2 downto 0);
			imm		: in  std_logic_vector (7 downto 0);
			pc_in		: in  std_logic_vector (7 downto 0);
			pc_out	: out  std_logic_vector (7 downto 0));
end branch_unit;

architecture structural of branch_unit is
	signal branch, pc_mux_sel : std_logic := '0';
	signal pc_in_plus_imm, pc_in_plus_2 : std_logic_vector (7 downto 0) := (others => '0');
	
	component adder is
		generic(dwidth : positive);
		port (a : in  std_logic_vector (dwidth-1 downto 0);
				b : in  std_logic_vector (dwidth-1 downto 0) := (dwidth-1 downto 2 => '0') & "10";
				s : out  std_logic_vector (dwidth-1 downto 0));
	end component;
	
	component mux is
		generic (dwidth : positive);
		port (data_in_0	: in std_logic_vector(dwidth-1 downto 0);
				data_in_1	: in std_logic_vector(dwidth-1 downto 0);
				sel			: in std_logic;
				data_out		: out std_logic_vector(dwidth-1 downto 0));
	end component;
	
	component op_isbranch is
		port (op : in std_logic_vector(2 downto 0);
				r  : out std_logic);
	end component;
	
	component and_gate_2 is
		port (a : in std_logic;
				b : in std_logic;
				p : out std_logic);
	end component;
	
begin
--decode op and output 1 if beq/bne
op_isbranch0: op_isbranch	port map(op				=> op,
												r  			=> branch);

--beq/bne and alu_res
and_gate0	: and_gate_2	port map(a				=> res,
												b 				=> branch,
												p 				=> pc_mux_sel);

--output = branch ? pc + imm : pc + 2
pc_mux0		: mux			generic map(dwidth 		=> 8)
									port map(data_in_0	=> pc_in_plus_2,
												data_in_1	=> pc_in_plus_imm,
												sel			=> pc_mux_sel,
												data_out		=> pc_out);

--pc + imm
imm_add0		: adder		generic map(dwidth		=> 8)
									port map(a				=> pc_in,
												b				=> imm,
												s				=> pc_in_plus_imm);

--pc + 2
inc2_add0	: adder		generic map(dwidth		=> 8)
									port map(a				=> pc_in,
												b				=> open,
												s				=> pc_in_plus_2);
end structural;

