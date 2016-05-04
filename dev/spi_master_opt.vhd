----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:03:42 05/02/2016 
-- Design Name: 
-- Module Name:    spi_master_opt - structural 
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

entity spi_master_opt is
   port (reset	: in  std_logic;
         flush	: in  std_logic;
         pMOSI	: in  std_logic_vector (7 downto 0);
         w_en	: in  std_logic;
         clk	: in  std_logic;
         addr	: in  std_logic_vector (1 downto 0);
         pMISO	: out std_logic_vector (7 downto 0);
         r_en	: in  std_logic;
         done	: out std_logic;
         miso   : in  std_logic;
         mosi   : out std_logic;
         sclk   : out std_logic;
         rst    : out std_logic;
         ss     : out std_logic_vector (3 downto 0));
end spi_master_opt;

architecture structural of spi_master_opt is

   --queue signals
   signal p_shiftout, p_shiftin : std_logic_vector (7 downto 0);
   signal in_empty, out_empty, in_full, out_full, in_dequeue, out_dequeue, in_enqueue, out_enqueue : std_logic := '0';

   signal done_tmp : std_logic := '0';
   
   signal cs : std_logic := '0';
   signal write_pmosi : std_logic := '0';
   
   signal notclock, notreset : std_logic := '0';
   
   signal startcnt, send_complete : std_logic := '0';
   
   signal const1 : std_logic := '1'; --used for sreg that "counts"
   
   component fifo_opt is
      port (d_in     : in  std_logic_vector (7 downto 0);
            d_out    : out std_logic_vector (7 downto 0);
            enqueue  : in  std_logic;
            dequeue  : in  std_logic;
            clock    : in  std_logic;
            clear    : in  std_logic;
            full     : out std_logic;
            empty    : out std_logic);
   end component;
	
   component trig_ff is
      port (trig_in  : in  std_logic;
            trig_out : out std_logic;
            clk      : in  std_logic);
   end component;
   
   component sreg is
      generic(len : positive := 8);
      port (pdata_in    : in  std_logic_vector (len-1 downto 0) := (len-1 downto 0 => '0');
            pdata_out   : out std_logic_vector (len-1 downto 0);
            data_in     : in  std_logic := '0';
            data_out    : out std_logic;
            shift       : in  std_logic := '1';
            load        : in  std_logic := '0';
            clock       : in  std_logic;
            clear       : in  std_logic := '0');
   end component;

begin

   in_queue : fifo_opt
      port map(d_in     => pMOSI,
               d_out    => p_shiftout,
               enqueue  => in_enqueue,
               dequeue  => in_dequeue,
               clock    => clk,
               clear    => flush,
               full     => in_full,
               empty    => in_empty);

   out_queue : fifo_opt
      port map(d_in     => p_shiftin,
               d_out    => pMISO,
               enqueue  => out_enqueue,
               dequeue  => out_dequeue,
               clock    => clk,
               clear    => flush,
               full     => out_full,
               empty    => out_empty);
	
   w_trig_ff : trig_ff
      port map(trig_in  => w_en,
               trig_out => in_enqueue,
               clk      => clk);
	
   r_trig_ff : trig_ff
      port map(trig_in  => r_en,
               trig_out => out_dequeue,
               clk      => clk);

   enqueue_trig_ff : trig_ff
      port map(trig_in  => done_tmp,
               trig_out => out_enqueue,
               clk      => clk);
   
   send : sreg
      port map(pdata_in    => p_shiftout,
               pdata_out   => open,
               data_in     => open,
               data_out    => mosi,
               shift       => cs,
               load        => write_pmosi,
               clock       => notclock,
               clear       => notreset);
               
   receive : sreg
      port map(pdata_in    => open,
               pdata_out   => p_shiftin,
               data_in     => miso,
               data_out    => open,
               shift       => cs,
               load        => open,
               clock       => notclock,
               clear       => notreset);
               
   bitcounter : sreg
      port map(pdata_in    => open,
               pdata_out   => open,
               data_in     => const1,
               data_out    => send_complete,
               shift       => cs,
               load        => open,
               clock       => notclock,
               clear       => startcnt);
   
   startcnt <= notreset or write_pmosi;
   notreset <= not reset;
   notclock <= not clk;
   sclk <= clk and cs;
   ss <= "1110" when (addr = "00" and cs = '1') else
         "1101" when (addr = "01" and cs = '1') else
         "1011" when (addr = "10" and cs = '1') else
         "0111" when (addr = "11" and cs = '1') else
         "1111";
end structural;

