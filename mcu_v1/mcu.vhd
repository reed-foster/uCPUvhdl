----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:22:42 05/08/2016 
-- Design Name: 
-- Module Name:    mcu - structural 
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

entity mcu is
   port (clk   : in  std_logic;
         mosi  : out std_logic;
         sclk  : out std_logic;
         rst   : out std_logic;
         ss    : out std_logic;
         dc    : out std_logic);
end mcu;

architecture structural of mcu is
   
   signal reset, flush, w_en : std_logic := '0';
   signal wrt_complete, done : std_logic := '0';
   
   signal ssvec : std_logic_vector(3 downto 0) := "0000";
   
   signal spi_ctlreg_in, spi_ctlreg_out, spi_datareg_out : std_logic_vector (7 downto 0) := "00000000";
   signal spi_ctlreg_we : std_logic := '0';
   signal clear_update_trigs, update_bc_ctl5, update_bc_ctl6 : std_logic := '0';
   
   component core is
      port (portA_in, portB_in, portC_in, portD_in       : in  std_logic_vector (7 downto 0) := "00000000";
            portA_out, portB_out, portC_out, portD_out   : out std_logic_vector (7 downto 0);
            portA_we, portB_we, portC_we, portD_we       : in  std_logic := '0';
            clk50 : in std_logic);
   end component;
   
   component spi_send is
      generic(prescalar : positive := 5);
      port (reset	         : in	std_logic;
            flush	         : in	std_logic;
            pMOSI	         : in	std_logic_vector (7 downto 0);
            w_en	         : in	std_logic;
            cpu_clk	      : in	std_logic;
            wrt_complete   : out std_logic;
            addr	         : in	std_logic_vector (1 downto 0);
            done	         : out	std_logic;
            mosi           : out std_logic;
            sclk           : out std_logic;
            rst            : out std_logic;
            ss             : out std_logic_vector (3 downto 0));
   end component;
   
begin

   core0 : core
      port map(portA_in    => open,
               portB_in    => open,
               portC_in    => open,
               portD_in    => spi_ctlreg_in,
               portA_out   => open,
               portB_out   => open,
               portC_out   => spi_datareg_out,
               portD_out   => spi_ctlreg_out,
               portA_we    => open,
               portB_we    => open,
               portC_we    => open,
               portD_we    => spi_ctlreg_we,
               clk50       => clk);
               
   spi_out : spi_send
      port map(reset          => reset,
               flush          => flush,
               pMOSI          => spi_datareg_out,
               w_en           => w_en,
               cpu_clk        => clk,
               wrt_complete   => wrt_complete,
               addr           => spi_ctlreg_out(4 downto 3),
               done           => done,
               mosi           => mosi,
               sclk           => sclk,
               rst            => rst,
               ss             => ssvec);
               
   ss <= ssvec(0);
   dc <= spi_ctlreg_out(7);
   spi_ctlreg_in <= spi_ctlreg_out(7) & wrt_complete & done & spi_ctlreg_out(4 downto 3) & w_en & flush & reset;
   w_en <= spi_ctlreg_out(2);
   flush <= spi_ctlreg_out(1);
   reset <= spi_ctlreg_out(0);
   
   process(clk, wrt_complete, done , spi_ctlreg_we, clear_update_trigs)
   begin
      if (clear_update_trigs = '1') then
         update_bc_ctl5 <= '0';
      elsif rising_edge(wrt_complete)then
         update_bc_ctl5 <= '1';
      end if;
      if (clear_update_trigs = '1') then
         update_bc_ctl6 <= '0';
      elsif rising_edge(done)then
         update_bc_ctl6 <= '1';
      end if;
      if (clear_update_trigs = '1' and spi_ctlreg_we = '1') then
         clear_update_trigs <= '0';
      elsif (rising_edge(clk) and spi_ctlreg_we = '1') then
         clear_update_trigs <= '1';
      end if;
   end process;
   
   spi_ctlreg_we <= update_bc_ctl5 or update_bc_ctl6;
   
end structural;

