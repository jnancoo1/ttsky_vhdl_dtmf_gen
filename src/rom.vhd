----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.05.2026 14:01:08
-- Design Name: 
-- Module Name: rom - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rom is
    Port (data_in : in STD_LOGIC_VECTOR (3 downto 0);
          oe : in STD_LOGIC;
          ToneH_val : out STD_LOGIC_VECTOR (11 downto 0);
          ToneL_val : out STD_LOGIC_VECTOR (11 downto 0)
    );
end rom;

architecture Behavioral of rom is

begin

process (oe,data_in)
begin

    if oe='1' then
    
      case data_in is

            -- Key 1: 697 Hz, 1209 Hz
            when "0001" =>
                ToneL_val <= std_logic_vector(to_unsigned(3006, 12));
                ToneH_val <= std_logic_vector(to_unsigned(1734, 12));

            -- Key 2: 697 Hz, 1336 Hz
            when "0010" =>
                ToneL_val <= std_logic_vector(to_unsigned(3006, 12));
                ToneH_val <= std_logic_vector(to_unsigned(1569, 12));

            -- Key 3: 697 Hz, 1477 Hz
            when "0011" =>
                ToneL_val <= std_logic_vector(to_unsigned(3006, 12));
                ToneH_val <= std_logic_vector(to_unsigned(1419, 12));

            -- Key 4: 770 Hz, 1209 Hz
            when "0100" =>
                ToneL_val <= std_logic_vector(to_unsigned(2722, 12));
                ToneH_val <= std_logic_vector(to_unsigned(1734, 12));

            -- Key 5: 770 Hz, 1336 Hz
            when "0101" =>
                ToneL_val <= std_logic_vector(to_unsigned(2722, 12));
                ToneH_val <= std_logic_vector(to_unsigned(1569, 12));

            -- Key 6: 770 Hz, 1477 Hz
            when "0110" =>
                ToneL_val <= std_logic_vector(to_unsigned(2722, 12));
                ToneH_val <= std_logic_vector(to_unsigned(1419, 12));

            -- Key 7: 852 Hz, 1209 Hz
            when "0111" =>
                ToneL_val <= std_logic_vector(to_unsigned(2460, 12));
                ToneH_val <= std_logic_vector(to_unsigned(1734, 12));

            -- Key 8: 852 Hz, 1336 Hz
            when "1000" =>
                ToneL_val <= std_logic_vector(to_unsigned(2460, 12));
                ToneH_val <= std_logic_vector(to_unsigned(1569, 12));

            -- Key 9: 852 Hz, 1477 Hz
            when "1001" =>
                ToneL_val <= std_logic_vector(to_unsigned(2460, 12));
                ToneH_val <= std_logic_vector(to_unsigned(1419, 12));

            -- Key 0: 941 Hz, 1336 Hz
            when "0000" =>
                ToneL_val <= std_logic_vector(to_unsigned(2228, 12));
                ToneH_val <= std_logic_vector(to_unsigned(1569, 12));
    
    
            when others =>
                ToneL_val <= (others => '0');
                ToneH_val <= (others => '0');
        
        end case;
        
        elsif oe='0' then
        ToneL_val <= (others => '0');
        ToneH_val <= (others => '0');

    end if;

end process;


end Behavioral;
