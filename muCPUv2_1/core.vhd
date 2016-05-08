----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Reed Foster
-- 
-- Create Date:    18:43:52 03/28/2016 
-- Design Name: 
-- Module Name:    core - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- Core: An 8-bit data, 16-bit instruction load-store 2 pipeline stage CPU with 7 GPRs
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity core is
	port (portA_in, portB_in, portC_in, portD_in			: in	std_logic_vector (7 downto 0);
			portA_out, portB_out, portC_out, portD_out	: out	std_logic_vector (7 downto 0);
			portA_we, portB_we, portC_we, portD_we			: in	std_logic;
			clk50		: in		std_logic);
end core;

architecture structural of core is
	signal IF_EX_in, IF_EX_out : std_logic_vector (31 downto 0);
	signal IF_instr_out, EX_instr_in : std_logic_vector (15 downto 0);
	signal IF_pc_out, EX_pc_in : std_logic_vector (15 downto 0);
	signal fetch_pc_in : std_logic_vector(15 downto 0);
	signal mem_data_in, mem_data_out, ram_data_out, rom_data_out, io_data_out : std_logic_vector(7 downto 0);
   signal mem_addr : std_logic_vector(15 downto 0);
	signal out_ctl : std_logic_vector(2 downto 0);
	signal mem_access, mem_store : std_logic;
	signal ringct0, ringct1, ringct2, ringct3 : std_logic;
	
	--signals for outputs (only used for inout/high impedance)
	signal portA_out_ctl, portB_out_ctl, portC_out_ctl, portD_out_ctl : std_logic;
	
	--clk division for counting code
	signal clk_in, clk_tmp : std_logic := '0';
	signal counter : integer range 0 to 999999 := 0;
	
	component instruction_fetch is
		generic(romstartaddr : natural);
		port (clk				: in	std_logic;
				ringct0			: in	std_logic;
				ringct1			: in	std_logic;
				ringct2			: in	std_logic;
				pc_in				: in	std_logic_vector (15 downto 0);
				instr_byte_ser	: in	std_logic_vector (7 downto 0);
				instr_word_out	: out	std_logic_vector (15 downto 0);
				pc_out			: out	std_logic_vector (15 downto 0)
		);
	end component;
	
	component execute is
		port (instruction_in : in std_logic_vector (15 downto 0);
				pc_in				: in std_logic_vector (15 downto 0);
				mem_data_out	: in std_logic_vector (7 downto 0);
				ringct2			: in std_logic;
				ringct3			: in std_logic;
				clk				: in std_logic;
				mem_addr			: out std_logic_vector (15 downto 0);
				pc_out			: out std_logic_vector (15 downto 0);
				mem_data_in		: out	std_logic_vector (7 downto 0);
				mem_str			: out std_logic;
				mem_mux_sel		: out std_logic
		);
	end component;
	
	component memory is
		port (data_in		: in	std_logic_vector(7 downto 0);
				pc_in			: in	std_logic_vector(15 downto 0);
				mem_addr		: in	std_logic_vector(15 downto 0);
				mem_access	: in	std_logic;
				mem_store	: in	std_logic;
				clk			: in	std_logic;
				ram_data_out	: out std_logic_vector(7 downto 0);
				rom_data_out	: out std_logic_vector(7 downto 0);
				io_data_out		: out std_logic_vector(7 downto 0);
				out_ctl			: out std_logic_vector(2 downto 0);
				portA_data_in	: in	std_logic_vector (7 downto 0);
				portA_data_out	: out	std_logic_vector (7 downto 0);
				portA_we			: in	std_logic;
				portA_out_ctl	: out	std_logic;
				portB_data_in	: in	std_logic_vector (7 downto 0);
				portB_data_out	: out	std_logic_vector (7 downto 0);
				portB_we			: in	std_logic;
				portB_out_ctl	: out	std_logic;
				portC_data_in	: in	std_logic_vector (7 downto 0);
				portC_data_out	: out	std_logic_vector (7 downto 0);
				portC_we			: in	std_logic;
				portC_out_ctl	: out	std_logic;
				portD_data_in	: in	std_logic_vector (7 downto 0);
				portD_data_out	: out	std_logic_vector (7 downto 0);
				portD_we			: in	std_logic;
				portD_out_ctl	: out	std_logic
		);
	end component;
	
	component reg is
		generic(dwidth : positive;
				  q_init : natural);
		port (D		: in	std_logic_vector (dwidth-1 downto 0);
				en		: in	std_logic;
				clk	: in	std_logic;
				clr	: in	std_logic := '0';
				Q		: out	std_logic_vector (dwidth-1 downto 0)
		);
	end component;
	
	component ringct is
		port (clk 			: in	std_logic;
				ringct0 		: out	std_logic;
				ringct1 		: out	std_logic;
				ringct2	 	: out	std_logic;
				ringct3 		: out	std_logic);
	end component;
	
