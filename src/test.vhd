library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity for a single I/O test
entity test is
    Port ( 
        sw  : in  STD_LOGIC; -- Single Switch input
        led : out STD_LOGIC  -- Single LED output
    );
end test;

architecture Behavioral of test is
begin
    -- Direct mapping: Switch 0 controls LED 0
    led <= sw;
end Behavioral;