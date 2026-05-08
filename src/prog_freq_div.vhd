----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 06.05.2026
-- Design Name:
-- Module Name: prog_freq_div
-- Project Name: DTMF Generator
-- Description:
-- Programmable dual frequency divider for DTMF generation
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity prog_freq_div is
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
end prog_freq_div;

architecture Behavioral of prog_freq_div is

    signal countH : unsigned(11 downto 0) := (others => '0');
    signal countL : unsigned(11 downto 0) := (others => '0');

    signal Dh_reg : unsigned(11 downto 0) := (others => '0');
    signal Dl_reg : unsigned(11 downto 0) := (others => '0');

    signal fh_reg : STD_LOGIC := '0';
    signal fl_reg : STD_LOGIC := '0';

begin

process(clk, reset)
begin

    if reset = '1' then

        countH <= (others => '0');
        countL <= (others => '0');

        Dh_reg <= (others => '0');
        Dl_reg <= (others => '0');

        fh_reg <= '0';
        fl_reg <= '0';


    elsif rising_edge(clk) then

        if load = '1' then
            Dh_reg <= unsigned(Dh);
            Dl_reg <= unsigned(Dl);
            countH <= (others => '0');
            countL <= (others => '0');
            fh_reg <= '0';
            fl_reg <= '0';
            
        elsif enable = '1' then
            if Dh_reg /= 0 then

                if countH = (Dh_reg - 1) then
                    countH <= (others => '0');
                    fh_reg <= not fh_reg;
                else
                    countH <= countH + 1;
                end if;
            end if;
            if Dl_reg /= 0 then
                if countL = (Dl_reg - 1) then
                    countL <= (others => '0');
                    fl_reg <= not fl_reg;
                else
                    countL <= countL + 1;
                end if;
            end if;
        else
            countH <= (others => '0');
            countL <= (others => '0');
            fh_reg <= '0';
            fl_reg <= '0';
        end if;
    end if;
end process;

fH <= fh_reg;
fL <= fl_reg;

end Behavioral;