begin

fetch_unit	: instruction_fetch 	generic map(romstartaddr	=> 1024)
												port map(clk				=> clk_in,
															ringct0			=> ringct0,
															ringct1			=> ringct1,
															ringct2			=> ringct2,
															pc_in				=> fetch_pc_in,
															instr_byte_ser	=> mem_data_out,
															instr_word_out	=> IF_instr_out,
															pc_out			=> IF_pc_out);

IF_EX			: reg 					generic map(dwidth 			=> 32,
															q_init			=> 1024)
												port map(D					=> IF_EX_in,
															en					=> ringct3,
															clk				=> clk_in,
															clr				=> open,
															Q					=> IF_EX_out);

execute_unit: execute					port map(instruction_in	=> EX_instr_in,
															pc_in				=> EX_pc_in,
															mem_data_out	=> mem_data_out,
															ringct2			=> ringct2,
															ringct3			=> ringct3,
															clk				=> clk_in,
															mem_addr			=> mem_addr,
															pc_out			=> fetch_pc_in,
															mem_data_in		=> mem_data_in,
															mem_str			=> mem_store,
															mem_mux_sel		=> mem_access);

main_memory	: memory						port map(data_in			=> mem_data_in,
															pc_in				=> IF_pc_out,
															mem_addr			=> mem_addr,
															mem_access		=> mem_access,
															mem_store		=> mem_store,
															clk				=> clk_in,
															ram_data_out	=> ram_data_out,
															rom_data_out	=> rom_data_out,
															io_data_out		=> io_data_out,
															out_ctl			=> out_ctl,
															portA_data_in	=> portA_in,
															portA_data_out	=> portA_out,
															portA_we			=> portA_we,
															portA_out_ctl	=> portA_out_ctl,
															portB_data_in	=> portB_in,
															portB_data_out	=> portB_out,
															portB_we			=> portB_we,
															portB_out_ctl	=> portB_out_ctl,
															portC_data_in	=> portC_in,
															portC_data_out	=> portC_out,
															portC_we			=> portC_we,
															portC_out_ctl	=> portC_out_ctl,
															portD_data_in	=> portD_in,
															portD_data_out	=> portD_out,
															portD_we			=> portD_we,
															portD_out_ctl	=> portD_out_ctl);

control_unit	: ringct					port map(clk				=> clk_in,
															ringct0			=> ringct0,
															ringct1			=> ringct1,
															ringct2			=> ringct2,
															ringct3			=> ringct3);

IF_EX_in <= IF_instr_out & IF_pc_out;
EX_instr_in <= IF_EX_out(31 downto 16);
EX_pc_in <= IF_EX_out(15 downto 0);

--use if ports are inout
--portA <= portA_data_out when (portA_we /= '1') else "ZZZZZZZZ";
--portA_data_in <= portA when (portA_we = '1') else "00000000";
--portB <= portB_data_out when (portB_we /= '1') else "ZZZZZZZZ";
--portB_data_in <= portB when (portB_we = '1') else "00000000";
--portC <= portC_data_out when (portC_we /= '1') else "ZZZZZZZZ";
--portC_data_in <= portC when (portC_we = '1') else "00000000";
--portD <= portD_data_out when (portD_we /= '1') else "ZZZZZZZZ";
--portD_data_in <= portD when (portD_we = '1') else "00000000";

with out_ctl select
	mem_data_out <=	ram_data_out when "001",
							rom_data_out when "010",
							io_data_out when "100",
							"00000000" when others;

--clkdiv:process(clk50)
--begin
--	if rising_edge(clk50) then
--		if (counter = 999999) then
--			clk_tmp <= not clk_tmp;
--			counter <= 0;
--		else
--			counter <= counter + 1;
--		end if;
--	end if;
--end process;

clk_in <= clk50;

end structural;

