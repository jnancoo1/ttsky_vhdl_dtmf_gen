----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.05.2026 18:43:27
-- Design Name: 
-- Module Name: mod86_timer - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mod86_timer is
  Port(clk : in std_logic;
       reset : in std_logic;
		 ce : in std_logic;
		 dataout : out std_logic_vector(7 downto 0);
		 tc : out std_logic);
end mod86_timer;

architecture Behavioral of mod86_timer is

signal cnt : std_logic_vector(7 downto 0);

begin
  process(clk,reset,ce,cnt)
    begin
	   if(reset = '1')then
		  cnt <= "01010110";
      elsif(clk'event and clk = '1') then
        if(ce = '1')then
		    if(cnt = "01010110") then
		      cnt <= "00000000";
		    else
			   cnt <= cnt + 1;
		    end if;
		  end if;
	   end if;
    end process;

dataout <= cnt;

tc <= '1' when cnt = "01010110" else '0';
end Behavioral;

