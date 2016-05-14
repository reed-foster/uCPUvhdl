----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:23:42 05/06/2016 
-- Design Name: 
-- Module Name:    spi_send - structural 
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

entity spi_send is
   generic(prescalar : positive := 8);
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
end spi_send;

architecture structural of spi_send is
   
   --clock divider
   signal clk : std_logic := '0';
   
   --reset
   signal reset_low : std_logic := '0';
   
   --fifo
   signal fifo_empty, fifo_full, fifo_hasdata, dequeue, rts, rts_set, write_trig, notwrite_trig : std_logic := '0';
   signal fifo_out : std_logic_vector (7 downto 0) := "00000000";
   
   --sender
   signal write_pmosi : std_logic := '0';
   signal not_clock : std_logic := '0';
   
   --ss and cs
   signal cs_trig, cs_internal, cs_clear :std_logic := '0';
   
   --counter
   signal counter_out, send_complete, done_tmp, counter_reset : std_logic := '0';
   signal const1 : std_logic := '1';
   
   --sclk_gen
   signal sclk_en : std_logic := '0';
   signal sclk_pdata : std_logic_vector(7 downto 0) := "00000000";
   
   --components
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
	
   component d_ff is
      port (clk    : in  std_logic := '0';
            d      : in  std_logic := '0';
            en     : in  std_logic := '1';
            clear  : in  std_logic := '0';
            q      : out std_logic);
   end component;
   
   component d_latch is
      port (trig   : in  std_logic;
            clear  : in  std_logic;
            q      : out std_logic);
   end component;
   
   component write_latch is
      port (trig    : in  std_logic;
            clk     : in  std_logic;
            dequeue : in  std_logic;
            enqueue : out std_logic);
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
   
   component ss_decoder is
      port (cs_in : in  std_logic;
            addr  : in  std_logic_vector (1 downto 0);
            ss    : out std_logic_vector (3 downto 0));
   end component;
   
   component clk_div is
      generic(prescalar : natural := 8);
      port (clk_in  : in  std_logic;
            clk_out : out std_logic);
   end component;
   
begin
   
   queue : fifo_opt
      port map(d_in     => pMOSI,
               d_out    => fifo_out,
               enqueue  => write_trig,
               dequeue  => dequeue,
               clock    => clk,
               clear    => flush,
               full     => fifo_full,
               empty    => fifo_empty);

   sender : sreg
      port map(pdata_in    => fifo_out,
               pdata_out   => open,
               data_in     => open,
               data_out    => mosi,
               shift       => cs_internal,
               load        => write_pmosi,
               clock       => not_clock,
               clear       => reset_low);

   counter : sreg
      port map(pdata_in    => open,
               pdata_out   => sclk_pdata,
               data_in     => const1,
               data_out    => counter_out,
               shift       => cs_internal,
               load        => open,
               clock       => not_clock,
               clear       => counter_reset);

   rtsff : d_latch
      port map(trig     => rts_set,
               clear    => write_pmosi,
               q        => rts);

   write_pmosiff : d_ff
      port map(clk      => clk,
               d        => dequeue,
               en       => open,
               clear    => reset_low,
               q        => write_pmosi);

   cs_trigff : d_latch
      port map(trig     => clk,
               clear    => reset_low,
               q        => cs_trig);

   write_trigff : write_latch
      port map(trig     => w_en,
               clk      => clk,
               dequeue  => dequeue,
               enqueue  => write_trig);

   counter_outff : d_ff
      port map(clk      => clk,
               d        => counter_out,
               en       => open,
               clear    => open,
               q        => send_complete);

   doneff : d_latch
      port map(trig     => send_complete,
               clear    => dequeue,
               q        => done_tmp);

   csff : d_ff
      port map(clk      => not_clock,
               d        => cs_trig,
               en       => write_pmosi,
               clear    => cs_clear,
               q        => cs_internal);

   ss_outgen : ss_decoder
      port map(cs_in => cs_internal,
               addr  => addr,
               ss    => ss);
   
   clk_divider : clk_div
      generic map(prescalar => prescalar)
      port map(clk_in  => cpu_clk,
               clk_out => clk);
   
   fifo_hasdata <= fifo_empty nor fifo_full;
   dequeue <= fifo_hasdata and rts;
   cs_clear <= reset_low or send_complete;
   sclk_en <= not(sclk_pdata(7)) and (sclk_pdata(6) or sclk_pdata(5) or sclk_pdata(4) or sclk_pdata(3) or sclk_pdata(2) or sclk_pdata(1) or sclk_pdata(0) or cs_internal);
   sclk <= not (sclk_en) or (sclk_en and clk);
   not_clock <= not clk;
   counter_reset <= write_pmosi or done_tmp;
   done <= done_tmp;
   rst <= reset;
   reset_low <= not reset;
   rts_set <= reset_low or send_complete;
   const1 <= '1';
   wrt_complete <= not write_trig;
end structural;

