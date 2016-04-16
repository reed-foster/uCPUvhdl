----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Reed Foster
-- 
-- Create Date:    08:45:06 04/10/2016 
-- Design Name: 
-- Module Name:    iobank - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- 4B bank of memory-mapped io registers
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity iobank is
	port (cpu_data_in		: in	std_logic_vector (7 downto 0);
			cpu_data_out	: out	std_logic_vector (7 downto 0);
			cpu_addr			: in	std_logic_vector (1 downto 0);
			clk				: in	std_logic;
			cpu_we			: in	std_logic;
			cpu_select		: in	std_logic;
			cpu_out_ctl		: out	std_logic;
			
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
end iobank;

architecture behavioral of iobank is
type array_type is array (3 downto 0) of std_logic_vector (7 downto 0);
signal port_data: array_type := (others => "00000000");
begin
	
	write_data: process(clk)
	begin
		if (rising_edge(clk)) then
			if (portA_we = '1') then
				port_data(0) <= portA_data_in;
			elsif (cpu_we = '1' and cpu_select = '1' and cpu_addr = "00") then
				port_data(0) <= cpu_data_in;
			end if;
			if (portB_we = '1') then
				port_data(1) <= portB_data_in;
			elsif (cpu_we = '1' and cpu_select = '1' and cpu_addr = "01") then
				port_data(1) <= cpu_data_in;
			end if;
			if (portC_we = '1') then
				port_data(2) <= portC_data_in;
			elsif (cpu_we = '1' and cpu_select = '1' and cpu_addr = "10") then
				port_data(2) <= cpu_data_in;
			end if;
			if (portD_we = '1') then
				port_data(3) <= portD_data_in;
			elsif (cpu_we = '1' and cpu_select = '1' and cpu_addr = "11") then
				port_data(3) <= cpu_data_in;
			end if;
		end if;
	end process;
	
	cpu_data_out <= port_data(to_integer(unsigned(cpu_addr)));
	cpu_out_ctl <= '1' when (cpu_select = '1' and cpu_we /= '1') else '0';
	
	portA_data_out <= port_data(0);
	portA_out_ctl <= '1' when (portA_we /= '1') else '0';
	portB_data_out <= port_data(1);
	portB_out_ctl <= '1' when (portB_we /= '1') else '0';
	portC_data_out <= port_data(2);
	portC_out_ctl <= '1' when (portC_we /= '1') else '0';
	portD_data_out <= port_data(3);
	portD_out_ctl <= '1' when (portD_we /= '1') else '0';

end behavioral;

