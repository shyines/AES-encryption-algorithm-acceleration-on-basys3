library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL; -- Added for correct conversion

entity receivefsm is
    Port (
        clk     : in STD_LOGIC;
        rst     : in STD_LOGIC;
        baud_en : in STD_LOGIC;
        rx      : in STD_LOGIC;
        rx_data : out STD_LOGIC_VECTOR (7 downto 0);
        rx_rdy  : out STD_LOGIC
    );
end receivefsm;

architecture Behavioral of receivefsm is
    type state_type is (idle, start, bits, stop);
    signal state: state_type := idle;
    signal baud_cnt: STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal bit_cnt : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
begin

    process (clk) -- Synchronous process only
    begin
        if rising_edge(clk) then
            -- Default assignment: Pulse rx_rdy low by default
            rx_rdy <= '0'; 

            if rst = '1' then
                state <= idle;
                bit_cnt <= (others => '0');
                baud_cnt <= (others => '0');
            elsif baud_en = '1' then 
                case state is
                    when idle =>
                        bit_cnt <= (others => '0');
                        baud_cnt <= (others => '0');
                        if rx = '0' then
                            state <= start;
                        end if;

                    when start =>
                        if baud_cnt = 7 then
                            if rx = '0' then
                                baud_cnt <= (others => '0');
                                state <= bits;
                            else
                                state <= idle;
                            end if;
                        else
                            baud_cnt <= baud_cnt + 1;
                        end if;

                    when bits =>
                        if baud_cnt = 15 then 
                            baud_cnt <= (others => '0');
           
                            rx_data(to_integer(unsigned(bit_cnt))) <= rx; 
                            
                            if bit_cnt = 7 then
                                state <= stop;
                                rx_rdy <= '1'; 
                            else
                                bit_cnt <= bit_cnt + 1;
                            end if;
                        else
                            baud_cnt <= baud_cnt + 1;
                        end if;

                    when stop =>
                        if baud_cnt = 15 then
                            baud_cnt <= (others => '0');
                            state <= idle;
                        else
                            baud_cnt <= baud_cnt + 1;
                        end if;
                end case;
            end if;
        end if;
    end process;
end Behavioral;