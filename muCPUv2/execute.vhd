----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Reed Foster
-- 
-- Create Date:    18:50:04 04/06/2016 
-- Design Name: 
-- Module Name:    execute - structural 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- executes instructions according to muCPU ISA
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity execute is
	port (instruction_in : in	std_logic_vector (15 downto 0);
			pc_in				: in	std_logic_vector (7 downto 0);
			mem_data_out	: in	std_logic_vector (7 downto 0);
			ringct2			: in	std_logic;
			ringct3			: in	std_logic;
			clk				: in	std_logic;
			mem_addr			: out std_logic_vector (7 downto 0);
			pc_out			: out std_logic_vector (7 downto 0);
			mem_data_in		: out	std_logic_vector (7 downto 0);
			mem_str			: out std_logic;
			mem_mux_sel		: out std_logic);
end execute;

architecture structural of execute is
	signal rs, rt, rd 	: std_logic_vector (2 downto 0) := (others => '0');
	signal alu_opcode 	: std_logic_vector (3 downto 0) := (others => '0');
	signal imm				: std_logic_vector (7 downto 0) := (others => '0');
	signal ctl				: std_logic_vector (2 downto 0) := (others => '0');
	signal ctl_12_or_out : std_logic := '0';
	signal opa, opb		: std_logic_vector (7 downto 0) := (others => '0');
	signal opbmux_in		: std_logic_vector (7 downto 0) := (others => '0');
	signal alu_res			: std_logic_vector (7 downto 0) := (others => '0');
	signal ringct_or_out	: std_logic := '0';
	signal is_mem			: std_logic := '0';
	signal wb_en			: std_logic := '0';
	signal wb_data			: std_logic_vector (7 downto 0) := (others => '0');
	
	component instructiondecode is
		port (instruction : in  std_logic_vector (15 downto 0);
				imm 			: out  std_logic_vector (7 downto 0);
				rs 			: out  std_logic_vector (2 downto 0);
				rt 			: out  std_logic_vector (2 downto 0);
				rd 			: out  std_logic_vector (2 downto 0);
				alu_opcode 	: out  std_logic_vector (3 downto 0);
				ctl 			: out  std_logic_vector (2 downto 0));
	end component;
	
	component register_file is
		port (opA_addr		: in std_logic_vector (2 downto 0);
				opB_addr		: in std_logic_vector (2 downto 0);
				write_data	: in std_logic_vector (7 downto 0);
				write_addr	: in std_logic_vector (2 downto 0);
				write_en		: in std_logic;
				clk			: in std_logic;
				opA			: out std_logic_vector (7 downto 0);
				opB			: out std_logic_vector (7 downto 0));
	end component;
	
	component or_gate_2 is
		port (a : in std_logic;
				b : in std_logic;
				s : out std_logic);
	end component;
	
	component and_gate_2 is 
		port (a : in std_logic;
				b : in std_logic;
				p : out std_logic);
	end component;
	
	component mux is
		generic (dwidth : positive);
		port (data_in_0	: in std_logic_vector(dwidth-1 downto 0);
				data_in_1	: in std_logic_vector(dwidth-1 downto 0);
				sel			: in std_logic;
				data_out		: out std_logic_vector(dwidth-1 downto 0));
	end component;
	
	component alu is
		port (A  : in std_logic_vector (7 downto 0);
				B  : in std_logic_vector (7 downto 0);
				op : in std_logic_vector (3 downto 0);
				R  : out std_logic_vector(7 downto 0));
	end component;
	
	component branch_unit is
		port (res	: in std_logic;
				op		: in std_logic_vector (3 downto 0);
				imm	: in std_logic_vector (7 downto 0);
				pc_in : in std_logic_vector (7 downto 0);
				pc_out: out std_logic_vector (7 downto 0));
	end component;
	
begin
--large components
--instruction decoder
instructiondecode0: instructiondecode	port map(instruction => instruction_in,
																imm			=> imm,
																rs				=> rs,
																rt				=> rt,
																rd				=> rd,
																alu_opcode	=> alu_opcode,
																ctl			=> ctl);
--general purpose register file
registerfile0		: register_file		port map(opA_addr		=> rs,
																opB_addr		=> rt,
																write_data	=> wb_data,
																write_addr	=> rd,
																write_en		=> wb_en,
																clk			=> clk,
																opA			=> opa,
																opB			=> opbmux_in);
--arithmetic logic unit
alu0					: alu						port map(A				=> opa,
																B				=> opb,
																op				=> alu_opcode,
																R				=> alu_res);
--branch address and result calculation
branchunit0			: branch_unit			port map(res			=> alu_res(0),
																op				=> alu_opcode,
																imm			=> imm,
																pc_in			=> pc_in,
																pc_out		=> pc_out);

--mulitplexers
opbmux0				: mux	generic map(dwidth => 8)	port map(data_in_0	=> opbmux_in,
																				data_in_1	=> imm,
																				sel			=> ctl_12_or_out,
																				data_out		=> opb);

wbmux0				: mux	generic map(dwidth => 8)	port map(data_in_0	=> alu_res,
																				data_in_1	=> mem_data_out,
																				sel			=> ctl(1),
																				data_out		=> wb_data);

--logic gates
ctl_12_or0			: or_gate_2		port map(a => ctl(1),
														b => ctl(2),
														s => ctl_12_or_out);

ringct_or0			: or_gate_2		port map(a => ringct2,
														b => ringct3,
														s => ringct_or_out);

mem_str_and0		: and_gate_2	port map(a => ctl(2),
														b => ringct_or_out,
														p => mem_str);

mem_mux_sel_and0	: and_gate_2	port map(a => ctl_12_or_out,
														b => ringct_or_out,
														p => mem_mux_sel);

wb_en_and0			: and_gate_2	port map(a => ringct3,
														b => ctl(0),
														p => wb_en);

mem_data_in <= opbmux_in;
mem_addr		<= alu_res;
end structural;