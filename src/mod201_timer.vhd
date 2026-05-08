--------------------------------------------------------------------------------
-- Company: Ultimate Virtual Market Limited
-- Engineer: Marcus Lloyde George
--
-- Create Date:    02:32:26 04/29/09
-- Design Name:    
-- Module Name:    modulo10_counter - Behavioral
-- Project Name:   
-- Target Device:  
-- Tool versions:  Xilinx 7.1 ISE
-- Description:
--
-- Dependencies:
-- 
-- Revision:  1
-- Revision 0.01 - File Created
-- Additional Comments:	 This IPcore can be used by anyone as long as 
--								 this Header Comment Block	is retained in this 
--								 position of the .vhd file
-- 
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mod201_timer is
  Port(clk : in std_logic;
       reset : in std_logic;
		 ce : in std_logic;
		 dataout : inout std_logic_vector(7 downto 0);
		 tc : inout std_logic);
end mod201_timer;

architecture Behavioral of mod201_timer is

signal cnt : std_logic_vector(7 downto 0);

begin
  process(clk,reset,ce,cnt)
    begin
	   if(reset = '1')then
		  cnt <= "00000000";
      elsif(clk'event and clk = '1') then
        if(ce = '1')then
		    if(cnt = "11001000") then
		      cnt <= "00000000";
		    else
			   cnt <= cnt + 1;
		    end if;
		  end if;
	   end if;
    end process;

dataout <= cnt;

tc <= '1' when cnt = "11001000" else '0';
end Behavioral;