----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.05.2026 00:20:20
-- Design Name: 
-- Module Name: fifo_adrr_queue - Behavioral
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
use ieee.numeric_std.all; 


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fifo_adrr_queue is
    Port (
        key_code  : in  STD_LOGIC_VECTOR (3 downto 0);
        reset     : in  STD_LOGIC;
        read      : in  STD_LOGIC;
        write     : in  STD_LOGIC;
        clk       : in  STD_LOGIC;
        emp       : inout STD_LOGIC;
        data_out  : inout STD_LOGIC_VECTOR (3 downto 0)
    );
end fifo_adrr_queue;

architecture Behavioral of fifo_adrr_queue is

    type fifo_array_t is array (7 downto 0) of std_logic_vector(3 downto 0);

    signal rd_ptr     : unsigned(2 downto 0) := (others => '0');
    signal write_ptr  : unsigned(2 downto 0) := (others => '0');
    signal count      : unsigned(3 downto 0) := (others => '0');

    signal mem        : fifo_array_t := (others => (others => '0'));
    signal dout_reg   : std_logic_vector(3 downto 0) := (others => '0');

begin

    data_out <= dout_reg;
    emp <= '1' when count = 0 else '0';

process(clk, reset)
begin

    if reset = '1' then
        rd_ptr    <= (others => '0');
        write_ptr <= (others => '0');
        count     <= (others => '0');
        dout_reg  <= (others => '0');


    elsif rising_edge(clk) then

        -- WRITE
        if write = '1' then
            if count < 8 then
                mem(to_integer(write_ptr)) <= key_code;

                if write_ptr = "111" then
                    write_ptr <= (others => '0');
                else
                    write_ptr <= write_ptr + 1;
                end if;

                count <= count + 1;
            end if;
            
            elsif read = '1' then
            if count > 0 then
                dout_reg <= mem(to_integer(rd_ptr));

                if rd_ptr = "111" then
                    rd_ptr <= (others => '0');
                else
                    rd_ptr <= rd_ptr + 1;
                end if;

                count <= count - 1;
            end if;

        end if;


    end if;

end process;

end Behavioral;