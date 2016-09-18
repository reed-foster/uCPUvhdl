----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Reed Foster
-- 
-- Create Date:    22:28:22 03/31/2016 
-- Design Name: 
-- Module Name:    instruction_fetch - structural 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- instruction fetch section of the cpu
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_fetch is
   generic (romstartaddr : natural := 128);
   port (clk : in std_logic;
         ringct0        : in std_logic;
         ringct1        : in std_logic;
         ringct2        : in std_logic;
         pc_in          : in std_logic_vector (15 downto 0);
         instr_byte_ser : in std_logic_vector (7 downto 0);
         instr_word_out	: out std_logic_vector (15 downto 0);
         pc_out         : out std_logic_vector (15 downto 0));
end instruction_fetch;

architecture structural of instruction_fetch is
   signal reg_we    : std_logic := '0';
   signal ishift_we : std_logic := '0';
   signal pcmux_out : std_logic_vector (15 downto 0) := (others => '0');
   signal pcinc_out : std_logic_vector (15 downto 0) := (others => '0');
   signal pcout_tmp : std_logic_vector (15 downto 0) := (others => '0');
	
   component instructionshifter is
      port (shift_in  : in  std_logic_vector (7 downto 0);
            clk       : in  std_logic;
            en        : in  std_logic;
            shift_out : out std_logic_vector (15 downto 0));
      end component;
      
      component adder is
         generic(dwidth : positive);
         port (a : in  std_logic_vector (dwidth-1 downto 0);
               b : in  std_logic_vector (dwidth-1 downto 0) := (dwidth-1 downto 1 => '0') & '1';
               s : out std_logic_vector (dwidth-1 downto 0));
      end component;
      
      component reg is
         generic(dwidth : positive;
                 q_init : natural);
         port (D   : in  std_logic_vector (dwidth-1 downto 0);
               en  : in  std_logic;
               clk : in  std_logic;
               clr : in  std_logic := '0';
               Q   : out std_logic_vector (dwidth-1 downto 0));
      end component;
         
      component or_gate_2 is
         port (a : in  std_logic;
               b : in  std_logic;
               s : out std_logic);
      end component;
   
      component or_gate_3 is
         port (a : in  std_logic;
               b : in  std_logic;
               c : in  std_logic;
               s : out  std_logic);
      end component;
      
      component mux is
         generic (dwidth : positive);
            port (data_in_0 : in std_logic_vector(dwidth-1 downto 0);
                  data_in_1 : in std_logic_vector(dwidth-1 downto 0);
                  sel       : in std_logic;
                  data_out  : out std_logic_vector(dwidth-1 downto 0));
      end component;
      
begin
	--multiplexer for pc
	pcmux0			: mux 	generic map(dwidth 		=> 16)
										port map(data_in_0	=> pcinc_out,
													data_in_1	=> pc_in,
													sel			=> ringct2,
													data_out		=> pcmux_out);
													
	--adder; increments pc
	pcinc0 			: adder	generic map(dwidth 		=> 16)
										port map(a				=> pcout_tmp,
													b				=> open,
													s				=> pcinc_out);
													
	--register
	pcreg0 			: reg		generic map(dwidth		=> 16,
													q_init		=> romstartaddr)
										port map(D				=> pcmux_out,
													en				=> reg_we,
													clk			=> clk,
													clr			=> open,
													Q				=> pcout_tmp);
													
	--specialized shift register
	ishift0			: instructionshifter
										port map(shift_in		=> instr_byte_ser,
													clk			=> clk,
													en				=> ishift_we,
													shift_out	=> instr_word_out);
													
	--or gate to enable pc
	reg_we_or0		: or_gate_3	port map(a 				=> ringct0,
													b 				=> ringct1,
													c 				=> ringct2,
													s 				=> reg_we);
													
	--or gate to enable ishift instruction shifter
	ishift_we_or0	: or_gate_2		port map(a => ringct0,
													b => ringct1,
													s => ishift_we);
													
	--set pcout to value of temp signal
	pc_out <= pcout_tmp;
end structural;
