----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.05.2026 01:28:23
-- Design Name: 
-- Module Name: mux - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use ieee.numeric_std.all; 

entity mux2to1 is
    port (
        w0, w1 : in STD_LOGIC; 
        s      : in STD_LOGIC; 
        f      : inout STD_LOGIC 
            );
end mux2to1;

architecture Behavioral of mux2to1 is
begin
    process(w0, w1, s)
    begin
        if s = '0' then
            f <= w0;
        else
            f <= w1;
        end if;
    end process;
end Behavioral;
