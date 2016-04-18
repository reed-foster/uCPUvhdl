--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:06:19 04/17/2016
-- Design Name:   
-- Module Name:   C:/Users/Reed2/Desktop/XilinxPrograms/spi_test/spi_master_testbench.vhd
-- Project Name:  spi_test
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: spi_master
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY spi_master_testbench IS
END spi_master_testbench;
 
ARCHITECTURE behavior OF spi_master_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT spi_master
    PORT(
         pdata_in : IN  std_logic_vector(7 downto 0);
         trig : IN  std_logic;
         clk_in : IN  std_logic;
         busy : OUT  std_logic;
         sclk : OUT  std_logic;
         data_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal pdata_in : std_logic_vector(7 downto 0) := (others => '0');
   signal trig : std_logic := '0';
   signal clk_in : std_logic := '0';

 	--Outputs
   signal busy : std_logic;
   signal sclk : std_logic;
   signal data_out : std_logic;

   -- Clock period definitions
   constant clk_in_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: spi_master PORT MAP (
          pdata_in => pdata_in,
          trig => trig,
          clk_in => clk_in,
          busy => busy,
          sclk => sclk,
          data_out => data_out
        );

   -- Clock process definitions
   clk_in_process :process
   begin
		clk_in <= '0';
		wait for clk_in_period/2;
		clk_in <= '1';
		wait for clk_in_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		trig <= '1';
		wait for 375ns;
		pdata_in <= x"de";
		trig <= '1';
		wait until (falling_edge(sclk));
		trig <= '0';
		wait until (busy = '0');
		wait for 500ns;
		
		pdata_in <= x"ad";
		trig <= '1';
		wait until (falling_edge(sclk));
		trig <= '0';
		wait until (busy = '0');
		wait for 500ns;
		
		pdata_in <= x"be";
		trig <= '1';
		wait until (falling_edge(sclk));
		trig <= '0';
		wait until (busy = '0');
		wait for 500ns;
		
		pdata_in <= x"ef";
		trig <= '1';
		wait until (falling_edge(sclk));
		trig <= '0';
		wait until (busy = '0');
		wait for 500ns;
		
   end process;

END;
