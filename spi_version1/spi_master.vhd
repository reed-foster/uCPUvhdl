----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:06:34 04/17/2016 
-- Design Name: 
-- Module Name:    spi_master - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_master is
	port (pdata_in	: in	std_logic_vector(0 to 7);
			trig		: in	std_logic;
			clk_in	: in	std_logic;
			busy		: out std_logic;
			sclk		: out	std_logic;
			data_out	: out	std_logic);
end spi_master;

architecture behavioral of spi_master is
	signal clk_div_cnt, bit_num : natural := 0;
	signal clk_tmp	: std_logic := '0';
	signal triglatch : std_logic := '0';
	signal d_out_tmp : std_logic := 'Z';
	constant prescalar : natural := 3;
begin

	clkdiv:process(clk_in)
	begin
		if rising_edge(clk_in) then
			if (clk_div_cnt = prescalar) then
				clk_tmp <= not clk_tmp;
				clk_div_cnt <= 0;
			else
				clk_div_cnt <= clk_div_cnt + 1;
			end if;
		end if;
	end process;
	sclk <= clk_tmp;
	
	sendmsg:process(clk_tmp, trig)
	begin
		if falling_edge(clk_tmp) then
			if (trig = '1' or triglatch = '1') then
				if (bit_num > 7) then
					busy <= '0';
					bit_num <= 0;
					triglatch <= '0';
					d_out_tmp <= 'Z';
				else
					triglatch <= '1';
					busy <= '1';
					d_out_tmp <= pdata_in(bit_num);
					bit_num <= bit_num + 1;
				end if;
			end if;
		end if;
	end process;
	data_out <= d_out_tmp;

end behavioral;

