library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_unit is
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
end control_unit;

architecture Behavioral of control_unit is

    type state_type is (
        idle_state,
        write_fifo_state,
        read_fifo_state,
        read_rom_state,
        load_div_state,
        count_state,
        pause_state
    );

    signal current_state, next_state : state_type;

begin


    process(ref_clk, reset)
    begin
        if reset = '1' then
            current_state <= idle_state;

        elsif rising_edge(ref_clk) then
            current_state <= next_state;
        end if;
    end process;

    process(current_state,
            dtmf_enable,
            number_entrered,
            dial_enable,
            ToneTime_done,
            PauseTime_done,
            fifo_empty)
    begin

        -- default
        next_state <= current_state;

        case current_state is

            --------------------------------------------------------
            when idle_state =>

                if (dtmf_enable = '1' and number_entrered = '1') then
                    next_state <= write_fifo_state;
                else
                    next_state <= idle_state;
                end if;


            --------------------------------------------------------
            when write_fifo_state =>

                if dial_enable = '1' then
                    next_state <= read_fifo_state;
                else
                    next_state <= idle_state;
                end if;


            --------------------------------------------------------
            when read_fifo_state =>

                if fifo_empty = '0' then
                    next_state <= read_rom_state;
                else
                    next_state <= idle_state;
                end if;


            when read_rom_state =>
                next_state <= load_div_state;

            when load_div_state =>
                next_state <= count_state;


            when count_state =>

                if ToneTime_done = '1' then
                    next_state <= pause_state;
                else
                    next_state <= count_state;
                end if;


            when pause_state =>
                if PauseTime_done = '1' then
                    if dial_enable = '1' then
                        next_state <= read_fifo_state;
                    else
                        next_state <= idle_state;
                    end if;

                else
                    next_state <= pause_state;
                end if;


            when others =>

                next_state <= idle_state;

        end case;
    end process;


    process(current_state)
    begin

        write_fifo      <= '0';
        read_fifo       <= '0';

        gen_tone        <= '0';
        start_tone      <= '0';

        rom_out         <= '0';

        tone_pause      <= '0';

        start_PauseTime <= '0';
        start_ToneTime  <= '0';

        case current_state is

            when idle_state =>
                null;

            when write_fifo_state =>
                write_fifo <= '1';

            when read_fifo_state =>
                read_fifo <= '1';


            when read_rom_state =>
                rom_out <= '1';


            when load_div_state =>
                start_tone <= '1';

            when count_state =>
            
                gen_tone      <= '1';
                start_ToneTime <= '1';

            when pause_state =>

                tone_pause      <= '1';
                start_PauseTime <= '1';


            when others =>
                null;

        end case;
    end process;

end Behavioral;