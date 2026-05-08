library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tt_um_dtmf_gen is
    port (
        ui_in   : in  std_logic_vector(7 downto 0);
        uo_out  : out std_logic_vector(7 downto 0);

        uio_in  : in  std_logic_vector(7 downto 0);
        uio_out : out std_logic_vector(7 downto 0);
        uio_oe  : out std_logic_vector(7 downto 0);

        ena     : in  std_logic;
        clk     : in  std_logic;
        rst_n   : in  std_logic
    );
end tt_um_dtmf_gen;

architecture Behavioral of tt_um_example is

component datapath is
   Port (
       reset         : in std_logic;
       key_press     : in std_logic;
       key_code      : in std_logic_vector (3 downto 0);
       reference_clk : in std_logic;
       dtmf_en       : in std_logic;
       dial_en       : in std_logic;
       Fh            : inout std_logic;
       Fl            : inout std_logic
   );
end component;

signal reset_s      : std_logic;

signal key_press_s  : std_logic;
signal dtmf_en_s    : std_logic;
signal dial_en_s    : std_logic;

signal key_code_s   : std_logic_vector(3 downto 0);

signal fh_s         : std_logic;
signal fl_s         : std_logic;

begin


-- TinyTapeout reset is ACTIVE LOW
reset_s <= not rst_n;

-- Example pin mapping
key_press_s <= ui_in(0);

key_code_s <= ui_in(4 downto 1);

dtmf_en_s <= ui_in(5);

dial_en_s <= ui_in(6);

-- DATAPATH INSTANCE
UUT : datapath
port map(
    reset         => reset_s,
    key_press     => key_press_s,
    key_code      => key_code_s,
    reference_clk => clk,
    dtmf_en       => dtmf_en_s,
    dial_en       => dial_en_s,
    Fh            => fh_s,
    Fl            => fl_s
);

uo_out(0) <= fh_s;
uo_out(1) <= fl_s;

uo_out(7 downto 2) <= (others => '0');

uio_out <= (others => '0');
uio_oe  <= (others => '0');

end Behavioral;
