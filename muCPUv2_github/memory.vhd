----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Reed Foster
-- 
-- Create Date:    19:55:58 04/07/2016 
-- Design Name: 
-- Module Name:    memory - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- Main memory structural unit, calculates which unit should be selected based on address value
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
	port (--processor interface
			data_in		: in	std_logic_vector(7 downto 0);
			pc_in			: in	std_logic_vector(7 downto 0);
			mem_addr		: in	std_logic_vector(7 downto 0);
			mem_access	: in	std_logic;
			mem_store	: in	std_logic;
			clk			: in	std_logic;
			
			--data out
			ram_data_out	: out std_logic_vector(7 downto 0);
			rom_data_out	: out std_logic_vector(7 downto 0);
			io_data_out		: out std_logic_vector(7 downto 0);
			out_ctl			: out std_logic_vector(2 downto 0);
			
			--io interface
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
end memory;

architecture structural of memory is
	signal ram_sel, rom_sel, io_sel : std_logic := '0';
	signal address : std_logic_vector (7 downto 0) := "00000000";
	signal ram_out_ctl, rom_out_ctl, io_out_ctl : std_logic;
	
	component ram128x8 is
		port (addr		: in  std_logic_vector (6 downto 0);
				clk		: in  std_logic;
				store		: in  std_logic;
				sel		: in	std_logic;
				data_in	: in  std_logic_vector (7 downto 0);
				data_out	: out std_logic_vector (7 downto 0);
				out_ctl	: out std_logic
		);
	end component;
	
	component rom64x8 is
		port (addr 		: in  std_logic_vector (5 downto 0);
				sel		: in	std_logic;
				data_out : out std_logic_vector (7 downto 0);
				out_ctl	: out std_logic
		);
	end component;
	
	component iobank is
		port (portA_data_in	: in	std_logic_vector (7 downto 0);
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
				portD_out_ctl	: out	std_logic;
				cpu_data_in		: in	std_logic_vector (7 downto 0);
				cpu_data_out	: out	std_logic_vector (7 downto 0);
				cpu_addr			: in	std_logic_vector (1 downto 0);
				cpu_we			: in	std_logic;
				cpu_select		: in	std_logic;
				cpu_out_ctl		: out std_logic;
				clk				: in	std_logic
		);
	end component;
	
	component mux is
		generic(dwidth : positive);
		port (data_in_0	: in	std_logic_vector (dwidth-1 downto 0);
				data_in_1	: in	std_logic_vector (dwidth-1 downto 0);
				sel			: in	std_logic;
				data_out		: out std_logic_vector (dwidth-1 downto 0));
	end component;

begin

ram : ram128x8	port map(addr			=> address(6 downto 0),
								clk			=> clk,
								store			=> mem_store,
								sel			=> ram_sel,
								data_in		=> data_in,
								data_out		=> ram_data_out,
								out_ctl		=> ram_out_ctl);

rom : rom64x8	port map(addr			=> address(5 downto 0),
								sel			=> rom_sel,
								data_out		=> rom_data_out,
								out_ctl		=> rom_out_ctl);

io  : iobank	port map(portA_data_in	=> portA_data_in,
								portA_data_out	=> portA_data_out,
								portA_we			=> portA_we,
								portA_out_ctl	=> portA_out_ctl,
								portB_data_in	=> portB_data_in,
								portB_data_out	=> portB_data_out,
								portB_we			=> portB_we,
								portB_out_ctl	=> portB_out_ctl,
								portC_data_in	=> portC_data_in,
								portC_data_out	=> portC_data_out,
								portC_we			=> portC_we,
								portC_out_ctl	=> portC_out_ctl,
								portD_data_in	=> portD_data_in,
								portD_data_out	=> portD_data_out,
								portD_we			=> portD_we,
								portD_out_ctl	=> portD_out_ctl,
								cpu_data_in		=> data_in,
								cpu_data_out	=> io_data_out,
								cpu_addr			=> address(1 downto 0),
								cpu_we			=> mem_store,
								cpu_select		=> io_sel,
								cpu_out_ctl		=> io_out_ctl,
								clk				=> clk);

addrmux	: mux	generic map(dwidth		=> 8)
						port map(data_in_0	=> pc_in,
									data_in_1	=> mem_addr,
									sel			=> mem_access,
									data_out		=> address);

out_ctl <= io_out_ctl & rom_out_ctl & ram_out_ctl;

with address(7) select
	ram_sel <=	'1' when '0',
					'0' when others;

with address(7 downto 6) select
	rom_sel <=	'1' when "10",
					'0' when others;
		
with address(7 downto 2) select
	io_sel  <=	'1' when "111111",
					'0' when others;
					
end structural;

