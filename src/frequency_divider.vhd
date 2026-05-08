library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity frequency_divider is
    Port (
        clk    : in  std_logic;
        reset  : in  std_logic;
        clock1 : out std_logic;
        clock2 : out std_logic
    );
end frequency_divider;

architecture Behavioral of frequency_divider is
begin

-- =========================
-- clk_akHz divider
-- =========================
clk_akHz : process(clk, reset)
    variable a1 : integer range 0 to 2 := 2;
begin
    if reset = '1' then
        a1 := 2;
        clock1 <= '0';

    elsif rising_edge(clk) then
        if a1 = 0 then
            a1 := 2;
            clock1 <= not clock1;
        else
            a1 := a1 - 1;
        end if;
    end if;
end process;

-- =========================
-- clk_bHz divider
-- =========================
clk_bHz : process(clk, reset)
    variable a2 : integer range 0 to 4000000 := 4000000;
begin
    if reset = '1' then
        a2 := 4000000;
        clock2 <= '0';

    elsif rising_edge(clk) then
        if a2 = 0 then
            a2 := 4000000;
            clock2 <= not clock2;
        else
            a2 := a2 - 1;
        end if;
    end if;
end process;

end Behavioral;
