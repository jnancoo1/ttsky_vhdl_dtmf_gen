----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.05.2026 23:18:02
-- Design Name: 
-- Module Name: datapath - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity datapath is
   Port (  reset : in std_logic ;
           key_press : in std_logic;
           key_code :in std_logic_vector (3 downto 0);
           reference_clk : in std_logic;
           dtmf_en : in std_logic;
           dial_en : in std_logic;
           Fh : inout std_logic;
           Fl : inout std_logic);
           
end datapath;

architecture Behavioral of datapath is

component control_unit is
    Port (
        ref_clk            : in  std_logic;
        reset              : in  std_logic;

        dtmf_enable        : in  std_logic;
        dial_enable        : in  std_logic;
        number_entrered    : in  std_logic;

        fifo_empty         : in  std_logic;

        PauseTime_done     : in  std_logic;
        ToneTime_done      : in  std_logic;

        write_fifo         : inout std_logic;
        read_fifo          : inout std_logic;

        gen_tone           : inout std_logic;
        start_tone         : inout std_logic;

        rom_out            : inout std_logic;

        tone_pause         : inout std_logic;

        start_PauseTime    : inout std_logic;
        start_ToneTime     : inout std_logic
    );
end component;

component frequency_divider is
  Port(clk    : in std_logic;
       reset  : in std_logic;
	   clock1 : inout std_logic;
	   clock2 : inout std_logic); --2MHz clock signal
end component;

component fifo_adrr_queue is
    Port (
        key_code  : in  STD_LOGIC_VECTOR (3 downto 0);
        reset     : in  STD_LOGIC;
        read      : in  STD_LOGIC;
        write     : in  STD_LOGIC;
        clk       : in  STD_LOGIC;
        emp       : inout STD_LOGIC;
        data_out  : inout STD_LOGIC_VECTOR (3 downto 0)
    );
end component;

component mod201_timer is
  Port(clk : in std_logic;
       reset : in std_logic;
		 ce : in std_logic;
		 dataout : inout std_logic_vector(7 downto 0);
		 tc : inout std_logic);
end component;

component mux2to1 is
    port (
        w0, w1 : in STD_LOGIC; 
        s      : in STD_LOGIC; 
        f      : inout STD_LOGIC 
            );
end component;



component prog_freq_div is
    Port (
        Dh     : in  STD_LOGIC_VECTOR(11 downto 0);
        Dl     : in  STD_LOGIC_VECTOR(11 downto 0);

        reset  : in  STD_LOGIC;
        clk    : in  STD_LOGIC; -- 2.096 MHz clock

        load   : in  STD_LOGIC;
        enable : in  STD_LOGIC;

        fH     : inout STD_LOGIC;
        fL     : inout STD_LOGIC
    );
end component;

component rom is
    Port (data_in : in STD_LOGIC_VECTOR (3 downto 0);
          oe : in STD_LOGIC;
          ToneH_val : inout STD_LOGIC_VECTOR (11 downto 0);
          ToneL_val : inout STD_LOGIC_VECTOR (11 downto 0)
    );
end component;


component mod86_timer is
  Port(clk : in std_logic;
       reset : in std_logic;
		 ce : in std_logic;
		 dataout : out std_logic_vector(7 downto 0);
		 tc : out std_logic);
end component;

-- clocks
signal clk_1khz      : std_logic;
signal clk_2mhz      : std_logic;

-- FIFO
signal fifo_empty_s  : std_logic;
signal fifo_data_s   : std_logic_vector(3 downto 0);

-- ROM
signal toneH_s       : std_logic_vector(11 downto 0);
signal toneL_s       : std_logic_vector(11 downto 0);

-- timers
signal tone_done_s   : std_logic;
signal pause_done_s  : std_logic;

signal tone_cnt_s    : std_logic_vector(7 downto 0);
signal pause_cnt_s   : std_logic_vector(7 downto 0);

-- control unit outputs
signal write_fifo_s      : std_logic;
signal read_fifo_s       : std_logic;

signal gen_tone_s        : std_logic;
signal start_tone_s      : std_logic;

signal rom_out_s         : std_logic;

signal tone_pause_s      : std_logic;

signal start_pause_s     : std_logic;
signal start_toneTime_s  : std_logic;

-- programmable divider outputs
signal fh_raw_s      : std_logic;
signal fl_raw_s      : std_logic;

begin

cop1 : frequency_divider
port map(
    clk    => reference_clk,
    reset  => reset,

    clock1 => clk_1khz,
    clock2 => clk_2mhz
);

cop2 : control_unit
port map(
    ref_clk         => reference_clk,
    reset           => reset,

    dtmf_enable     => dtmf_en,
    dial_enable     => dial_en,
    number_entrered => key_press,

    fifo_empty      => fifo_empty_s,

    PauseTime_done  => pause_done_s,
    ToneTime_done   => tone_done_s,

    write_fifo      => write_fifo_s,
    read_fifo       => read_fifo_s,

    gen_tone        => gen_tone_s,
    start_tone      => start_tone_s,

    rom_out         => rom_out_s,

    tone_pause      => tone_pause_s,

    start_PauseTime => start_pause_s,
    start_ToneTime  => start_toneTime_s
);

cop3 : fifo_adrr_queue
port map(

    key_code => key_code,
    reset    => reset,

    read     => read_fifo_s,
    write    => write_fifo_s,

    clk      => reference_clk,

    emp      => fifo_empty_s,
    data_out => fifo_data_s
);


cop4 : rom
port map(

    data_in   => fifo_data_s,
    oe        => rom_out_s,

    ToneH_val => toneH_s,
    ToneL_val => toneL_s
);


cop5 : prog_freq_div
port map(

    Dh     => toneH_s,
    Dl     => toneL_s,

    reset  => reset,
    clk    => clk_2mhz,

    load   => start_tone_s,
    enable => gen_tone_s,

    fH     => fh_raw_s,
    fL     => fl_raw_s
);

cop6 : mod86_timer
port map(

    clk     => clk_1khz,
    reset   => reset,

    ce      => start_toneTime_s,

    dataout => tone_cnt_s,
    tc      => tone_done_s
);

cop7 : mod201_timer
port map(

    clk     => clk_1khz,
    reset   => reset,

    ce      => start_pause_s,

    dataout => pause_cnt_s,
    tc      => pause_done_s
);


cop8 : mux2to1
port map(
    w0 => '0',
    w1 => fh_raw_s,
    s  => tone_pause_s,
    f  => Fh
);

cop9 : mux2to1
port map(
    w0 => '0',
    w1 => fl_raw_s,
    s  => tone_pause_s,
    f  => Fl
);


end Behavioral;
